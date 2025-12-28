<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>志愿者个人中心</title>
    <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #FAF5F0;
            min-height: 100vh;
        }
        .gov-header {
            background: linear-gradient(135deg, #B71C1C 0%, #D32F2F 100%);
            height: 64px;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 12px rgba(0,0,0,0.15);
            position: relative;
        }
        .gov-header::before {
            content: '★';
            position: absolute;
            left: 24px;
            color: rgba(255,255,255,0.3);
            font-size: 20px;
        }
        .gov-header h1 {
            color: white;
            font-size: 18px;
            font-weight: 600;
            margin: 0 0 0 40px;
            letter-spacing: 2px;
        }
        .gov-header a {
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 13px;
            transition: all 0.2s;
        }
        .gov-header a:hover {
            background: rgba(255,255,255,0.15);
            color: white;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 28px 24px;
        }
        .header {
            background: white;
            border-radius: 8px;
            padding: 24px 28px;
            margin-bottom: 24px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 4px solid #D32F2F;
        }
        .header h1 {
            font-size: 22px;
            color: #D32F2F;
            font-weight: 600;
        }
        .btn-back {
            padding: 10px 20px;
            background: #D32F2F;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-back:hover {
            background: #B71C1C;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(211,47,47,0.3);
        }
        .content {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 24px;
        }
        .sidebar {
            background: white;
            border-radius: 8px;
            padding: 28px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            border-left: 4px solid #D32F2F;
        }
        .avatar-section {
            text-align: center;
            margin-bottom: 24px;
        }
        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: white;
            margin: 0 auto 12px;
            box-shadow: 0 4px 16px rgba(211, 47, 47, 0.25);
            overflow: hidden;
            cursor: pointer;
            position: relative;
            transition: all 0.2s;
        }
        .avatar:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 20px rgba(211, 47, 47, 0.35);
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
            background: rgba(0, 0, 0, 0.6);
            color: white;
            padding: 6px;
            font-size: 11px;
            text-align: center;
            opacity: 0;
            transition: opacity 0.2s;
        }
        .avatar:hover .avatar-upload-hint {
            opacity: 1;
        }
        #avatarFileInput {
            display: none;
        }
        .avatar-section h2 {
            font-size: 18px;
            color: #333;
            margin-bottom: 8px;
        }
        .role-badge {
            display: inline-block;
            padding: 6px 14px;
            background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
            color: white;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .intro-box {
            background: #FFF8F8;
            border-left: 3px solid #D32F2F;
            padding: 16px;
            border-radius: 6px;
            margin-top: 16px;
        }
        .intro-box h3 {
            color: #D32F2F;
            margin-bottom: 10px;
            font-size: 14px;
            font-weight: 600;
        }
        .intro-box p {
            color: #666;
            font-size: 13px;
            line-height: 1.7;
        }
        .intro-box ul {
            margin-top: 10px;
            padding-left: 18px;
        }
        .intro-box li {
            color: #666;
            font-size: 13px;
            line-height: 1.8;
            margin-bottom: 4px;
        }
        .skills-section {
            margin-top: 16px;
            padding: 16px;
            background: #FFF8F8;
            border-radius: 6px;
            border-left: 3px solid #D32F2F;
        }
        .skills-section h3 {
            color: #D32F2F;
            margin-bottom: 12px;
            font-size: 14px;
            font-weight: 600;
        }
        .skill-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        .skill-tag {
            padding: 5px 10px;
            background: white;
            border: 1px solid #D32F2F;
            color: #D32F2F;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        .skill-tag-empty {
            color: #999;
            font-size: 13px;
        }
        .btn-edit-skills {
            display: block;
            margin-top: 12px;
            padding: 10px 16px;
            background: #D32F2F;
            color: white;
            border: none;
            border-radius: 6px;
            text-align: center;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-edit-skills:hover {
            background: #B71C1C;
            transform: translateY(-1px);
        }
        .main-content {
            background: white;
            border-radius: 8px;
            padding: 32px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            border-left: 4px solid #D32F2F;
        }
        .section-title {
            font-size: 18px;
            color: #333;
            margin-bottom: 24px;
            padding-bottom: 12px;
            border-bottom: 2px solid #f0f0f0;
            font-weight: 600;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            color: #333;
            font-size: 13px;
            margin-bottom: 8px;
            font-weight: 600;
        }
        .form-group input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.2s;
            background: #fafafa;
        }
        .form-group input:focus {
            outline: none;
            border-color: #D32F2F;
            background: white;
            box-shadow: 0 0 0 3px rgba(211, 47, 47, 0.1);
        }
        .form-group input:disabled {
            background: #f0f0f0;
            color: #999;
            cursor: not-allowed;
        }
        .btn-save {
            width: 100%;
            padding: 14px;
            background: #D32F2F;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 8px;
        }
        .btn-save:hover {
            background: #B71C1C;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(211, 47, 47, 0.3);
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 28px;
        }
        .stat-card {
            background: #fafafa;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            border: 1px solid #eee;
            transition: all 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border-color: #D32F2F;
        }
        .stat-number {
            font-size: 28px;
            font-weight: 700;
            color: #D32F2F;
            margin-bottom: 6px;
        }
        .stat-label {
            color: #666;
            font-size: 12px;
        }
        .success-msg {
            background: #ECFDF5;
            color: #065f46;
            padding: 14px 18px;
            border-radius: 6px;
            border-left: 4px solid #10b981;
            margin-bottom: 20px;
            font-size: 13px;
            display: ${not empty msg ? 'block' : 'none'};
        }
        @media (max-width: 968px) {
            .content {
                grid-template-columns: 1fr;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .container { padding: 20px 16px; }
        }
    </style>
</head>
<body>
<header class="gov-header">
    <h1>志愿者个人中心</h1>
    <a href="${pageContext.request.contextPath}/user/volunteer/dashboard">返回首页</a>
</header>

<div class="container">
    <!-- Header -->
    <div class="header">
        <h1>志愿者个人中心</h1>
        <a href="${pageContext.request.contextPath}/user/volunteer/dashboard" class="btn-back">返回首页</a>
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
                                    <img src="${currentUser.avatar}" alt="" id="avatarPreview" style="width:100%;height:100%;object-fit:cover;" />
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}${currentUser.avatar}" alt="" id="avatarPreview" style="width:100%;height:100%;object-fit:cover;" />
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <span id="avatarEmoji">志</span>
                        </c:otherwise>
                    </c:choose>
                    <div class="avatar-upload-hint">点击更换</div>
                </div>
                <input type="file" id="avatarFileInput" accept="image/*" onchange="uploadAvatar(this)" />
                <h2>${currentUser.fullName}</h2>
                <span class="role-badge">志愿者</span>
            </div>

            <div class="intro-box">
                <h3>角色介绍</h3>
                <p>感谢您成为社区互助平台的<strong>志愿者</strong>！您是社区温暖的传递者,用爱心和专业技能帮助有需要的关爱对象。</p>
            </div>

            <div class="intro-box" style="margin-top: 15px;">
                <h3>服务使命</h3>
                <ul>
                    <li><strong>认领任务</strong> - 接受关爱对象发布的关爱需求</li>
                    <li><strong>专业服务</strong> - 发挥技能为关爱对象提供服务</li>
                    <li><strong>获得积分</strong> - 完成任务获取积分奖励</li>
                    <li><strong>赢得勋章</strong> - 积累经验获取荣誉勋章</li>
                    <li><strong>温暖社区</strong> - 让爱心传递每个角落</li>
                </ul>
            </div>

            <div class="skills-section">
                <h3>我的技能标签</h3>
                <div class="skill-tags">
                    <c:choose>
                        <c:when test="${not empty mySkills}">
                            <c:forEach items="${mySkills}" var="skill">
                                <span class="skill-tag">${skill.skill.icon} ${skill.skill.skillName}</span>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <span class="skill-tag-empty">暂未配置技能标签</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <a href="${pageContext.request.contextPath}/skill/config" class="btn-edit-skills">编辑技能</a>
            </div>

            <div class="intro-box" style="margin-top: 15px;">
                <h3>温馨提示</h3>
                <p>完善技能标签可以让您匹配到更合适的任务，提高服务质量和效率。</p>
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
                    <div class="stat-number">${not empty mySkills ? mySkills.size() : 0}</div>
                    <div class="stat-label">技能标签</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">爱心</div>
                    <div class="stat-label">爱心服务</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">社区</div>
                    <div class="stat-label">温暖社区</div>
                </div>
            </div>

            <!-- Form -->
            <h3 class="section-title">个人信息维护</h3>
            <form action="${pageContext.request.contextPath}/user/profile" method="post" onsubmit="return beforeSubmit()">
                <input type="hidden" name="id" value="${currentUser.id}">

                <div class="form-group">
                    <label>用户名</label>
                    <input type="text" value="${currentUser.username}" disabled>
                </div>

                <!-- 隐藏的头像URL字段 -->
                <input type="hidden" name="avatar" id="avatarUrl" value="${currentUser.avatar}">

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
// 头像上传功能
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
                    // 如果data.data直接是字符串路径
                    avatarPath = data.data;
                } else if (data.data && data.data.url) {
                    // 如果data.data是对象，且有url属性
                    avatarPath = data.data.url;
                } else if (data.data && data.data.fileUrl) {
                    // 可能的其他属性名
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
                    // 已经包含contextPath，直接使用
                    imgUrl = avatarPath;
                } else {
                    // 不包含，需要添加
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
            // 3秒后刷新页面以显示新头像
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

// 原有的表单提交函数
function beforeSubmit() {
    return true;
}
</script>
</body>
</html>
