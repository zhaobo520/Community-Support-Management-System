<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- File Upload Component -->
<style>
    .upload-container { margin: 20px 0; }
    .upload-area {
        border: 2px dashed #d1d5db;
        border-radius: 12px;
        padding: 30px;
        text-align: center;
        background: #f9fafb;
        transition: all 0.3s;
        cursor: pointer;
    }
    .upload-area:hover { border-color: #3b82f6; background: #eff6ff; }
    .upload-area.dragover { border-color: #3b82f6; background: #dbeafe; }
    .upload-icon { font-size: 48px; color: #9ca3af; margin-bottom: 10px; }
    .upload-text { color: #6b7280; font-size: 14px; }
    .upload-hint { color: #9ca3af; font-size: 12px; margin-top: 5px; }
    .file-input { display: none; }
    .preview-container {
        margin-top: 20px;
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
        gap: 15px;
    }
    .preview-item {
        position: relative;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .preview-image { width: 100%; height: 150px; object-fit: cover; }
    .preview-doc {
        width: 100%; height: 150px; display: flex; flex-direction: column;
        align-items: center; justify-content: center; background: #f3f4f6;
    }
    .doc-icon { font-size: 48px; color: #6b7280; margin-bottom: 10px; }
    .doc-name {
        font-size: 12px; color: #374151; padding: 0 10px;
        text-align: center; word-break: break-all;
    }
    .preview-delete {
        position: absolute; top: 5px; right: 5px; width: 24px; height: 24px;
        background: rgba(239, 68, 68, 0.9); color: white; border: none;
        border-radius: 50%; cursor: pointer; font-size: 14px;
        display: flex; align-items: center; justify-content: center;
    }
    .preview-delete:hover { background: #dc2626; }
    .upload-progress {
        margin-top: 10px; height: 4px; background: #e5e7eb;
        border-radius: 2px; overflow: hidden; display: none;
    }
    .upload-progress-bar {
        height: 100%; background: linear-gradient(90deg, #3b82f6, #2563eb);
        width: 0%; transition: width 0.3s;
    }
    .preview-status {
        position: absolute; left: 0; right: 0; bottom: 0;
        background: rgba(0,0,0,0.55); color: #fff; font-size: 12px; padding: 6px 8px;
    }
</style>

<div class="upload-container">
    <div class="upload-area" id="uploadArea" onclick="document.getElementById('fileInput').click()">
        <div class="upload-icon">📁</div>
        <div class="upload-text">点击或拖拽文件到此处上传</div>
        <div class="upload-hint">支持 JPG、PNG、GIF、PDF、DOC 等格式，单个文件不超过10MB</div>
        <input type="file" id="fileInput" class="file-input" accept="image/*,.pdf,.doc,.docx" multiple>
    </div>
    <div class="upload-progress" id="uploadProgress">
        <div class="upload-progress-bar" id="uploadProgressBar"></div>
    </div>
    <div class="preview-container" id="previewContainer"></div>
</div>

<script>
var uploadedFiles = [];
var tempPreviewMap = {};

document.getElementById('fileInput').addEventListener('change', function(e) {
    handleFiles(e.target.files);
    e.target.value = '';
});

var uploadArea = document.getElementById('uploadArea');
uploadArea.addEventListener('dragover', function(e) {
    e.preventDefault();
    e.stopPropagation();
    uploadArea.classList.add('dragover');
});
uploadArea.addEventListener('dragleave', function(e) {
    e.preventDefault();
    e.stopPropagation();
    uploadArea.classList.remove('dragover');
});
uploadArea.addEventListener('drop', function(e) {
    e.preventDefault();
    e.stopPropagation();
    uploadArea.classList.remove('dragover');
    handleFiles(e.dataTransfer.files);
});

function getCurrentUploadType() {
    return document.getElementById('uploadType') ? document.getElementById('uploadType').value : 'avatar';
}

function getFullFileUrl(url) {
    if (!url) return '';
    var contextPath = '${pageContext.request.contextPath}';
    if (url.indexOf('http://') === 0 || url.indexOf('https://') === 0 || url.indexOf('data:') === 0) {
        return url;
    }
    return url.indexOf(contextPath) === 0 ? url : contextPath + url;
}

function updateCurrentPhotoPreview(url) {
    var img = document.getElementById('currentPhotoPreview');
    var hint = document.getElementById('currentPhotoHint');
    if (img && url) {
        img.src = getFullFileUrl(url);
        img.style.display = 'block';
    }
    if (hint) {
        hint.style.display = 'block';
    }
}

function handleFiles(files) {
    var uploadType = getCurrentUploadType();
    Array.from(files).forEach(function(file) {
        var tempId = addLocalPreview(file);
        uploadFile(file, uploadType, tempId);
    });
}

function uploadFile(file, uploadType, tempId) {
    var formData = new FormData();
    formData.append('file', file);
    var uploadUrl = '${pageContext.request.contextPath}/upload/' + uploadType;
    document.getElementById('uploadProgress').style.display = 'block';
    var xhr = new XMLHttpRequest();

    xhr.upload.addEventListener('progress', function(e) {
        if (e.lengthComputable) {
            document.getElementById('uploadProgressBar').style.width = ((e.loaded / e.total) * 100) + '%';
        }
    });

    xhr.addEventListener('load', function() {
        document.getElementById('uploadProgress').style.display = 'none';
        document.getElementById('uploadProgressBar').style.width = '0%';
        if (xhr.status === 200) {
            var response = JSON.parse(xhr.responseText);
            if (response.code === 200) {
                uploadedFiles.push(response.data);
                replaceTempPreview(tempId, response.data);
                updateCurrentPhotoPreview(response.data.url);
                alert('上传成功！');
            } else {
                removeTempPreview(tempId);
                alert('上传失败：' + response.message);
            }
        } else {
            removeTempPreview(tempId);
            alert('上传失败，请重试');
        }
    });

    xhr.addEventListener('error', function() {
        document.getElementById('uploadProgress').style.display = 'none';
        document.getElementById('uploadProgressBar').style.width = '0%';
        removeTempPreview(tempId);
        alert('上传失败，请重试');
    });

    xhr.open('POST', uploadUrl);
    xhr.send(formData);
}

function addLocalPreview(file) {
    var container = document.getElementById('previewContainer');
    var div = document.createElement('div');
    var tempId = 'temp_' + Date.now() + '_' + Math.random().toString(36).substring(2, 8);
    div.className = 'preview-item';
    div.dataset.tempId = tempId;

    if (file.type && file.type.indexOf('image/') === 0) {
        var reader = new FileReader();
        reader.onload = function(e) {
            div.innerHTML = '<img src="' + e.target.result + '" class="preview-image" alt="Preview">' +
                '<div class="preview-status">本地预览，上传中...</div>';
            updateCurrentPhotoPreview(e.target.result);
        };
        reader.readAsDataURL(file);
    } else {
        div.innerHTML = '<div class="preview-doc"><div class="doc-icon">📄</div><div class="doc-name">' + file.name + '</div></div>' +
            '<div class="preview-status">上传中...</div>';
    }

    container.appendChild(div);
    tempPreviewMap[tempId] = div;
    return tempId;
}

function renderPreviewContent(div, fileData) {
    var fullUrl = getFullFileUrl(fileData.url);
    var isImage = fileData.type === 'image' || /\.(jpg|jpeg|png|gif|webp)$/i.test(fileData.url || '');
    if (isImage) {
        div.innerHTML = '<img src="' + fullUrl + '" class="preview-image" alt="Preview">' +
            '<button class="preview-delete" onclick="deleteFile(\'' + fileData.filename + '\')">×</button>';
    } else {
        div.innerHTML = '<div class="preview-doc"><div class="doc-icon">📄</div><div class="doc-name">' + (fileData.originalName || fileData.filename) + '</div></div>' +
            '<button class="preview-delete" onclick="deleteFile(\'' + fileData.filename + '\')">×</button>';
    }
}

function replaceTempPreview(tempId, fileData) {
    var div = tempPreviewMap[tempId];
    if (!div) {
        addPreview(fileData);
        return;
    }
    delete tempPreviewMap[tempId];
    div.removeAttribute('data-temp-id');
    div.dataset.filename = fileData.filename;
    renderPreviewContent(div, fileData);
}

function removeTempPreview(tempId) {
    var div = tempPreviewMap[tempId];
    if (div) {
        div.remove();
        delete tempPreviewMap[tempId];
    }
}

function addPreview(fileData) {
    var container = document.getElementById('previewContainer');
    var div = document.createElement('div');
    div.className = 'preview-item';
    div.dataset.filename = fileData.filename;
    renderPreviewContent(div, fileData);
    container.appendChild(div);
}

function deleteFile(filename) {
    if (!confirm('确定要删除这个文件吗？')) {
        return;
    }
    var uploadType = getCurrentUploadType();
    fetch('${pageContext.request.contextPath}/upload/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'filename=' + encodeURIComponent(filename) + '&type=' + encodeURIComponent(uploadType)
    })
    .then(response => response.json())
    .then(data => {
        if (data.code === 200) {
            var item = document.querySelector('[data-filename="' + filename + '"]');
            if (item) item.remove();
            uploadedFiles = uploadedFiles.filter(function(f) { return f.filename !== filename; });
            alert('删除成功！');
        } else {
            alert('删除失败：' + data.message);
        }
    })
    .catch(function() {
        alert('删除失败，请重试');
    });
}

function getUploadedFiles() {
    return uploadedFiles;
}

function getUploadedFileUrls() {
    return uploadedFiles.map(function(f) { return f.url; }).join(',');
}
</script>
