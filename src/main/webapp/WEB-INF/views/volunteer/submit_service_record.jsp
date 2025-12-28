<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>提交服务记录</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #FAF5F0;
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 4px;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid #D32F2F;
        }
        h1 {
            color: #D32F2F;
            margin-bottom: 10px;
            font-size: 28px;
        }
        .subtitle {
            color: #666;
            margin-bottom: 30px;
        }
        .back-btn {
            display: inline-block;
            padding: 10px 20px;
            background: white;
            color: #D32F2F;
            text-decoration: none;
            border-radius: 2px;
            border: 2px solid #D32F2F;
            margin-bottom: 20px;
        }
        .plan-info {
            background: #FFF5F5;
            border-radius: 4px;
            padding: 20px;
            margin-bottom: 30px;
            border-left: 4px solid #D32F2F;
        }
        .plan-info h3 {
            color: #D32F2F;
            margin-bottom: 10px;
        }
        .plan-info p {
            color: #666;
            font-size: 14px;
            margin: 5px 0;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        .form-group label .required {
            color: #D32F2F;
        }
        .form-control {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        .form-control:focus {
            outline: none;
            border-color: #D32F2F;
        }
        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .hint {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        .section-title {
            font-size: 16px;
            color: #D32F2F;
            margin: 30px 0 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #FFF5F5;
        }
        .photo-upload {
            border: 2px dashed #e0e0e0;
            border-radius: 4px;
            padding: 30px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        .photo-upload:hover {
            border-color: #D32F2F;
            background: #FFF5F5;
        }
        .photo-upload input {
            display: none;
        }
        .photo-upload-icon {
            font-size: 48px;
            color: #D32F2F;
            margin-bottom: 10px;
        }
        .photo-upload-text {
            color: #666;
        }
        .photo-preview {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
        }
        .photo-preview-item {
            position: relative;
            width: 100px;
            height: 100px;
        }
        .photo-preview-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 4px;
        }
        .photo-preview-item .remove-btn {
            position: absolute;
            top: -8px;
            right: -8px;
            width: 24px;
            height: 24px;
            background: #F44336;
            color: white;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            font-size: 14px;
        }
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: #D32F2F;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
        }
        .btn-submit:hover {
            background: #B71C1C;
        }
        .btn-submit:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        .message {
            padding: 15px;
            margin: 15px 0;
            border-radius: 4px;
        }
        .message.error {
            background: #FFEBEE;
            color: #C62828;
            border-left: 4px solid #F44336;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/volunteer/care-plan/detail/${plan.id}" class="back-btn">返回计划详情</a>

        <h1>提交服务记录</h1>
        <p class="subtitle">记录您为关爱对象提供的服务内容，上传服务照片作为凭证</p>

        <div class="plan-info">
            <h3>${plan.planName}</h3>
            <p><strong>关爱对象：</strong>${elderlyInfo.name} - ${elderlyInfo.age}岁</p>
            <p><strong>地址：</strong>${elderlyInfo.address}</p>
            <p><strong>当前周期：</strong>第 ${currentPeriod} 周期，第 ${nextServiceNumber} 次服务</p>
            <p><strong>服务进度：</strong>${plan.completedServices}/${plan.totalServices} 次</p>
        </div>

        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/volunteer/care-plan/submit-record/${plan.id}" method="post" enctype="multipart/form-data" id="recordForm">
            <div class="section-title">服务时间</div>

            <div class="form-row">
                <div class="form-group">
                    <label><span class="required">*</span> 服务日期</label>
                    <input type="date" name="serviceDate" class="form-control" value="${today}" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>开始时间</label>
                    <input type="time" name="serviceTimeStart" class="form-control">
                </div>
                <div class="form-group">
                    <label>结束时间</label>
                    <input type="time" name="serviceTimeEnd" class="form-control">
                </div>
            </div>

            <div class="section-title">服务内容</div>

            <div class="form-group">
                <label><span class="required">*</span> 服务内容描述</label>
                <textarea name="serviceContent" class="form-control" placeholder="详细描述您为关爱对象提供的服务内容，例如：帮助关爱对象打扫房间、陪关爱对象聊天、协助关爱对象购买日用品等" required></textarea>
            </div>

            <div class="form-group">
                <label>关爱对象状况</label>
                <textarea name="elderlyCondition" class="form-control" placeholder="描述关爱对象当前的身体状况、精神状态等，便于家属了解"></textarea>
            </div>

            <div class="form-group">
                <label>备注</label>
                <textarea name="remarks" class="form-control" placeholder="其他需要说明的事项" style="min-height: 80px;"></textarea>
            </div>

            <div class="section-title">服务照片 <span class="required">*</span></div>

            <div class="form-group">
                <label><span class="required">*</span> 上传服务照片（至少1张，最多5张）</label>
                <div class="photo-upload" onclick="document.getElementById('photoInput').click()">
                    <input type="file" id="photoInput" name="photos" accept="image/*" multiple onchange="previewPhotos(this)" required>
                    <div class="photo-upload-icon">+</div>
                    <div class="photo-upload-text">点击上传照片（必须上传）</div>
                </div>
                <div class="photo-preview" id="photoPreview"></div>
                <div class="hint">支持 JPG、PNG 格式，单张图片不超过 5MB，服务照片将作为审核依据</div>
            </div>

            <button type="submit" class="btn-submit" id="submitBtn">提交服务记录（待管理员审核）</button>
        </form>
    </div>

    <script>
        var selectedFiles = [];

        function previewPhotos(input) {
            var preview = document.getElementById('photoPreview');
            var files = input.files;

            if (selectedFiles.length + files.length > 5) {
                alert('最多只能上传5张照片');
                return;
            }

            for (var i = 0; i < files.length; i++) {
                if (selectedFiles.length >= 5) break;

                var file = files[i];
                if (file.size > 5 * 1024 * 1024) {
                    alert('图片 ' + file.name + ' 超过5MB，请压缩后上传');
                    continue;
                }

                selectedFiles.push(file);

                var reader = new FileReader();
                reader.onload = (function(index) {
                    return function(e) {
                        var div = document.createElement('div');
                        div.className = 'photo-preview-item';
                        div.innerHTML = '<img src="' + e.target.result + '">' +
                            '<button type="button" class="remove-btn" onclick="removePhoto(' + index + ')">×</button>';
                        preview.appendChild(div);
                    };
                })(selectedFiles.length - 1);
                reader.readAsDataURL(file);
            }

            updateFileInput();
        }

        function removePhoto(index) {
            selectedFiles.splice(index, 1);
            refreshPreview();
        }

        function refreshPreview() {
            var preview = document.getElementById('photoPreview');
            preview.innerHTML = '';

            for (var i = 0; i < selectedFiles.length; i++) {
                var reader = new FileReader();
                reader.onload = (function(index) {
                    return function(e) {
                        var div = document.createElement('div');
                        div.className = 'photo-preview-item';
                        div.innerHTML = '<img src="' + e.target.result + '">' +
                            '<button type="button" class="remove-btn" onclick="removePhoto(' + index + ')">×</button>';
                        preview.appendChild(div);
                    };
                })(i);
                reader.readAsDataURL(selectedFiles[i]);
            }

            updateFileInput();
        }

        function updateFileInput() {
            var dt = new DataTransfer();
            for (var i = 0; i < selectedFiles.length; i++) {
                dt.items.add(selectedFiles[i]);
            }
            document.getElementById('photoInput').files = dt.files;
        }

        // 表单提交
        document.getElementById('recordForm').addEventListener('submit', function(e) {
            // 验证是否上传了照片
            if (selectedFiles.length === 0) {
                e.preventDefault();
                alert('请至少上传一张服务照片作为审核依据');
                return false;
            }

            var btn = document.getElementById('submitBtn');
            btn.disabled = true;
            btn.textContent = '提交中...';
        });
    </script>
</body>
</html>
