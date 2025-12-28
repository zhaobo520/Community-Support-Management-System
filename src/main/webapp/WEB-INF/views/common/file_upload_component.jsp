<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- File Upload Component -->
<style>
    .upload-container {
        margin: 20px 0;
    }

    .upload-area {
        border: 2px dashed #d1d5db;
        border-radius: 12px;
        padding: 30px;
        text-align: center;
        background: #f9fafb;
        transition: all 0.3s;
        cursor: pointer;
    }

    .upload-area:hover {
        border-color: #3b82f6;
        background: #eff6ff;
    }

    .upload-area.dragover {
        border-color: #3b82f6;
        background: #dbeafe;
    }

    .upload-icon {
        font-size: 48px;
        color: #9ca3af;
        margin-bottom: 10px;
    }

    .upload-text {
        color: #6b7280;
        font-size: 14px;
    }

    .upload-hint {
        color: #9ca3af;
        font-size: 12px;
        margin-top: 5px;
    }

    .file-input {
        display: none;
    }

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

    .preview-image {
        width: 100%;
        height: 150px;
        object-fit: cover;
    }

    .preview-doc {
        width: 100%;
        height: 150px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        background: #f3f4f6;
    }

    .doc-icon {
        font-size: 48px;
        color: #6b7280;
        margin-bottom: 10px;
    }

    .doc-name {
        font-size: 12px;
        color: #374151;
        padding: 0 10px;
        text-align: center;
        word-break: break-all;
    }

    .preview-delete {
        position: absolute;
        top: 5px;
        right: 5px;
        width: 24px;
        height: 24px;
        background: rgba(239, 68, 68, 0.9);
        color: white;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        font-size: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .preview-delete:hover {
        background: #dc2626;
    }

    .upload-progress {
        margin-top: 10px;
        height: 4px;
        background: #e5e7eb;
        border-radius: 2px;
        overflow: hidden;
        display: none;
    }

    .upload-progress-bar {
        height: 100%;
        background: linear-gradient(90deg, #3b82f6, #2563eb);
        width: 0%;
        transition: width 0.3s;
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

// File input change event
document.getElementById('fileInput').addEventListener('change', function(e) {
    handleFiles(e.target.files);
});

// Drag and drop support
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

// Handle file upload
function handleFiles(files) {
    var uploadType = document.getElementById('uploadType') ? 
        document.getElementById('uploadType').value : 'avatar';
    
    Array.from(files).forEach(function(file) {
        uploadFile(file, uploadType);
    });
}

// Upload single file
function uploadFile(file, uploadType) {
    var formData = new FormData();
    formData.append('file', file);
    
    var uploadUrl = '${pageContext.request.contextPath}/upload/' + uploadType;
    
    // Show progress bar
    document.getElementById('uploadProgress').style.display = 'block';
    
    var xhr = new XMLHttpRequest();
    
    // Progress event
    xhr.upload.addEventListener('progress', function(e) {
        if (e.lengthComputable) {
            var percentComplete = (e.loaded / e.total) * 100;
            document.getElementById('uploadProgressBar').style.width = percentComplete + '%';
        }
    });
    
    // Load event
    xhr.addEventListener('load', function() {
        document.getElementById('uploadProgress').style.display = 'none';
        document.getElementById('uploadProgressBar').style.width = '0%';
        
        if (xhr.status === 200) {
            var response = JSON.parse(xhr.responseText);
            if (response.code === 200) {
                uploadedFiles.push(response.data);
                addPreview(response.data);
                alert('上传成功！');
            } else {
                alert('上传失败：' + response.message);
            }
        } else {
            alert('上传失败，请重试');
        }
    });
    
    // Error event
    xhr.addEventListener('error', function() {
        document.getElementById('uploadProgress').style.display = 'none';
        alert('上传失败，请重试');
    });
    
    xhr.open('POST', uploadUrl);
    xhr.send(formData);
}

// Add preview
function addPreview(fileData) {
    var container = document.getElementById('previewContainer');
    var div = document.createElement('div');
    div.className = 'preview-item';
    div.dataset.filename = fileData.filename;
    
    if (fileData.type === 'image' || fileData.url.match(/\.(jpg|jpeg|png|gif)$/i)) {
        div.innerHTML = '<img src="' + fileData.url + '" class="preview-image" alt="Preview">' +
                       '<button class="preview-delete" onclick="deleteFile(\'' + fileData.filename + '\')">×</button>';
    } else {
        div.innerHTML = '<div class="preview-doc">' +
                       '<div class="doc-icon">📄</div>' +
                       '<div class="doc-name">' + (fileData.originalName || fileData.filename) + '</div>' +
                       '</div>' +
                       '<button class="preview-delete" onclick="deleteFile(\'' + fileData.filename + '\')">×</button>';
    }
    
    container.appendChild(div);
}

// Delete file
function deleteFile(filename) {
    if (!confirm('确定要删除这个文件吗？')) {
        return;
    }
    
    var uploadType = document.getElementById('uploadType') ? 
        document.getElementById('uploadType').value : 'avatars';
    
    fetch('${pageContext.request.contextPath}/upload/delete', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'filename=' + filename + '&type=' + uploadType
    })
    .then(response => response.json())
    .then(data => {
        if (data.code === 200) {
            // Remove from preview
            var item = document.querySelector('[data-filename="' + filename + '"]');
            if (item) {
                item.remove();
            }
            
            // Remove from uploadedFiles array
            uploadedFiles = uploadedFiles.filter(f => f.filename !== filename);
            
            alert('删除成功！');
        } else {
            alert('删除失败：' + data.message);
        }
    })
    .catch(error => {
        alert('删除失败，请重试');
    });
}

// Get uploaded files (for form submission)
function getUploadedFiles() {
    return uploadedFiles;
}

// Get uploaded file URLs (comma separated)
function getUploadedFileUrls() {
    return uploadedFiles.map(f => f.url).join(',');
}
</script>
