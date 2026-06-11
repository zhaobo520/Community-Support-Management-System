<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>消息中心 - 社区关爱系统</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
      font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      color: #1f2937;
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
      color: white;
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
      gap: 18px;
      color: rgba(255,255,255,0.9);
      font-size: 13px;
      flex-wrap: wrap;
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
      max-width: 1100px;
      margin: 0 auto;
      padding: 28px 24px 40px;
    }
    .page-card {
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.06);
      border: 1px solid #eee;
      padding: 24px;
      margin-bottom: 20px;
    }
    .page-title {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 16px;
      flex-wrap: wrap;
    }
    .page-title h2 {
      color: #333;
      font-size: 24px;
      font-weight: 700;
      margin: 0;
    }
    .unread-badge {
      background: #D32F2F;
      color: white;
      padding: 6px 12px;
      border-radius: 999px;
      font-size: 13px;
      font-weight: 700;
    }
    .filter-tabs {
      background: white;
      padding: 16px 20px;
      border-radius: 8px;
      margin-bottom: 20px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.06);
      border: 1px solid #eee;
      display: flex;
      gap: 10px;
      align-items: center;
      flex-wrap: wrap;
    }
    .tab {
      padding: 10px 18px;
      border-radius: 6px;
      border: 1px solid #e5e7eb;
      background: #f8fafc;
      color: #64748b;
      cursor: pointer;
      font-size: 14px;
      font-weight: 600;
      transition: all 0.3s;
    }
    .tab:hover {
      background: #edf2f7;
      color: #334155;
    }
    .tab.active {
      background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
      color: white;
      border-color: #D32F2F;
    }
    .action-buttons {
      margin-left: auto;
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
    }
    .btn {
      padding: 10px 16px;
      border-radius: 6px;
      border: none;
      cursor: pointer;
      font-size: 14px;
      font-weight: 600;
      transition: all 0.3s;
    }
    .btn-primary {
      background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
      color: white;
    }
    .btn-secondary {
      background: #edf2f7;
      color: #64748b;
    }
    .btn:hover {
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.12);
    }
    .notifications-list {
      background: white;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 12px rgba(0,0,0,0.06);
      border: 1px solid #eee;
    }
    .notification-item {
      padding: 20px 24px;
      border-bottom: 1px solid #e2e8f0;
      transition: all 0.3s;
      cursor: pointer;
      position: relative;
    }
    .notification-item:last-child { border-bottom: none; }
    .notification-item:hover { background: #f8fafc; }
    .notification-item.unread {
      background: #fff5f5;
      border-left: 4px solid #D32F2F;
    }
    .notification-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 12px;
      margin-bottom: 8px;
    }
    .notification-title {
      font-size: 16px;
      font-weight: 700;
      color: #2d3748;
      display: flex;
      align-items: center;
      gap: 8px;
      flex-wrap: wrap;
    }
    .notification-time {
      font-size: 13px;
      color: #94a3b8;
      white-space: nowrap;
    }
    .notification-content {
      color: #4a5568;
      font-size: 14px;
      line-height: 1.7;
      margin-bottom: 10px;
    }
    .notification-actions {
      display: flex;
      gap: 12px;
      margin-top: 10px;
      flex-wrap: wrap;
    }
    .action-link {
      color: #D32F2F;
      font-size: 13px;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s;
    }
    .action-link:hover {
      color: #B71C1C;
      text-decoration: underline;
    }
    .empty-state {
      text-align: center;
      padding: 60px 20px;
      color: #94a3b8;
    }
    .empty-state-text {
      font-size: 18px;
      margin-bottom: 10px;
      color: #64748b;
    }
    .type-badge {
      padding: 4px 10px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 700;
    }
    .type-demand {
      background: #dbeafe;
      color: #1d4ed8;
    }
    .type-task {
      background: #dcfce7;
      color: #166534;
    }
    .type-system {
      background: #fee2e2;
      color: #991b1b;
    }
    @media (max-width: 768px) {
      .gov-header {
        padding: 10px 16px;
        height: auto;
        min-height: 64px;
        flex-direction: column;
        align-items: flex-start;
        justify-content: center;
        gap: 8px;
      }
      .gov-header h1 {
        margin-left: 32px;
      }
      .container {
        padding: 20px 14px 32px;
      }
      .notification-header {
        flex-direction: column;
      }
      .action-buttons {
        margin-left: 0;
      }
      .filter-tabs {
        align-items: stretch;
      }
    }
  </style>
