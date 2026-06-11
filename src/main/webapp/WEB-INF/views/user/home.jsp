<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>我的控制台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { box-sizing: border-box; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
      margin: 0;
      padding: 0;
      font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
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
    .gov-header .actions {
      display: flex;
      align-items: center;
      gap: 16px;
      color: rgba(255,255,255,0.9);
      font-size: 13px;
    }
    .gov-header .actions a {
      color: rgba(255,255,255,0.9);
      text-decoration: none;
      padding: 8px 14px;
      border-radius: 6px;
      transition: all 0.2s;
    }
    .gov-header .actions a:hover {
      background: rgba(255,255,255,0.15);
      color: white;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 28px 24px;
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
      gap: 24px;
    }
    .gov-card {
      background: white;
      border-radius: 8px;
      padding: 24px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.06);
      border: 1px solid #eee;
    }
    .avatar-box {
      width: 72px;
      height: 72px;
      background: linear-gradient(135deg, #D32F2F, #B71C1C);
      color: white;
      font-size: 28px;
      font-weight: 600;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(183, 28, 28, 0.2);
      flex-shrink: 0;
    }
    .menu-list {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    .menu-list li {
      padding: 14px 16px;
      border-bottom: 1px solid #f0f0f0;
      display: flex;
      justify-content: space-between;
      align-items: center;
      transition: all 0.2s;
      cursor: pointer;
      border-radius: 6px;
      margin-bottom: 4px;
      font-size: 14px;
      color: #333;
    }
    .menu-list li:last-child {
      border-bottom: none;
      margin-bottom: 0;
    }
    .menu-list li:hover {
      background: #FFF5F5;
      color: #D32F2F;
    }
    .menu-list li::after {
      content: '›';
      font-size: 18px;
      color: #ccc;
    }
    .stat-value {
      font-size: 24px;
      font-weight: 700;
      color: #D32F2F;
    }
    .stat-label {
      font-size: 12px;
      color: #666;
      margin-top: 4px;
    }
    .gov-badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 600;
    }
    .gov-badge.primary {
      background: rgba(211,47,47,0.1);
      color: #D32F2F;
    }
    .hint {
      font-size: 12px;
      color: #999;
    }
    @media (max-width: 640px) {
      .gov-header { padding: 0 16px; }
      .gov-header h1 { font-size: 16px; margin-left: 32px; }
      .container { padding: 20px 16px; }
    }
  </style>
</head>
<body>

<header class="gov-header">
  <h1>智慧社区协同控制台</h1>
  <div class="actions">
    <span style="margin-right: 20px; font-size: 14px; opacity: 0.9;">
      当前用户：${currentUser.fullName}
    </span>
    <a href="${pageContext.request.contextPath}/user/profile">个人中心</a>
    <a href="${pageContext.request.contextPath}/user/logout" style="background: rgba(255,255,255,0.2);">退出系统</a>
  </div>
</header>

<main class="container fade-in-up">
  <!-- 个人信息卡片 -->
  <div class="gov-card">
    <div style="display: flex; align-items: center; gap: 20px; margin-bottom: 20px;">
      <div class="avatar-box">
        ${fn:substring(currentUser.fullName,0,1)}
      </div>
      <div>
        <div class="gov-badge primary">${currentUser.roleType == 'STAFF' ? '社区管理者' : currentUser.roleType == 'VOLUNTEER' ? '志愿者' : '家属'}</div>
        <h2 style="margin: 8px 0; font-size: 20px;">${currentUser.username}</h2>
        <p style="margin: 0; font-size: 14px; color: #666;">${currentUser.phone}</p>
      </div>
    </div>
    <div style="display: flex; gap: 10px; border-top: 1px solid #eee; padding-top: 15px;">
      <div style="flex: 1; text-align: center;">
        <div class="stat-value">12</div>
        <div class="stat-label">待办事项</div>
      </div>
      <div style="flex: 1; text-align: center; border-left: 1px solid #eee;">
        <div class="stat-value">98%</div>
        <div class="stat-label">信用评分</div>
      </div>
    </div>
  </div>

  <!-- 快捷入口 -->
  <div class="gov-card">
    <h3 style="margin-top: 0; padding-bottom: 10px; border-bottom: 2px solid #D32F2F;">常用功能</h3>
    <ul class="menu-list">
      <c:choose>
        <c:when test="${currentUser.roleType == 'STAFF'}">
          <li onclick="location.href='${pageContext.request.contextPath}/admin/task/list'">任务调度中心</li>
          <li onclick="location.href='${pageContext.request.contextPath}/admin/volunteer/list'">志愿者资源管理</li>
          <li onclick="location.href='${pageContext.request.contextPath}/admin/schedule/manage'">排班与值班表</li>
        </c:when>
        <c:when test="${currentUser.roleType == 'VOLUNTEER'}">
          <li onclick="location.href='${pageContext.request.contextPath}/volunteer/task/hall'">任务大厅 (接单)</li>
          <li onclick="location.href='${pageContext.request.contextPath}/volunteer/task/my'">我的任务进度</li>
          <li onclick="location.href='${pageContext.request.contextPath}/user/profile'">技能标签管理</li>
        </c:when>
        <c:otherwise>
          <li onclick="location.href='${pageContext.request.contextPath}/family/care-plan/list'">家庭关爱计划</li>
          <li onclick="location.href='${pageContext.request.contextPath}/family/feedback/submit'">提交服务反馈</li>
          <li onclick="location.href='${pageContext.request.contextPath}/user/notification/list'">消息通知中心</li>
        </c:otherwise>
      </c:choose>
    </ul>
  </div>

  <!-- 权限列表 -->
  <div class="gov-card">
    <h3 style="margin-top: 0; padding-bottom: 10px; border-bottom: 2px solid #D32F2F;">当前权限</h3>
    <div style="display: flex; flex-wrap: wrap; gap: 8px; margin-top: 15px;">
      <c:forEach items="${currentUser.permissions}" var="perm">
        <span class="gov-badge" style="background: #eee; color: #555; border: 1px solid #ddd;">
          ${perm.permName}
        </span>
      </c:forEach>
    </div>
    <div class="hint" style="margin-top: 20px;">
      * 如需更多权限，请联系社区管理员申请
    </div>
  </div>
</main>

</body>
</html>

