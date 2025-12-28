<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>管理员个人中心</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: 'Microsoft YaHei', Arial, sans-serif;
      background: #FAF5F0;
      min-height: 100vh;
      padding: 0;
    }
    .gov-header {
      background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
      height: 60px;
      padding: 0 40px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      box-shadow: 0 2px 8px rgba(0,0,0,0.15);
      position: relative;
      margin-bottom: 40px;
    }
    .gov-header::before {
      content: '★';
      position: absolute;
      left: 20px;
      color: #B71C1C;
      font-size: 24px;
    }
    .gov-header h1 {
      color: white;
      font-size: 20px;
      font-weight: 600;
      margin-left: 50px;
      letter-spacing: 1px;
      margin: 0;
    }
    .gov-header .actions a {
      color: white;
      text-decoration: none;
      font-size: 14px;
      padding: 6px 16px;
      border-radius: 2px;
      margin-left: 20px;
      transition: all 0.3s;
    }
    .gov-header .actions a:hover {
      background: rgba(255,255,255,0.2);
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 20px 40px 20px;
      display: grid;
      grid-template-columns: 1fr 2fr;
      gap: 30px;
    }
    .card {
      background: #fff;
      border-radius: 4px;
      padding: 32px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      border-left: 4px solid #D32F2F;
    }
    .profile-card {
      text-align: center;
    }
    .avatar {
      width: 120px;
      height: 120px;
      border-radius: 50%;
      margin: 0 auto 20px;
      background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 48px;
      color: white;
      font-weight: 700;
      box-shadow: 0 4px 12px rgba(211, 47, 47, 0.3);
      overflow: hidden;
    }
    .avatar img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .profile-card h2 {
      font-size: 24px;
      color: #212121;
      margin-bottom: 8px;
    }
    .role-badge {
      display: inline-block;
      padding: 6px 16px;
      background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
      color: white;
      border-radius: 2px;
      font-size: 13px;
      font-weight: 600;
      margin-bottom: 20px;
    }
    .info-item {
      padding: 12px 0;
      border-bottom: 1px solid #f0f0f0;
      text-align: left;
    }
    .info-item:last-child {
      border-bottom: none;
    }
    .info-label {
      font-size: 13px;
      color: #666;
      margin-bottom: 4px;
    }
    .info-value {
      font-size: 15px;
      color: #212121;
      font-weight: 600;
    }
    .section-title {
      font-size: 20px;
      color: #212121;
      margin-bottom: 24px;
      font-weight: 700;
    }
    .admin-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 20px;
      margin-bottom: 30px;
    }
    .admin-card {
      background: #FFF5F5;
      border-radius: 4px;
      padding: 20px;
      border: 2px solid #f0f0f0;
      border-left: 4px solid #D32F2F;
      transition: all 0.3s;
    }
    .admin-card:hover {
      border-color: #D32F2F;
      box-shadow: 0 4px 12px rgba(211, 47, 47, 0.15);
    }
    .admin-name {
      font-size: 18px;
      color: #212121;
      margin-bottom: 8px;
      font-weight: 700;
    }
    .admin-meta {
      font-size: 13px;
      color: #666;
      margin-bottom: 4px;
    }
    .btn {
      display: inline-block;
      padding: 12px 24px;
      background: white;
      color: #D32F2F;
      border: 2px solid #D32F2F;
      text-decoration: none;
      border-radius: 2px;
      font-weight: 700;
      transition: all 0.3s;
      cursor: pointer;
      font-size: 14px;
    }
    .btn:hover {
      background: #D32F2F;
      color: white;
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(211, 47, 47, 0.3);
    }
    .btn-add {
      width: 100%;
      margin-top: 20px;
      padding: 14px;
    }
    .success-msg {
      background: #d1fae5;
      color: #065f46;
      padding: 12px 20px;
      border-radius: 2px;
      border-left: 4px solid #10b981;
      margin-bottom: 20px;
    }
    .error-msg {
      background: rgba(211,47,47,0.1);
      color: #B71C1C;
      padding: 12px 20px;
      border-radius: 2px;
      border-left: 4px solid #D32F2F;
      margin-bottom: 20px;
    }
    @media (max-width: 968px) {
      .container {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>
<header class="gov-header">
  <h1>管理员个人中心</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/user/admin/dashboard">返回控制台</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <div class="card profile-card">
    <div class="avatar">
      <c:choose>
        <c:when test="${not empty currentUser.avatar}">
          <c:choose>
            <c:when test="${fn:startsWith(currentUser.avatar, pageContext.request.contextPath)}">
              <img src="${currentUser.avatar}" alt="" />
            </c:when>
            <c:otherwise>
              <img src="${pageContext.request.contextPath}${currentUser.avatar}" alt="" />
            </c:otherwise>
          </c:choose>
        </c:when>
        <c:otherwise>
          <span>${currentUser.fullName.substring(0,1)}</span>
        </c:otherwise>
      </c:choose>
    </div>
    <h2>${currentUser.fullName}</h2>
    <span class="role-badge">系统管理员</span>

    <div style="margin-top:30px;">
      <div class="info-item">
        <div class="info-label">用户名</div>
        <div class="info-value">${currentUser.username}</div>
      </div>
      <div class="info-item">
        <div class="info-label">手机号</div>
        <div class="info-value">${currentUser.phone}</div>
      </div>
      <div class="info-item">
        <div class="info-label">邮箱</div>
        <div class="info-value">${currentUser.email != null ? currentUser.email : '未设置'}</div>
      </div>
      <div class="info-item">
        <div class="info-label">账号状态</div>
        <div class="info-value" style="color:#10b981;">
          ${currentUser.status == 1 ? '正常' : '已禁用'}
        </div>
      </div>
    </div>
  </div>

  <div class="card">
    <c:if test="${not empty error}">
      <div class="error-msg">${error}</div>
    </c:if>

    <c:if test="${not empty msg}">
      <div class="success-msg">${msg}</div>
    </c:if>

    <div class="section-title">管理员列表</div>

    <div class="admin-grid">
      <c:forEach items="${adminList}" var="admin">
        <div class="admin-card">
          <div class="admin-name">${admin.fullName}</div>
          <div class="admin-meta">用户名：${admin.username}</div>
          <div class="admin-meta">手机号：${admin.phone}</div>
          <div class="admin-meta">邮箱：${admin.email != null ? admin.email : '未设置'}</div>
        </div>
      </c:forEach>
    </div>

    <button class="btn btn-add" onclick="showAddAdminModal()">添加管理员</button>
  </div>
</div>

<!-- 添加管理员模态框 -->
<div id="addAdminModal" style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);z-index:1000;align-items:center;justify-content:center;">
  <div style="background:#fff;border-radius:4px;padding:40px;max-width:500px;width:90%;">
    <h2 style="margin-bottom:24px;color:#212121;">添加新管理员</h2>
    <form id="addAdminForm" action="${pageContext.request.contextPath}/user/admin/add" method="post">
      <div style="margin-bottom:20px;">
        <label style="display:block;margin-bottom:8px;font-weight:600;color:#424242;">用户名</label>
        <input type="text" name="username" required style="width:100%;padding:12px;border:2px solid #e0e0e0;border-radius:2px;font-size:14px;"/>
      </div>
      <div style="margin-bottom:20px;">
        <label style="display:block;margin-bottom:8px;font-weight:600;color:#424242;">姓名</label>
        <input type="text" name="fullName" required style="width:100%;padding:12px;border:2px solid #e0e0e0;border-radius:2px;font-size:14px;"/>
      </div>
      <div style="margin-bottom:20px;">
        <label style="display:block;margin-bottom:8px;font-weight:600;color:#424242;">密码</label>
        <input type="password" name="password" required style="width:100%;padding:12px;border:2px solid #e0e0e0;border-radius:2px;font-size:14px;"/>
      </div>
      <div style="margin-bottom:20px;">
        <label style="display:block;margin-bottom:8px;font-weight:600;color:#424242;">手机号</label>
        <input type="tel" name="phone" required style="width:100%;padding:12px;border:2px solid #e0e0e0;border-radius:2px;font-size:14px;"/>
      </div>
      <div style="margin-bottom:24px;">
        <label style="display:block;margin-bottom:8px;font-weight:600;color:#424242;">邮箱</label>
        <input type="email" name="email" style="width:100%;padding:12px;border:2px solid #e0e0e0;border-radius:2px;font-size:14px;"/>
      </div>
      <div style="display:flex;gap:12px;">
        <button type="button" onclick="hideAddAdminModal()" style="flex:1;padding:12px;background:#f5f5f5;color:#666;border:none;border-radius:2px;font-weight:700;cursor:pointer;">取消</button>
        <button type="submit" style="flex:1;padding:12px;background:#D32F2F;color:#fff;border:none;border-radius:2px;font-weight:700;cursor:pointer;">确定添加</button>
      </div>
    </form>
  </div>
</div>

<script>
function showAddAdminModal() {
  document.getElementById('addAdminModal').style.display = 'flex';
}

function hideAddAdminModal() {
  document.getElementById('addAdminModal').style.display = 'none';
  document.getElementById('addAdminForm').reset();
}

// 点击模态框外部关闭
document.getElementById('addAdminModal').addEventListener('click', function(e) {
  if (e.target === this) {
    hideAddAdminModal();
  }
});
</script>
</body>
</html>
