<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员个人中心</title>
    <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #FAF5F0;
            min-height: 100vh;
            padding: 40px 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: white;
            border-radius: 2px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 4px solid #D32F2F;
        }

        .header h1 {
            font-size: 28px;
            color: #D32F2F;
        }

        .btn-back {
            padding: 10px 20px;
            background: white;
            color: #D32F2F;
            border: 2px solid #D32F2F;
            border-radius: 2px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
        }

        .btn-back:hover {
            background: #D32F2F;
            color: white;
        }

        .content {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 25px;
        }

        .sidebar {
            background: white;
            border-radius: 4px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            border-left: 4px solid #D32F2F;
        }

        .avatar-section {
            text-align: center;
            margin-bottom: 30px;
        }

        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: white;
            margin: 0 auto 15px;
            box-shadow: 0 4px 12px rgba(211, 47, 47, 0.3);
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: all 0.3s;
        }

        .avatar:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 16px rgba(211, 47, 47, 0.4);
        }

        .avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .avatar-upload-hint {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 5px;
            font-size: 12px;
            text-align: center;
            opacity: 0;
            transition: opacity 0.3s;
        }

        .avatar:hover .avatar-upload-hint {
            opacity: 1;
        }

        #avatarFileInput {
            display: none;
        }

        .role-badge {
            display: inline-block;
            padding: 6px 16px;
            background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
            color: white;
            border-radius: 2px;
            font-size: 12px;
            font-weight: bold;
            margin-top: 10px;
        }

        .intro-box {
            background: #FFF5F5;
            border-left: 4px solid #D32F2F;
            padding: 20px;
            border-radius: 2px;
            margin-top: 20px;
        }

        .intro-box h3 {
            color: #D32F2F;
            margin-bottom: 10px;
            font-size: 16px;
        }

        .intro-box p {
            color: #666;
            font-size: 14px;
            line-height: 1.8;
        }

        .intro-box ul {
            margin-top: 12px;
            padding-left: 20px;
        }

        .intro-box li {
            color: #666;
            font-size: 14px;
            line-height: 1.8;
            margin-bottom: 6px;
        }

        .main-content {
            background: white;
            border-radius: 4px;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            border-left: 4px solid #D32F2F;
        }

        .section-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            color: #666;
            font-size: 14px;
            margin-bottom: 8px;
            font-weight: bold;
        }

        .form-group input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 2px;
            font-size: 15px;
            transition: all 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #D32F2F;
            box-shadow: 0 0 0 3px rgba(211, 47, 47, 0.1);
        }

        .form-group input:disabled {
            background: #f5f5f5;
            color: #999;
            cursor: not-allowed;
        }

        .btn-save {
            width: 100%;
            padding: 14px;
            background: white;
            color: #D32F2F;
            border: 2px solid #D32F2F;
            border-radius: 2px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-save:hover {
            background: #D32F2F;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(211, 47, 47, 0.3);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 4px;
            padding: 20px;
            text-align: center;
            border: 2px solid #f0f0f0;
            border-left: 4px solid #D32F2F;
            transition: all 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 12px rgba(211, 47, 47, 0.15);
            border-color: #D32F2F;
        }

        .stat-number {
            font-size: 32px;
            font-weight: bold;
            color: #D32F2F;
            margin-bottom: 8px;
        }

        .stat-label {
            color: #666;
            font-size: 14px;
        }

        .success-msg {
            background: #d1fae5;
            color: #065f46;
            padding: 12px 20px;
            border-radius: 2px;
            margin-bottom: 20px;
            display: ${not empty msg ? 'block' : 'none'};
            border-left: 4px solid #10b981;
        }

        @media (max-width: 968px) {
            .content {
                grid-template-columns: 1fr;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <h1>管理员个人中心</h1>
        <a href="${pageContext.request.contextPath}/user/admin/dashboard" class="btn-back">返回后台</a>
    </div>

    <div class="content">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="avatar-section">
                <div class="avatar" onclick="document.getElementById('avatarFileInput').click()" title="点击更换头像">
                    <c:choose>
                        <c:when test="${not empty currentUser.avatar}">
                            <c:choose>
                                <c:when test="${fn:startsWith(currentUser.avatar, pageContext.request.contextPath)}">
                                    <img src="${currentUser.avatar}" alt="" id="avatarPreview" />
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}${currentUser.avatar}" alt="" id="avatarPreview" />
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <span id="avatarEmoji">管</span>
                        </c:otherwise>
                    </c:choose>
                    <div class="avatar-upload-hint">点击更换</div>
                </div>
                <input type="file" id="avatarFileInput" accept="image/*" onchange="uploadAvatar(this)" />
                <h2>${currentUser.fullName}</h2>
                <span class="role-badge">系统管理员</span>
            </div>

            <div class="intro-box">
                <h3>角色介绍</h3>
                <p>作为社区互助平台的<strong>系统管理员</strong>，您拥有最高权限，负责平台的整体运营和管理工作。</p>
            </div>

            <div class="intro-box" style="margin-top: 15px;">
                <h3>核心职责</h3>
                <ul>
                    <li><strong>用户管理</strong> - 审核、管理所有用户</li>
                    <li><strong>任务监督</strong> - 审核任务发布和完成</li>
                    <li><strong>数据分析</strong> - 查看平台运营数据</li>
                    <li><strong>系统配置</strong> - 管理系统参数设置</li>
                    <li><strong>安全管理</strong> - 保障平台安全运行</li>
                </ul>
            </div>

            <div class="intro-box" style="margin-top: 15px;">
                <h3>温馨提示</h3>
                <p>请妥善保管您的管理员账号，定期更新个人信息，确保联系方式准确有效。</p>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <c:if test="${not empty msg}">
                <div class="success-msg">${msg}</div>
            </c:if>

            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">全部</div>
                    <div class="stat-label">管理权限</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">最高</div>
                    <div class="stat-label">权限级别</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">24/7</div>
                    <div class="stat-label">全天守护</div>
                </div>
            </div>

            <!-- Form -->
            <h3 class="section-title">个人信息维护</h3>
            <form action="${pageContext.request.contextPath}/user/profile" method="post">
                <input type="hidden" name="id" value="${currentUser.id}">
                <input type="hidden" name="avatar" id="avatarUrl" value="${currentUser.avatar}">

                <div class="form-group">
                    <label>用户名</label>
                    <input type="text" value="${currentUser.username}" disabled>
                </div>

                <div class="form-group">
                    <label>姓名</label>
                    <input type="text" name="fullName" value="${currentUser.fullName}" required>
                </div>

                <div class="form-group">
                    <label>手机号</label>
                    <input type="tel" name="phone" value="${currentUser.phone}" required pattern="1[3-9]\d{9}">
                </div>

                <div class="form-group">
                    <label>邮箱</label>
                    <input type="email" name="email" value="${currentUser.email}" required>
                </div>

                <button type="submit" class="btn-save">保存修改</button>
            </form>
        </div>
    </div>
</div>

<script>
function uploadAvatar(input) {
    if (input.files && input.files[0]) {
        var file = input.files[0];
        
        // 检查文件大小（5MB）
        if (file.size > 5 * 1024 * 1024) {
            alert('图片大小不能超过5MB');
            return;
        }
        
        // 检查文件类型
        if (!file.type.match('image.*')) {
            alert('请选择图片文件');
            return;
        }
        
        console.log('Uploading file:', file.name);
        
        // 创建FormData对象
        var formData = new FormData();
        formData.append('file', file);
        
        // 显示加载状态
        var avatarDiv = document.querySelector('.avatar');
        var originalContent = avatarDiv.innerHTML;
        avatarDiv.innerHTML = '<div style="color:white;">上传中...</div>';
        
        // 发送AJAX请求上传头像
        fetch('${pageContext.request.contextPath}/upload/avatar', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            console.log('Upload response status:', response.status);
            if (!response.ok) {
                throw new Error('Upload failed with status: ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            console.log('Upload response data:', data);
            
            if (data.code === 200) {
                // 获取正确的URL路径
                var avatarPath;
                
                // 处理不同的响应格式
                if (typeof data.data === 'string') {
                    avatarPath = data.data;
                } else if (data.data && data.data.url) {
                    avatarPath = data.data.url;
                } else if (data.data && data.data.fileUrl) {
                    avatarPath = data.data.fileUrl;
                } else {
                    console.error('Cannot find avatar URL in response:', data);
                    alert('上传成功但无法获取图片路径');
                    avatarDiv.innerHTML = originalContent;
                    return;
                }
                
                console.log('Avatar URL to use:', avatarPath);
                
                // 确保路径是字符串
                if (typeof avatarPath !== 'string') {
                    console.error('Avatar path is not a string:', avatarPath);
                    alert('获取图片路径失败');
                    avatarDiv.innerHTML = originalContent;
                    return;
                }
                
                // 更新头像显示
                // 检查avatarPath是否已经包含contextPath
                var imgUrl;
                var contextPath = '${pageContext.request.contextPath}';
                if (avatarPath.indexOf(contextPath) === 0) {
                    imgUrl = avatarPath;
                } else {
                    imgUrl = contextPath + avatarPath;
                }
                console.log('Full image URL:', imgUrl);
                
                avatarDiv.innerHTML = '';
                
                // 创建img元素
                var img = document.createElement('img');
                img.src = imgUrl;
                img.id = 'avatarPreview';
                img.style.width = '100%';
                img.style.height = '100%';
                img.style.objectFit = 'cover';
                img.onerror = function() {
                    console.error('Failed to load image:', imgUrl);
                    alert('图片加载失败，请检查文件是否存在');
                };
                
                // 创建提示元素
                var hint = document.createElement('div');
                hint.className = 'avatar-upload-hint';
                hint.textContent = '点击更换';
                
                // 添加到容器
                avatarDiv.appendChild(img);
                avatarDiv.appendChild(hint);
                
                // 更新隐藏字段的值
                if (document.getElementById('avatarUrl')) {
                    document.getElementById('avatarUrl').value = avatarPath;
                }
                
                // 保存到数据库
                console.log('Saving avatar to database:', avatarPath);
                saveAvatarToDatabase(avatarPath);
                
            } else {
                console.error('Upload failed:', data);
                alert('上传失败：' + (data.msg || '未知错误'));
                avatarDiv.innerHTML = originalContent;
            }
        })
        .catch(error => {
            console.error('Upload error:', error);
            alert('上传失败：' + error.message);
            avatarDiv.innerHTML = originalContent;
        });
    }
}

// 保存头像到数据库
function saveAvatarToDatabase(avatarUrl) {
    // 确保avatarUrl是字符串
    if (typeof avatarUrl !== 'string') {
        console.error('Avatar URL is not a string:', avatarUrl);
        return;
    }
    
    console.log('Saving avatar URL:', avatarUrl);
    
    // 创建表单数据
    var formData = new FormData();
    formData.append('id', '${currentUser.id}');
    formData.append('avatar', avatarUrl);  // 确保是字符串路径
    formData.append('fullName', '${currentUser.fullName}');
    formData.append('phone', '${currentUser.phone}');
    formData.append('email', '${currentUser.email}');
    
    // 发送请求更新用户信息
    fetch('${pageContext.request.contextPath}/user/profile', {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (response.ok) {
            // 显示成功提示
            showSuccessMessage('头像更新成功！');
            // 1.5秒后刷新页面以显示新头像
            setTimeout(function() {
                window.location.reload();
            }, 1500);
        }
    })
    .catch(error => {
        console.error('Error saving avatar:', error);
    });
}

// 显示成功消息
function showSuccessMessage(message) {
    var msgDiv = document.createElement('div');
    msgDiv.style.cssText = 'position:fixed;top:20px;right:20px;background:#10b981;color:white;padding:15px 20px;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.15);z-index:9999;';
    msgDiv.textContent = message;
    document.body.appendChild(msgDiv);
    setTimeout(function() {
        msgDiv.remove();
    }, 3000);
}
</script>

</body>
</html>
