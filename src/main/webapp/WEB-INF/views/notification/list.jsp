<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>消息中心 - 社区关爱系统</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      background: #FAF5F0;
      min-height: 100vh;
      padding: 20px;
    }

    .container {
      max-width: 900px;
      margin: 0 auto;
    }

    .header {
      background: white;
      padding: 25px 30px;
      border-radius: 4px;
      margin-bottom: 25px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.1);
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .header h1 {
      color: #D32F2F;
      font-size: 28px;
      display: flex;
      align-items: center;
      gap: 12px;
      font-weight: 600;
    }

    .unread-badge {
      background: #f56565;
      color: white;
      padding: 4px 12px;
      border-radius: 4px;
      font-size: 14px;
      font-weight: bold;
    }

    .filter-tabs {
      background: white;
      padding: 15px 20px;
      border-radius: 4px;
      margin-bottom: 20px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.08);
      display: flex;
      gap: 10px;
      align-items: center;
    }

    .tab {
      padding: 8px 20px;
      border-radius: 4px;
      border: none;
      background: #f7fafc;
      color: #718096;
      cursor: pointer;
      font-size: 14px;
      font-weight: 500;
      transition: all 0.3s;
    }

    .tab:hover {
      background: #edf2f7;
      color: #4a5568;
    }

    .tab.active {
      background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
      color: white;
    }

    .action-buttons {
      margin-left: auto;
      display: flex;
      gap: 10px;
    }

    .btn {
      padding: 8px 16px;
      border-radius: 4px;
      border: none;
      cursor: pointer;
      font-size: 14px;
      font-weight: 500;
      transition: all 0.3s;
    }

    .btn-primary {
      background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
      color: white;
    }

    .btn-secondary {
      background: #edf2f7;
      color: #718096;
    }

    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .notifications-list {
      background: white;
      border-radius: 4px;
      overflow: hidden;
      box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

    .notification-item {
      padding: 20px 25px;
      border-bottom: 1px solid #e2e8f0;
      transition: all 0.3s;
      cursor: pointer;
      position: relative;
    }

    .notification-item:last-child {
      border-bottom: none;
    }

    .notification-item:hover {
      background: #f7fafc;
    }

    .notification-item.unread {
      background: #edf7ff;
      border-left: 4px solid #D32F2F;
    }

    .notification-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 8px;
    }

    .notification-title {
      font-size: 16px;
      font-weight: 600;
      color: #2d3748;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .notification-icon {
      font-size: 20px;
      display: none;
    }

    .notification-time {
      font-size: 13px;
      color: #a0aec0;
    }

    .notification-content {
      color: #4a5568;
      font-size: 14px;
      line-height: 1.6;
      margin-bottom: 10px;
    }

    .notification-actions {
      display: flex;
      gap: 10px;
      margin-top: 10px;
    }

    .action-link {
      color: #D32F2F;
      font-size: 13px;
      text-decoration: none;
      font-weight: 500;
      transition: all 0.3s;
    }

    .action-link:hover {
      color: #B71C1C;
      text-decoration: underline;
    }

    .empty-state {
      text-align: center;
      padding: 60px 20px;
      color: #a0aec0;
    }

    .empty-state-icon {
      font-size: 64px;
      margin-bottom: 15px;
      opacity: 0.5;
      display: none;
    }

    .empty-state-text {
      font-size: 18px;
      margin-bottom: 10px;
    }

    .type-badge {
      padding: 3px 10px;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 500;
    }

    .type-demand {
      background: #bee3f8;
      color: #2c5282;
    }

    .type-task {
      background: #c6f6d5;
      color: #22543d;
    }

    .type-system {
      background: #fed7d7;
      color: #742a2a;
    }

    .back-link {
      color: #D32F2F;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 20px;
      font-size: 14px;
      opacity: 0.9;
      transition: opacity 0.3s;
    }

    .back-link:hover {
      opacity: 1;
    }
  </style>
