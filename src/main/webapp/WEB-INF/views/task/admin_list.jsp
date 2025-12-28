<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>任务管理 - 社区关爱协同平台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
    }
    .gov-header {
      background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
      box-shadow: 0 4px 12px rgba(183, 28, 28, 0.15);
      padding: 20px 60px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: white;
    }
    .gov-header h1 {
      font-size: 24px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .gov-header .actions a {
      color: #fff;
      text-decoration: none;
      margin-left: 20px;
      font-weight: 600;
      padding: 8px 16px;
      border-radius: 4px;
      transition: all 0.3s;
    }
    .gov-header .actions a:hover {
      background: rgba(255,255,255,0.2);
    }
    .container {
      padding: 40px 60px;
      max-width: 1400px;
      margin: 0 auto;
    }
    .header-section {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 32px;
    }
    .stats {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 16px;
    }
    .stat-item {
      background: white;
      padding: 16px 20px;
      border-radius: 4px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.06);
    }
    .stat-item .label {
      font-size: 13px;
      color: #64748b;
      margin-bottom: 4px;
    }
    .stat-item .number {
      font-size: 28px;
      font-weight: 700;
      color: #D32F2F;
    }
    .btn-publish {
      background: white;
      border: 2px solid #D32F2F;
      color: #D32F2F;
      padding: 12px 28px;
      border-radius: 4px;
      text-decoration: none;
      font-weight: 700;
      transition: all 0.3s;
    }
    .btn-publish:hover {
      background: #D32F2F;
      color: white;
    }
    .filters {
      background: white;
      padding: 20px 24px;
      border-radius: 4px;
      margin-bottom: 24px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      border-left: 4px solid #D32F2F;
    }
    .filters form {
      display: flex;
      gap: 12px;
      align-items: center;
      flex-wrap: wrap;
    }
    .filters select, .filters input {
      padding: 10px 14px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
      transition: all 0.3s;
    }
    .filters select:focus, .filters input:focus {
      outline: none;
      border-color: #D32F2F;
      box-shadow: 0 0 0 3px rgba(183, 28, 28, 0.1);
    }
    .filters button {
      padding: 10px 24px;
      background: #D32F2F;
      color: #fff;
      border: none;
      border-radius: 4px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
    }
    .filters button:hover {
      background: #B71C1C;
      transform: translateY(-1px);
    }
    .task-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
      gap: 20px;
    }
    .task-card {
      background: #fff;
      border-radius: 4px;
      padding: 20px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.08);
      transition: transform 0.2s;
      border-left: 4px solid;
    }
    .task-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 25px rgba(0,0,0,0.12);
    }
    .task-card.urgent { border-left-color: #ef4444; }
    .task-card.high { border-left-color: #f97316; }
    .task-card.medium { border-left-color: #eab308; }
    .task-card.low { border-left-color: #10b981; }
    .task-header {
      display: flex;
      justify-content: space-between;
      align-items: start;
      margin-bottom: 12px;
    }
    .task-title {
      font-size: 16px;
      font-weight: 700;
      color: #1e293b;
      margin-bottom: 4px;
    }
    .task-type {
      font-size: 22px;
    }
    .task-tags {
      display: flex;
      gap: 6px;
      margin-bottom: 12px;
      flex-wrap: wrap;
    }
    .tag {
      padding: 3px 10px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 600;
    }
    .tag.urgent { background: rgba(239,68,68,0.15); color: #dc2626; }
    .tag.high { background: rgba(249,115,22,0.15); color: #ea580c; }
    .tag.medium { background: rgba(234,179,8,0.15); color: #ca8a04; }
    .tag.low { background: rgba(16,185,129,0.15); color: #059669; }
    .tag.status-pending { background: rgba(211,47,47,0.15); color: #D32F2F; }
    .tag.status-claimed { background: rgba(139,92,246,0.15); color: #7c3aed; }
    .tag.status-progress { background: rgba(245,158,11,0.15); color: #d97706; }
    .tag.status-completed { background: rgba(16,185,129,0.15); color: #059669; }
    .tag.status-approved { background: rgba(34,197,94,0.15); color: #16a34a; }
    .task-info {
      font-size: 13px;
      color: #64748b;
      line-height: 1.6;
      margin-bottom: 12px;
    }
    .task-actions {
      display: flex;
      gap: 8px;
    }
    .btn-sm {
      flex: 1;
      padding: 6px;
      border: none;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 600;
      cursor: pointer;
      text-align: center;
      text-decoration: none;
      display: inline-block;
    }
    .btn-view { background: rgba(102,126,234,0.15); color: #667eea; }
    .btn-approve { background: rgba(16,185,129,0.15); color: #059669; }
    .btn-close { background: rgba(239,68,68,0.15); color: #dc2626; }
  </style>
</head>
<body>
<div class="gov-header">
  <h1>任务派发管理</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/user/admin/dashboard">← 返回控制台</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</div>

<div class="container">
  <div class="header-section">
    <div class="stats">
      <div class="stat-item">
        <div class="label">待认领</div>
        <div class="number">${pendingCount}</div>
      </div>
      <div class="stat-item">
        <div class="label">已认领</div>
        <div class="number">${claimedCount}</div>
      </div>
      <div class="stat-item">
        <div class="label">进行中</div>
        <div class="number">${inProgressCount}</div>
      </div>
      <div class="stat-item">
        <div class="label">待审核</div>
        <div class="number">${completedCount}</div>
      </div>
    </div>
    <a href="${pageContext.request.contextPath}/admin/task/publish" class="btn-publish">+ 发布任务</a>
  </div>

  <div class="filters">
    <form action="${pageContext.request.contextPath}/admin/task/list" method="get">
      <select name="taskType">
        <option value="">全部类型</option>
        <option value="SHOPPING" ${taskType == 'SHOPPING' ? 'selected' : ''}>代购</option>
        <option value="MEDICAL" ${taskType == 'MEDICAL' ? 'selected' : ''}>就医</option>
        <option value="CLEANING" ${taskType == 'CLEANING' ? 'selected' : ''}>清洁</option>
        <option value="ACCOMPANY" ${taskType == 'ACCOMPANY' ? 'selected' : ''}>陪伴</option>
        <option value="REPAIR" ${taskType == 'REPAIR' ? 'selected' : ''}>维修</option>
        <option value="OTHER" ${taskType == 'OTHER' ? 'selected' : ''}>其他</option>
      </select>
      <select name="priority">
        <option value="">全部优先级</option>
        <option value="URGENT" ${priority == 'URGENT' ? 'selected' : ''}>紧急</option>
        <option value="HIGH" ${priority == 'HIGH' ? 'selected' : ''}>高</option>
        <option value="MEDIUM" ${priority == 'MEDIUM' ? 'selected' : ''}>中</option>
        <option value="LOW" ${priority == 'LOW' ? 'selected' : ''}>低</option>
      </select>
      <select name="status">
        <option value="">全部状态</option>
        <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>待认领</option>
        <option value="CLAIMED" ${status == 'CLAIMED' ? 'selected' : ''}>已认领</option>
        <option value="IN_PROGRESS" ${status == 'IN_PROGRESS' ? 'selected' : ''}>进行中</option>
        <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : ''}>待审核</option>
        <option value="APPROVED" ${status == 'APPROVED' ? 'selected' : ''}>已完成</option>
      </select>
      <input type="text" name="keyword" placeholder="搜索任务..." value="${keyword}"/>
      <button type="submit">搜索</button>
    </form>
  </div>

  <div class="task-grid">
    <c:forEach items="${list}" var="task">
      <div class="task-card ${task.priority == 'URGENT' ? 'urgent' : task.priority == 'HIGH' ? 'high' : task.priority == 'MEDIUM' ? 'medium' : 'low'}">
        <div class="task-header">
          <div>
            <div class="task-title">${task.taskTitle}</div>
            <div style="font-size:12px;color:#94a3b8;">服务对象: ${task.elderlyName}</div>
          </div>
          <span class="task-type">
            <c:choose>
              <c:when test="${task.taskType == 'SHOPPING'}">代购</c:when>
              <c:when test="${task.taskType == 'MEDICAL'}">就医</c:when>
              <c:when test="${task.taskType == 'CLEANING'}">清洁</c:when>
              <c:when test="${task.taskType == 'ACCOMPANY'}">陪伴</c:when>
              <c:when test="${task.taskType == 'REPAIR'}">维修</c:when>
              <c:otherwise>其他</c:otherwise>
            </c:choose>
          </span>
        </div>

        <div class="task-tags">
          <span class="tag ${task.priority == 'URGENT' ? 'urgent' : task.priority == 'HIGH' ? 'high' : task.priority == 'MEDIUM' ? 'medium' : 'low'}">
            ${task.priority == 'URGENT' ? '紧急' : task.priority == 'HIGH' ? '高' : task.priority == 'MEDIUM' ? '中' : '低'}
          </span>
          <span class="tag ${task.status == 'PENDING' ? 'status-pending' : task.status == 'CLAIMED' ? 'status-claimed' : task.status == 'IN_PROGRESS' ? 'status-progress' : task.status == 'COMPLETED' ? 'status-completed' : 'status-approved'}">
            ${task.status == 'PENDING' ? '待认领' : task.status == 'CLAIMED' ? '已认领' : task.status == 'IN_PROGRESS' ? '进行中' : task.status == 'COMPLETED' ? '待审核' : '已完成'}
          </span>
        </div>

        <div class="task-info">
          <div>地址: ${task.address}</div>
          <div>时间: <fmt:formatDate value="${task.scheduledDate}" pattern="MM-dd"/> ${task.scheduledTime}</div>
          <c:if test="${not empty task.volunteerName}">
            <div>志愿者: ${task.volunteerName}</div>
          </c:if>
        </div>

        <div class="task-actions">
          <a href="${pageContext.request.contextPath}/admin/task/detail/${task.id}" class="btn-sm btn-view">查看</a>
          <c:if test="${task.status == 'COMPLETED'}">
            <button class="btn-sm btn-approve" onclick="approveTask('${task.id}')">审核</button>
          </c:if>
          <c:if test="${task.status != 'APPROVED' && task.status != 'CANCELLED'}">
            <button class="btn-sm btn-close" onclick="closeTask('${task.id}')">关闭</button>
          </c:if>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<script>
function approveTask(id) {
  const rating = prompt('请输入评分(1-5):', '5');
  if (rating === null) return;
  const feedback = prompt('请输入反馈意见:');
  
  fetch('${pageContext.request.contextPath}/admin/task/approve/' + id, {
    method: 'POST',
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: 'rating=' + rating + '&feedback=' + encodeURIComponent(feedback || '')
  })
  .then(response => response.json())
  .then(data => {
    alert(data.message);
    if (data.success) location.reload();
  });
}

function closeTask(id) {
  if (confirm('确定要关闭这个任务吗？')) {
    fetch('${pageContext.request.contextPath}/admin/task/close/' + id, {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
      if (data.success) location.reload();
    });
  }
}
</script>
</body>
</html>
