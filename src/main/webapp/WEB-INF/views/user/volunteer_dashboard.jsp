<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>志愿者服务中心</title>
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
      gap: 24px;
      color: rgba(255,255,255,0.9);
      font-size: 13px;
    }
    .gov-header .actions a {
      color: rgba(255,255,255,0.9);
      text-decoration: none;
      padding: 6px 14px;
      border-radius: 4px;
      transition: all 0.2s;
    }
    .gov-header .actions a:hover {
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
    .profile-info h2 {
      color: #333;
      margin: 0 0 6px 0;
      font-size: 18px;
      font-weight: 600;
    }
    .profile-info .tags {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-top: 12px;
    }
    .tag {
      padding: 4px 10px;
      border-radius: 4px;
      background: rgba(183, 28, 28, 0.08);
      color: #D32F2F;
      font-size: 12px;
      font-weight: 600;
    }
    .tag-more {
      position: relative;
      cursor: help;
      background: #D32F2F;
      color: white;
    }
    .tag-more:hover {
      background: #B71C1C;
    }
    .tooltip {
      position: absolute;
      bottom: 100%;
      left: 50%;
      transform: translateX(-50%) translateY(-8px);
      background: rgba(30, 41, 59, 0.95);
      color: white;
      padding: 12px 16px;
      border-radius: 6px;
      font-size: 12px;
      white-space: nowrap;
      opacity: 0;
      visibility: hidden;
      transition: all 0.2s;
      box-shadow: 0 8px 24px rgba(0,0,0,0.2);
      z-index: 1000;
    }
    .tooltip::after {
      content: '';
      position: absolute;
      top: 100%;
      left: 50%;
      transform: translateX(-50%);
      border: 6px solid transparent;
      border-top-color: rgba(30, 41, 59, 0.95);
    }
    .tag-more:hover .tooltip {
      opacity: 1;
      visibility: visible;
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
    }
    .task-list {
      list-style: none;
      margin: 0 0 16px 0;
      padding: 0;
    }
    .task-list li {
      padding: 8px 0;
      border-bottom: 1px dashed #eee;
      font-size: 13px;
      color: #666;
    }
    .task-list li:last-child {
      border-bottom: none;
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
    .action-btn + .action-btn {
      margin-top: 8px;
      background: white;
      color: #D32F2F;
      border: 1px solid #D32F2F;
    }
    .action-btn + .action-btn:hover {
      background: #FFF5F5;
      box-shadow: none;
    }
    .stat {
      font-size: 32px;
      font-weight: 700;
      color: #D32F2F;
      margin-bottom: 4px;
      line-height: 1;
    }
    .label {
      font-size: 12px;
      color: #666;
    }
    .notification-preview {
      display: flex;
      align-items: center;
      padding: 8px 0;
      border-bottom: 1px solid #f0f0f0;
      cursor: pointer;
      transition: all 0.2s;
    }
    .notification-preview:last-child {
      border-bottom: none;
    }
    .notification-preview:hover {
      background: #fafafa;
      margin: 0 -8px;
      padding: 8px;
      border-radius: 4px;
    }
    .notification-icon {
      display: none;
    }
    .notification-text {
      flex: 1;
      font-size: 13px;
      color: #333;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .notification-badge {
      background: #D32F2F;
      color: white;
      font-size: 11px;
      padding: 2px 8px;
      border-radius: 10px;
      margin-left: 8px;
      font-weight: 600;
    }
    .notification-time {
      font-size: 11px;
      color: #999;
      margin-left: 8px;
      flex-shrink: 0;
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

<header class="gov-header">
  <h1>志愿者服务中心</h1>
  <div class="actions">
    <span>志愿者：${currentUser.fullName}</span>
    <a href="${pageContext.request.contextPath}/user/profile">个人资料</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <div class="role-badge">VOLUNTEER - 志愿者服务中心</div>
  <div class="profile-banner">
    <div class="avatar">
      <c:choose>
        <c:when test="${not empty currentUser.avatar}">
          <c:choose>
            <c:when test="${fn:startsWith(currentUser.avatar, pageContext.request.contextPath)}">
              <img src="${pageContext.request.contextPath}${currentUser.avatar}" alt="" />
            </c:when>
            <c:otherwise>
              <img src="${pageContext.request.contextPath}${currentUser.avatar}" alt="" />
            </c:otherwise>
          </c:choose>
        </c:when>
        <c:otherwise>
          V
        </c:otherwise>
      </c:choose>
    </div>
    <div class="profile-info">
      <h2>${currentUser.fullName}</h2>
      <p class="label">账号：${currentUser.username} · 手机：${currentUser.phone}</p>
      <div class="tags">
        <c:choose>
          <c:when test="${not empty mySkills}">
            <c:forEach items="${mySkills}" var="skill" varStatus="status">
              <c:if test="${status.index < 5}">
                <span class="tag">${skill.skill.skillName}</span>
              </c:if>
            </c:forEach>
            <c:if test="${mySkills.size() > 5}">
              <span class="tag tag-more">
                +${mySkills.size() - 5}
                <span class="tooltip">
                  <c:forEach items="${mySkills}" var="skill" varStatus="status">
                    <c:if test="${status.index >= 5}">
                      ${skill.skill.skillName}<c:if test="${status.index < mySkills.size() - 1}">, </c:if>
                    </c:if>
                  </c:forEach>
                </span>
              </span>
            </c:if>
          </c:when>
          <c:otherwise>
            <span class="tag" style="background: #f0f0f0; color: #999; border:none;">暂无技能标签</span>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    <div style="margin-left: auto; text-align: center;">
      <div class="stat">${totalPoints}</div>
      <div class="label">当前积分</div>
    </div>
    <div style="margin-left: 30px; text-align: center;">
      <div class="stat" style="font-size: 32px;">#${ranking > 0 ? ranking : '-'}</div>
      <div class="label">我的排名</div>
    </div>
  </div>

  <div class="modules">
    <div class="module-card">
      <h2>我的待办任务</h2>
      <ul class="task-list">
        <li>查看我已认领的任务</li>
        <li>提交任务完成情况</li>
        <li>浏览可认领的任务</li>
      </ul>
      <button class="action-btn primary-btn" onclick="location.href='${pageContext.request.contextPath}/volunteer/task/my'">我的任务</button>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/volunteer/task/hall'">任务大厅</button>
    </div>

    <div class="module-card">
      <h2>服务记录</h2>
      <p class="label" style="min-height: 20px;">本月已完成 15 次服务</p>
      <div style="margin: 15px 0;">
        <div class="stat" style="font-size: 28px;">4.9</div>
        <div class="label">平均评分</div>
      </div>
      <button class="action-btn" onclick="window.location.href='${pageContext.request.contextPath}/volunteer/history/list'">查看历史记录</button>
    </div>

    <div class="module-card">
      <h2>
        通知中心
        <c:if test="${unreadCount > 0}">
          <span class="notification-badge">${unreadCount}</span>
        </c:if>
      </h2>
      <p class="label" style="margin-bottom: 15px;">查看系统通知和重要消息</p>

      <div style="margin-bottom: 15px;">
        <c:choose>
          <c:when test="${not empty recentNotifications}">
            <c:forEach items="${recentNotifications}" var="notif">
              <div class="notification-preview" onclick="location.href='${pageContext.request.contextPath}/notification/list?id=${notif.id}'">
                <div class="notification-icon"></div>
                <div class="notification-text">${notif.title}</div>
                <div class="notification-time">
                   <c:set var="now" value="<%=new java.util.Date()%>" />
                   <fmt:formatDate value="${notif.createdTime}" pattern="MM-dd" />
                </div>
              </div>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <div style="text-align: center; padding: 20px; color: #999; font-size: 14px;">
              暂无新消息
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <button class="action-btn" onclick="window.location.href='${pageContext.request.contextPath}/notification/list'">查看所有通知</button>
    </div>

    <div class="module-card">
      <h2>积分排行榜</h2>
      <p class="label">查看志愿者积分排名</p>
      <div style="margin: 20px 0; text-align: center;">
         <div style="font-size: 14px; color: #666; margin-bottom: 5px;">当前排名</div>
         <div style="font-size: 32px; font-weight: bold; color: var(--gov-red);">
           ${ranking > 0 ? ranking : '-'}
         </div>
      </div>
      <button class="action-btn" onclick="window.location.href='${pageContext.request.contextPath}/points/ranking'">查看完整榜单</button>
    </div>

    <div class="module-card">
      <h2>积分与勋章</h2>
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin: 20px 0;">
        <div style="text-align: center;">
          <div class="stat" style="font-size: 28px;">${totalPoints}</div>
          <div class="label">当前积分</div>
        </div>
        <div style="text-align: center;">
          <div class="stat" style="font-size: 28px;">${badgeCount}</div>
          <div class="label">已获勋章</div>
        </div>
      </div>
      <button class="action-btn" onclick="window.location.href='${pageContext.request.contextPath}/points/my'">查看详情</button>
    </div>

    <div class="module-card">
      <h2>技能配置</h2>
      <p class="label">更新您的志愿服务技能标签，获得更精准的任务匹配</p>
      <button class="action-btn" style="margin-top: 35px;" onclick="window.location.href='${pageContext.request.contextPath}/skill/config'">编辑技能</button>
    </div>

    <div class="module-card">
      <h2>我的关爱计划</h2>
      <p class="label">查看分配给您的关爱计划，记录服务进度</p>
      <button class="action-btn" style="margin-top: 35px;" onclick="window.location.href='${pageContext.request.contextPath}/volunteer/care-plan/list'">查看计划</button>
    </div>

    <div class="module-card">
      <h2>接单大厅</h2>
      <p class="label">浏览并认领待服务的关爱计划，为关爱对象提供帮助</p>
      <button class="action-btn" style="margin-top: 35px;" onclick="window.location.href='${pageContext.request.contextPath}/volunteer/care-plan/hall'">进入大厅</button>
    </div>

    <div class="module-card">
      <h2>我的排班</h2>
      <p class="label">设置您的可用时间段，方便系统自动排班</p>
      <button class="action-btn" style="margin-top: 35px;" onclick="window.location.href='${pageContext.request.contextPath}/volunteer/schedule/manage'">排班管理</button>
    </div>
  </div>
</div>
</body>
</html>