</head>
<body>
<header class="gov-header">
  <h1>社区管理员工作台</h1>
  <div class="nav-right">
    <span>当前页面：消息中心</span>
    <c:choose>
      <c:when test="${currentUser.roleType == 'FAMILY'}">
        <a href="${pageContext.request.contextPath}/user/family/dashboard">返回首页</a>
      </c:when>
      <c:when test="${currentUser.roleType == 'VOLUNTEER'}">
        <a href="${pageContext.request.contextPath}/user/volunteer/dashboard">返回首页</a>
      </c:when>
      <c:when test="${currentUser.roleType == 'STAFF'}">
        <a href="${pageContext.request.contextPath}/user/admin/dashboard">返回首页</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/user/admin/login">返回首页</a>
      </c:otherwise>
    </c:choose>
  </div>
</header>

<div class="container">
  <div class="page-card">
    <div class="page-title">
      <h2>消息中心</h2>
      <c:if test="${unreadCount > 0}">
        <span class="unread-badge">未读 ${unreadCount}</span>
      </c:if>
    </div>
  </div>

  <div class="filter-tabs">
    <button class="tab ${empty filter ? 'active' : ''}" onclick="location.href='${pageContext.request.contextPath}/notification/list'">全部消息</button>
    <button class="tab ${filter == 'unread' ? 'active' : ''}" onclick="location.href='${pageContext.request.contextPath}/notification/list?filter=unread'">
      未读消息
      <c:if test="${unreadCount > 0}">(${unreadCount})</c:if>
    </button>
    <button class="tab ${filter == 'read' ? 'active' : ''}" onclick="location.href='${pageContext.request.contextPath}/notification/list?filter=read'">已读消息</button>

    <div class="action-buttons">
      <button class="btn btn-primary" onclick="markAllAsRead()">全部已读</button>
      <button class="btn btn-secondary" onclick="clearRead()">清空已读</button>
    </div>
  </div>

  <div class="notifications-list">
    <c:choose>
      <c:when test="${empty notifications}">
        <div class="empty-state">
          <div class="empty-state-text">暂无消息</div>
          <p style="font-size:14px;">当有新消息时，会在这里显示</p>
        </div>
      </c:when>
      <c:otherwise>
        <c:forEach items="${notifications}" var="notif">
          <div class="notification-item ${notif.isRead == 0 ? 'unread' : ''}" data-notif-id="${notif.id}" onclick="markAsRead(this.getAttribute('data-notif-id'))">
            <div class="notification-header">
              <div class="notification-title">
                ${notif.title}
                <c:if test="${notif.relatedType != null}">
                  <span class="type-badge type-${notif.relatedType == 'DEMAND' ? 'demand' : 'task'}">
                    ${notif.relatedType == 'DEMAND' ? '需求' : '任务'}
                  </span>
                </c:if>
              </div>
              <div class="notification-time">
                <fmt:formatDate value="${notif.createdTime}" pattern="MM-dd HH:mm"/>
              </div>
            </div>

            <div class="notification-content">
              ${notif.content}
            </div>

            <div class="notification-actions">
              <c:if test="${notif.relatedType == 'DEMAND' && notif.relatedId != null}">
                <a href="${pageContext.request.contextPath}/demand/family/detail/${notif.relatedId}" class="action-link" onclick="event.stopPropagation()">查看需求详情 ></a>
              </c:if>
              <c:if test="${notif.relatedType == 'TASK' && notif.relatedId != null}">
                <a href="${pageContext.request.contextPath}/volunteer/task/detail/${notif.relatedId}" class="action-link" onclick="event.stopPropagation()">查看任务详情 ></a>
              </c:if>
              <a href="javascript:void(0)" class="action-link" data-notif-id="${notif.id}" onclick="event.stopPropagation(); deleteNotification(this.getAttribute('data-notif-id'))">删除</a>
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<script>
  function markAsRead(id) {
    fetch('${pageContext.request.contextPath}/notification/read/' + id, { method: 'POST' })
    .then(response => response.json())
    .then(data => { if (data.success) { location.reload(); } });
  }

  function markAllAsRead() {
    if (!confirm('确定要将所有消息标记为已读吗？')) { return; }
    fetch('${pageContext.request.contextPath}/notification/read-all', { method: 'POST' })
    .then(response => response.json())
    .then(data => {
      if (data.success) { alert('操作成功'); location.reload(); }
      else { alert('操作失败：' + data.message); }
    });
  }

  function clearRead() {
    if (!confirm('确定要清空所有已读消息吗？此操作不可恢复。')) { return; }
    fetch('${pageContext.request.contextPath}/notification/clear-read', { method: 'POST' })
    .then(response => response.json())
    .then(data => {
      if (data.success) { alert('操作成功'); location.reload(); }
      else { alert('操作失败：' + data.message); }
    });
  }

  function deleteNotification(id) {
    if (!confirm('确定要删除这条消息吗？')) { return; }
    fetch('${pageContext.request.contextPath}/notification/delete/' + id, { method: 'POST' })
    .then(response => response.json())
    .then(data => {
      if (data.success) { location.reload(); }
      else { alert('删除失败：' + data.message); }
    });
  }
</script>
</body>
</html>