</head>
<body>
<div class="container">
  <c:choose>
    <c:when test="${currentUser.roleType == 'FAMILY'}">
      <a href="${pageContext.request.contextPath}/user/family/dashboard" class="back-link">
        ← 返回首页
      </a>
    </c:when>
    <c:when test="${currentUser.roleType == 'VOLUNTEER'}">
      <a href="${pageContext.request.contextPath}/user/volunteer/dashboard" class="back-link">
        ← 返回首页
      </a>
    </c:when>
    <c:when test="${currentUser.roleType == 'STAFF'}">
      <a href="${pageContext.request.contextPath}/user/admin/dashboard" class="back-link">
        ← 返回首页
      </a>
    </c:when>
    <c:otherwise>
      <a href="${pageContext.request.contextPath}/user/admin/login" class="back-link">
        ← 返回首页
      </a>
    </c:otherwise>
  </c:choose>

  <div class="header">
    <h1>
      消息中心
      <c:if test="${unreadCount > 0}">
        <span class="unread-badge">${unreadCount}</span>
      </c:if>
    </h1>
  </div>

  <div class="filter-tabs">
    <button class="tab ${empty filter ? 'active' : ''}" onclick="location.href='${pageContext.request.contextPath}/notification/list'">
      全部消息
    </button>
    <button class="tab ${filter == 'unread' ? 'active' : ''}" onclick="location.href='${pageContext.request.contextPath}/notification/list?filter=unread'">
      未读消息
      <c:if test="${unreadCount > 0}">
        (${unreadCount})
      </c:if>
    </button>
    <button class="tab ${filter == 'read' ? 'active' : ''}" onclick="location.href='${pageContext.request.contextPath}/notification/list?filter=read'">
      已读消息
    </button>

    <div class="action-buttons">
      <button class="btn btn-primary" onclick="markAllAsRead()">全部已读</button>
      <button class="btn btn-secondary" onclick="clearRead()">清空已读</button>
    </div>
  </div>

  <div class="notifications-list">
    <c:choose>
      <c:when test="${empty notifications}">
        <div class="empty-state">
          <div class="empty-state-icon"></div>
          <div class="empty-state-text">暂无消息</div>
          <p style="font-size: 14px;">当有新消息时，会在这里显示</p>
        </div>
      </c:when>
      <c:otherwise>
        <c:forEach items="${notifications}" var="notif">
          <div class="notification-item ${notif.isRead == 0 ? 'unread' : ''}" data-notif-id="${notif.id}" onclick="markAsRead(this.getAttribute('data-notif-id'))">
            <div class="notification-header">
              <div class="notification-title">
                <span class="notification-icon">
                  <c:choose>
                    <c:when test="${notif.type == 'DEMAND_REVIEW'}"></c:when>
                    <c:when test="${notif.type == 'TASK_ASSIGN'}"></c:when>
                    <c:when test="${notif.type == 'TASK_COMPLETE'}"></c:when>
                    <c:when test="${notif.type == 'TASK_APPROVE'}"></c:when>
                    <c:otherwise></c:otherwise>
                  </c:choose>
                </span>
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
                <a href="${pageContext.request.contextPath}/demand/family/detail/${notif.relatedId}" 
                   class="action-link" onclick="event.stopPropagation()">查看需求详情 ></a>
              </c:if>
              <c:if test="${notif.relatedType == 'TASK' && notif.relatedId != null}">
                <a href="${pageContext.request.contextPath}/volunteer/task/detail/${notif.relatedId}" 
                   class="action-link" onclick="event.stopPropagation()">查看任务详情 ></a>
              </c:if>
              <a href="javascript:void(0)" class="action-link" data-notif-id="${notif.id}"
                 onclick="event.stopPropagation(); deleteNotification(this.getAttribute('data-notif-id'))">删除</a>
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<script>
  function markAsRead(id) {
    fetch('${pageContext.request.contextPath}/notification/read/' + id, {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        location.reload();
      }
    });
  }

  function markAllAsRead() {
    if (!confirm('确定要将所有消息标记为已读吗？')) {
      return;
    }

    fetch('${pageContext.request.contextPath}/notification/read-all', {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        alert('操作成功');
        location.reload();
      } else {
        alert('操作失败：' + data.message);
      }
    });
  }

  function clearRead() {
    if (!confirm('确定要清空所有已读消息吗？此操作不可恢复。')) {
      return;
    }

    fetch('${pageContext.request.contextPath}/notification/clear-read', {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        alert('操作成功');
        location.reload();
      } else {
        alert('操作失败：' + data.message);
      }
    });
  }

  function deleteNotification(id) {
    if (!confirm('确定要删除这条消息吗？')) {
      return;
    }

    fetch('${pageContext.request.contextPath}/notification/delete/' + id, {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        location.reload();
      } else {
        alert('删除失败：' + data.message);
      }
    });
  }
</script>
</body>
</html>
