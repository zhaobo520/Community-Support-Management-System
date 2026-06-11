<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>任务大厅</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
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
    }
    .gov-header h1 {
      color: white;
      font-size: 18px;
      font-weight: 600;
      letter-spacing: 2px;
    }
    .gov-header .actions {
      display: flex;
      align-items: center;
      gap: 16px;
    }
    .gov-header .actions a {
      color: rgba(255,255,255,0.9);
      text-decoration: none;
      font-size: 13px;
      padding: 8px 14px;
      border-radius: 6px;
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
    .header-banner {
      background: linear-gradient(135deg, #B71C1C 0%, #D32F2F 100%);
      border-radius: 8px;
      padding: 28px 32px;
      margin-bottom: 24px;
      text-align: center;
      color: #fff;
      box-shadow: 0 2px 12px rgba(0,0,0,0.1);
      position: relative;
      overflow: hidden;
    }
    .header-banner::before {
      content: '★';
      position: absolute;
      top: -20px;
      left: 20px;
      font-size: 100px;
      color: rgba(255,255,255,0.1);
      transform: rotate(-15deg);
    }
    .header-banner h2 {
      font-size: 22px;
      margin-bottom: 8px;
      color: white;
      position: relative;
    }
    .header-banner p {
      font-size: 14px;
      opacity: 0.9;
      position: relative;
    }
    .filters {
      background: white;
      padding: 16px 20px;
      border-radius: 8px;
      margin-bottom: 20px;
      display: flex;
      gap: 12px;
      align-items: center;
      box-shadow: 0 2px 12px rgba(0,0,0,0.06);
      border-left: 4px solid #D32F2F;
    }
    .filters select {
      padding: 10px 14px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 13px;
      outline: none;
      background: #fafafa;
      transition: all 0.2s;
    }
    .filters select:focus {
      border-color: #D32F2F;
      background: white;
      box-shadow: 0 0 0 3px rgba(211,47,47,0.1);
    }
    .task-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 20px;
    }
    .task-card {
      background: white;
      border-radius: 8px;
      padding: 24px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.06);
      transition: all 0.2s;
      position: relative;
      overflow: hidden;
      border: 1px solid #eee;
    }
    .task-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 24px rgba(0,0,0,0.12);
      border-color: #D32F2F;
    }
    .task-card::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0; height: 4px;
    }
    .task-card.urgent::before { background: #B71C1C; }
    .task-card.high::before { background: #E53935; }
    .task-card.medium::before { background: #FB8C00; }
    .task-card.low::before { background: #43A047; }
    .task-type-icon {
      font-size: 36px;
      text-align: center;
      margin-bottom: 14px;
      background: rgba(183, 28, 28, 0.06);
      width: 72px;
      height: 72px;
      line-height: 72px;
      border-radius: 50%;
      margin: 0 auto 14px;
    }
    .task-title {
      font-size: 16px;
      font-weight: 600;
      color: #333;
      margin-bottom: 6px;
      text-align: center;
    }
    .task-elderly {
      text-align: center;
      font-size: 13px;
      color: #666;
      margin-bottom: 14px;
    }
    .task-tags {
      display: flex;
      gap: 6px;
      justify-content: center;
      margin-bottom: 14px;
      flex-wrap: wrap;
    }
    .gov-badge {
      padding: 4px 10px;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 600;
      background: #f5f5f5;
    }
    .gov-badge.primary {
      background: #FFEBEE;
      color: #C62828;
    }
    .task-details {
      background: #fafafa;
      padding: 14px;
      border-radius: 6px;
      font-size: 12px;
      color: #666;
      line-height: 1.8;
      margin-bottom: 14px;
      border: 1px solid #eee;
    }
    .btn-claim {
      flex: 1;
      padding: 10px;
      background: #D32F2F;
      border: none;
      color: white;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
    }
    .btn-claim:hover {
      background: #B71C1C;
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(211,47,47,0.3);
    }
    .btn-detail {
      flex: 1;
      padding: 10px;
      background: white;
      color: #D32F2F;
      border: 1px solid #D32F2F;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
    }
    .btn-detail:hover {
      background: #FFF5F5;
    }
    .empty {
      text-align: center;
      padding: 60px 20px;
      color: #666;
      background: white;
      border-radius: 8px;
    }
    .empty h2 {
      font-size: 18px;
      margin-bottom: 8px;
    }
    .empty p {
      font-size: 14px;
      color: #999;
    }
    @media (max-width: 768px) {
      .gov-header { padding: 0 16px; }
      .container { padding: 20px 16px; }
      .task-grid { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>

<header class="gov-header">
  <h1>党员志愿服务大厅</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/volunteer/task/my">我的任务</a>
    <a href="${pageContext.request.contextPath}/user/volunteer/dashboard">返回控制台</a>
    <a href="${pageContext.request.contextPath}/user/logout" style="background:white;color:#D32F2F;padding:8px 20px;font-weight:700;font-size:15px;border-radius:4px;">退出</a>
  </div>
</header>

<div class="container fade-in-up">
  <div class="header-banner">
    <h2>认领微心愿 · 传递正能量</h2>
    <p>帮助社区群众解决急难愁盼问题，践行志愿服务精神</p>
  </div>

  <div class="filters">
    <form action="${pageContext.request.contextPath}/volunteer/task/hall" method="get" style="display:flex;gap:12px;width:100%;">
      <select name="taskType" onchange="this.form.submit()">
        <option value="">全部服务类型</option>
        <option value="SHOPPING" ${taskType == 'SHOPPING' ? 'selected' : ''}>物资代购</option>
        <option value="MEDICAL" ${taskType == 'MEDICAL' ? 'selected' : ''}>陪同就医</option>
        <option value="CLEANING" ${taskType == 'CLEANING' ? 'selected' : ''}>上门保洁</option>
        <option value="ACCOMPANY" ${taskType == 'ACCOMPANY' ? 'selected' : ''}>精神慰藉</option>
        <option value="REPAIR" ${taskType == 'REPAIR' ? 'selected' : ''}>居家维修</option>
        <option value="OTHER" ${taskType == 'OTHER' ? 'selected' : ''}>其他服务</option>
      </select>
    </form>
  </div>

  <div class="task-grid">
    <c:forEach items="${list}" var="task">
      <div class="task-card ${task.priority == 'URGENT' ? 'urgent' : task.priority == 'HIGH' ? 'high' : task.priority == 'MEDIUM' ? 'medium' : 'low'}">
        <div class="task-type-icon">
          <c:choose>
            <c:when test="${task.taskType == 'SHOPPING'}">代购</c:when>
            <c:when test="${task.taskType == 'MEDICAL'}">就医</c:when>
            <c:when test="${task.taskType == 'CLEANING'}">清洁</c:when>
            <c:when test="${task.taskType == 'ACCOMPANY'}">陪伴</c:when>
            <c:when test="${task.taskType == 'REPAIR'}">维修</c:when>
            <c:otherwise>其他</c:otherwise>
          </c:choose>
        </div>

        <div class="task-title">
          ${task.taskTitle}
          <c:if test="${not empty task.demand && not empty task.demand.attachmentUrl}">
            <span style="margin-left:8px;color:#D32F2F;font-size:14px;" title="包含情景图片">[图]</span>
          </c:if>
        </div>
        <div class="task-elderly">服务对象：${task.elderlyName}</div>

        <div class="task-tags">
          <span class="gov-badge ${task.priority == 'URGENT' ? 'primary' : ''}" style="border:1px solid #ddd;">
            ${task.priority == 'URGENT' ? '紧急' : task.priority == 'HIGH' ? '高优先' : task.priority == 'MEDIUM' ? '中等' : '普通'}
          </span>
          <c:if test="${not empty task.demand && not empty task.demand.attachmentUrl}">
            <span class="gov-badge">有图</span>
          </c:if>
          <c:if test="${not empty task.demand && not empty task.demand.intendedVolunteer}">
            <span class="gov-badge" style="background:#FFF8E1;color:#F57C00;border:1px solid #FFD54F;" title="家属在发布需求时指定的意向志愿者">★ 意向：${task.demand.intendedVolunteer.fullName}</span>
          </c:if>
        </div>

        <div class="task-details">
          <div>地址：${task.address}</div>
          <div>时间：<fmt:formatDate value="${task.scheduledDate}" pattern="MM月dd日"/> ${task.scheduledTime}</div>
          <div>电话：${task.contactPhone}</div>
          <c:if test="${not empty task.demand && not empty task.demand.intendedVolunteer}">
            <div style="margin-top:6px;color:#F57C00;font-weight:600;">家属意向志愿者：${task.demand.intendedVolunteer.fullName}
              <c:if test="${not empty task.demand.intendedVolunteer.phone}"> · ${task.demand.intendedVolunteer.phone}</c:if>
            </div>
          </c:if>
          <c:if test="${not empty task.description}">
            <div style="margin-top:8px;color:#666;border-top:1px dashed #ddd;padding-top:8px;">${task.description}</div>
          </c:if>
        </div>

        <div style="display:flex;gap:10px;margin-top:15px;">
          <button class="btn-detail" onclick="viewDetail('${task.id}')">详情</button>
          <button class="btn-claim" onclick="claimTask('${task.id}')">认领</button>
        </div>
      </div>
    </c:forEach>
  </div>

  <c:if test="${empty list}">
    <div class="empty">
      <h2>暂无可认领的服务任务</h2>
      <p>感谢您的关注，请稍后再来查看</p>
    </div>
  </c:if>
</div>
</body>
<script>
// 查看任务详情
function viewDetail(taskId) {
  if (!taskId || taskId === 'null') {
    alert('任务ID无效');
    return;
  }
  window.location.href = '${pageContext.request.contextPath}/task/detail/' + taskId;
}

// 认领任务
function claimTask(id) {
  if (!id || id === 'null') {
    alert('任务ID无效');
    return;
  }
  
  if (confirm('确定要认领这个任务吗？')) {
    fetch('${pageContext.request.contextPath}/volunteer/task/claim/' + id, {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
      if (data.success) {
        window.location.href = '${pageContext.request.contextPath}/volunteer/task/my';
      }
    })
    .catch(error => {
      console.error('Error:', error);
      alert('操作失败，请稍后重试');
    });
  }
}
</script>
</body>
</html>
