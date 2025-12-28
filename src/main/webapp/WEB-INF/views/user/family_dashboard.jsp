<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>家属协同中心</title>
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
    .gov-header .nav-right {
      display: flex;
      align-items: center;
      gap: 24px;
      color: rgba(255,255,255,0.9);
      font-size: 13px;
    }
    .gov-header .nav-right a {
      color: rgba(255,255,255,0.9);
      text-decoration: none;
      padding: 6px 12px;
      border-radius: 4px;
      transition: all 0.2s;
    }
    .gov-header .nav-right a:hover {
      background: rgba(255,255,255,0.15);
      color: white;
    }
    .container {
      padding: 28px 24px;
      max-width: 1280px;
      margin: 0 auto;
    }
    .role-badge {
      background: white;
      color: #D32F2F;
      padding: 8px 16px;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 600;
      display: inline-block;
      margin-bottom: 24px;
      border: 1px solid #D32F2F;
      box-shadow: 0 2px 8px rgba(211,47,47,0.1);
    }
    .profile-banner {
      background: white;
      padding: 24px 28px;
      border-radius: 8px;
      margin-bottom: 24px;
      display: flex;
      align-items: center;
      gap: 24px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.06);
      border-left: 4px solid #D32F2F;
    }
    .avatar {
      width: 72px;
      height: 72px;
      border-radius: 12px;
      background: linear-gradient(135deg, #B71C1C, #D32F2F);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 28px;
      color: #fff;
      font-weight: 600;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(183, 28, 28, 0.2);
      flex-shrink: 0;
    }
    .avatar img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .profile-info {
      flex: 1;
    }
    .profile-info h2 {
      color: #333;
      margin: 0 0 6px 0;
      font-size: 18px;
      font-weight: 600;
    }
    .profile-info .label {
      color: #666;
      font-size: 13px;
    }
    .stat {
      font-size: 32px;
      font-weight: 700;
      color: #D32F2F;
      line-height: 1;
      margin-bottom: 4px;
    }
    .stat-label {
      font-size: 12px;
      color: #666;
    }
    .modules {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 20px;
    }
    .module-card {
      background: white;
      padding: 24px;
      border-radius: 8px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.06);
      transition: all 0.2s;
      border: 1px solid #eee;
      min-height: 180px;
      display: flex;
      flex-direction: column;
    }
    .module-card:hover {
      box-shadow: 0 4px 20px rgba(0,0,0,0.1);
      transform: translateY(-2px);
      border-color: #D32F2F;
    }
    .module-card h2 {
      color: #333;
      margin: 0 0 10px 0;
      font-size: 15px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .module-card h2 .icon {
      color: #D32F2F;
      font-size: 16px;
    }
    .module-card p {
      color: #666;
      font-size: 13px;
      margin: 0 0 16px 0;
      line-height: 1.6;
      flex: 1;
    }
    .action-btn {
      width: 100%;
      padding: 10px 16px;
      border: none;
      border-radius: 6px;
      background: #D32F2F;
      color: white;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      font-size: 13px;
      text-decoration: none;
      display: block;
      text-align: center;
      flex-shrink: 0;
      margin-top: auto;
    }
    .action-btn:hover {
      background: #B71C1C;
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(211,47,47,0.3);
    }
    @media (max-width: 1024px) {
      .modules { grid-template-columns: repeat(2, 1fr); }
    }
    @media (max-width: 640px) {
      .gov-header { padding: 0 16px; }
      .gov-header h1 { font-size: 16px; margin-left: 32px; }
      .container { padding: 20px 16px; }
      .modules { grid-template-columns: 1fr; }
      .profile-banner { flex-wrap: wrap; padding: 20px; }
      .stat { font-size: 24px; }
    }
  </style>
</head>
<body>
<div class="gov-header">
  <h1>家属服务中心</h1>
  <div class="nav-right">
    <span>家属：${currentUser.fullName}</span>
    <a href="${pageContext.request.contextPath}/user/profile">个人资料</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</div>


<div class="container">
  <div class="role-badge">FAMILY - 家属服务中心</div>
  
  <div class="profile-banner">
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
          ${currentUser.fullName.substring(0, 1)}
        </c:otherwise>
      </c:choose>
    </div>
    <div class="profile-info">
      <h2>家属：${currentUser.fullName}</h2>
      <p class="label">账号：${currentUser.username} · 手机：${currentUser.phone}</p>
    </div>
    <div style="text-align: center; margin-left: auto;">
      <div class="stat">${pendingCount != null ? pendingCount : 0}</div>
      <div class="stat-label">待办事项</div>
    </div>
    <div style="text-align: center; margin-left: 30px;">
      <div class="stat">${serviceCount != null ? serviceCount : 0}</div>
      <div class="stat-label">服务记录</div>
    </div>
  </div>

  <div class="modules">
    <div class="module-card">
      <h2><span class="icon"></span>关爱人员</h2>
      <p>管理您的关爱人员信息，添加新的关爱对象需要管理员审核通过后才能发布需求</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/user/family/elderly/list'">管理关爱人员</button>
    </div>

    <div class="module-card">
      <h2><span class="icon"></span>需求管理</h2>
      <p>发布新的关爱需求，管理员审核后会为您匹配合适的志愿者提供服务</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/demand/family/list'">管理需求</button>
    </div>

    <div class="module-card">
      <h2><span class="icon"></span>关爱计划</h2>
      <p>发布和管理关爱计划，查看志愿者服务进度和服务记录</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/family/care-plan/list'">管理关爱计划</button>
    </div>

    <div class="module-card">
      <h2><span class="icon"></span>服务记录</h2>
      <p>查看志愿者为您家人提供的所有服务历史，包括时间、内容、评价等</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/user/family/service-records'">查看完整记录</button>
    </div>

    <div class="module-card">
      <h2><span class="icon"></span>反馈与沟通</h2>
      <p>对志愿者的服务进行评价，提交您的建议或特殊需求，我们会及时响应</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/user/family/feedback/list'">查看我的反馈</button>
    </div>

    <div class="module-card">
      <h2><span class="icon"></span>通知中心</h2>
      <p>接收任务提醒、志愿者变更、紧急通知等重要消息</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/notification/list'">查看所有通知</button>
    </div>

    <div class="module-card">
      <h2><span class="icon"></span>志愿者团队</h2>
      <p>了解为您家人服务的志愿者信息、专长技能、联系方式</p>
      <button class="action-btn" onclick="window.location.href='${pageContext.request.contextPath}/user/family/volunteers'">查看志愿者团队</button>
    </div>

    <div class="module-card">
      <h2><span class="icon"></span>志愿者排班</h2>
      <p>查看志愿者的可服务时间，方便您安排与志愿者的协作时间</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/family/schedule/view'">查看排班</button>
    </div>

    <div class="module-card">
      <h2><span class="icon"></span>紧急联系</h2>
      <p>遇到紧急情况可快速联系社区工作人员或负责志愿者</p>
      <button class="action-btn" onclick="window.location.href='${pageContext.request.contextPath}/user/family/emergency-contact'">设置紧急联系人</button>
    </div>
  </div>
</div>
</body>
</html>
