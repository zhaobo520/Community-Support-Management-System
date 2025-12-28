<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>我的任务 - 志愿者服务中心</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
    }
    .vol-header {
      background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      padding: 20px 60px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: white;
    }
    .vol-header h1 {
      font-size: 24px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .vol-header .actions a {
      color: #fff;
      text-decoration: none;
      margin-left: 20px;
      font-weight: 600;
      padding: 8px 16px;
      border-radius: 4px;
      transition: all 0.3s;
    }
    .vol-header .actions a:hover {
      background: rgba(255,255,255,0.2);
    }
    .container {
      padding: 40px 60px;
      max-width: 1400px;
      margin: 0 auto;
    }
    .stats-bar {
      background: #fff;
      padding: 20px 32px;
      border-radius: 8px;
      margin-bottom: 24px;
      display: flex;
      gap: 40px;
      align-items: center;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
      border-left: 4px solid #D32F2F;
    }
    .stats-bar .stat {
      text-align: center;
      padding: 0 20px;
      border-right: 1px solid #eee;
    }
    .stats-bar .stat:last-child {
      border-right: none;
    }
    .stats-bar .stat-number {
      font-size: 32px;
      font-weight: 700;
      color: #D32F2F;
    }
    .stats-bar .stat-label {
      font-size: 13px;
      color: #64748b;
      margin-top: 4px;
    }
    .filters {
      background: #fff;
      padding: 16px 24px;
      border-radius: 8px;
      margin-bottom: 24px;
      display: flex;
      gap: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
      border-left: 4px solid #D32F2F;
    }
    .filters select {
      padding: 10px 14px;
      border: 1px solid #ddd;
      border-radius: 6px;
      transition: all 0.3s;
      background: #fafafa;
      font-size: 14px;
    }
    .filters select:focus {
      outline: none;
      border-color: #D32F2F;
      box-shadow: 0 0 0 3px rgba(211,47,47,0.1);
    }
    /* 卡片网格布局 */
    .task-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 20px;
    }
    .task-card {
      background: #fff;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
      transition: all 0.3s;
      border: 1px solid #eee;
      position: relative;
    }
    .task-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 24px rgba(0,0,0,0.12);
      border-color: #D32F2F;
    }
    /* 左侧状态条 */
    .task-card::before {
      content: '';
      position: absolute;
      left: 0;
      top: 0;
      bottom: 0;
      width: 4px;
    }
    .task-card.status-claimed::before { background: #7c3aed; }
    .task-card.status-progress::before { background: #f59e0b; }
    .task-card.status-completed::before { background: #3b82f6; }
    .task-card.status-approved::before { background: #10b981; }

    .card-content {
      padding: 20px;
    }
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 12px;
    }
    .card-title {
      font-size: 16px;
      font-weight: 700;
      color: #1e293b;
      margin-bottom: 4px;
    }
    .card-elderly {
      font-size: 13px;
      color: #64748b;
    }
    .card-type {
      font-size: 24px;
      font-weight: 700;
      color: #D32F2F;
      opacity: 0.8;
    }
    .card-tags {
      display: flex;
      gap: 6px;
      margin-bottom: 12px;
      flex-wrap: wrap;
    }
    .tag {
      padding: 4px 10px;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 600;
    }
    .tag.urgent { background: rgba(239,68,68,0.15); color: #dc2626; border: 1px solid rgba(239,68,68,0.3); }
    .tag.high { background: rgba(249,115,22,0.15); color: #ea580c; border: 1px solid rgba(249,115,22,0.3); }
    .tag.medium { background: rgba(234,179,8,0.15); color: #ca8a04; border: 1px solid rgba(234,179,8,0.3); }
    .tag.low { background: rgba(16,185,129,0.15); color: #059669; border: 1px solid rgba(16,185,129,0.3); }
    .tag.claimed { background: rgba(139,92,246,0.15); color: #7c3aed; border: 1px solid rgba(139,92,246,0.3); }
    .tag.progress { background: rgba(245,158,11,0.15); color: #d97706; border: 1px solid rgba(245,158,11,0.3); }
    .tag.completed { background: rgba(59,130,246,0.15); color: #2563eb; border: 1px solid rgba(59,130,246,0.3); }
    .tag.approved { background: rgba(16,185,129,0.15); color: #059669; border: 1px solid rgba(16,185,129,0.3); }

    .card-info {
      font-size: 13px;
      color: #64748b;
      line-height: 1.8;
      margin-bottom: 12px;
    }
    .card-info div {
      display: flex;
      align-items: center;
      gap: 4px;
    }
    .card-info .label {
      color: #94a3b8;
    }
    .card-feedback {
      background: rgba(16,185,129,0.1);
      padding: 10px 12px;
      border-radius: 6px;
      font-size: 12px;
      color: #059669;
      margin-bottom: 12px;
    }
    .card-actions {
      display: flex;
      gap: 8px;
      padding-top: 12px;
      border-top: 1px solid #f1f5f9;
    }
    .btn {
      flex: 1;
      padding: 10px 12px;
      border: none;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      text-align: center;
    }
    .btn:hover {
      transform: translateY(-1px);
    }
    .btn-detail {
      background: rgba(59,130,246,0.1);
      color: #2563eb;
      border: 1px solid rgba(59,130,246,0.2);
    }
    .btn-detail:hover {
      background: rgba(59,130,246,0.2);
    }
    .btn-start {
      background: rgba(211,47,47,0.1);
      color: #D32F2F;
      border: 1px solid rgba(211,47,47,0.2);
    }
    .btn-start:hover {
      background: rgba(211,47,47,0.2);
    }
    .btn-submit {
      background: rgba(16,185,129,0.1);
      color: #059669;
      border: 1px solid rgba(16,185,129,0.2);
    }
    .btn-submit:hover {
      background: rgba(16,185,129,0.2);
    }
    .btn-cancel {
      background: rgba(239,68,68,0.1);
      color: #dc2626;
      border: 1px solid rgba(239,68,68,0.2);
    }
    .btn-cancel:hover {
      background: rgba(239,68,68,0.2);
    }
    .status-text {
      flex: 2;
      text-align: center;
      padding: 10px;
      font-size: 13px;
      border-radius: 6px;
    }
    .status-text.waiting {
      background: rgba(100,116,139,0.1);
      color: #64748b;
    }
    .status-text.done {
      background: rgba(16,185,129,0.1);
      color: #059669;
    }
    .empty {
      text-align: center;
      padding: 80px 20px;
      color: #94a3b8;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    }
    .empty h2 {
      font-size: 18px;
      margin-bottom: 8px;
      color: #64748b;
    }
    .empty p {
      font-size: 14px;
    }
    .empty a {
      color: #D32F2F;
      text-decoration: none;
      font-weight: 600;
    }
    .empty a:hover {
      text-decoration: underline;
    }
    @media (max-width: 1200px) {
      .task-grid { grid-template-columns: repeat(2, 1fr); }
      .container { padding: 30px 40px; }
    }
    @media (max-width: 768px) {
      .task-grid { grid-template-columns: 1fr; }
      .container { padding: 20px; }
      .vol-header { padding: 16px 20px; }
      .stats-bar { flex-wrap: wrap; gap: 20px; }
    }
  </style>
</head>
<body>
<div class="vol-header">
  <h1>我的任务</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/volunteer/task/hall">任务大厅</a>
    <a href="${pageContext.request.contextPath}/user/volunteer/dashboard">返回控制台</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</div>

<div class="container">
  <div class="stats-bar">
    <div class="stat">
      <div class="stat-number">${totalCount}</div>
      <div class="stat-label">累计任务</div>
    </div>
    <div class="stat">
      <div class="stat-number" style="color:#f97316;">${fn:length(list)}</div>
      <div class="stat-label">当前任务</div>
    </div>
  </div>

  <div class="filters">
    <form action="${pageContext.request.contextPath}/volunteer/task/my" method="get" style="display:flex;gap:12px;">
      <select name="status" onchange="this.form.submit()">
        <option value="">全部状态</option>
        <option value="CLAIMED" ${status == 'CLAIMED' ? 'selected' : ''}>已认领</option>
        <option value="IN_PROGRESS" ${status == 'IN_PROGRESS' ? 'selected' : ''}>进行中</option>
        <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : ''}>待审核</option>
        <option value="APPROVED" ${status == 'APPROVED' ? 'selected' : ''}>已完成</option>
      </select>
    </form>
  </div>

  <div class="task-grid">
    <c:forEach items="${list}" var="task">
      <div class="task-card status-${task.status == 'CLAIMED' ? 'claimed' : task.status == 'IN_PROGRESS' ? 'progress' : task.status == 'COMPLETED' ? 'completed' : 'approved'}">
        <div class="card-content">
          <div class="card-header">
            <div>
              <div class="card-title">${task.taskTitle}</div>
              <div class="card-elderly">服务对象: ${task.elderlyName}</div>
            </div>
            <span class="card-type">
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

          <div class="card-tags">
            <c:if test="${task.priority == 'URGENT'}">
              <span class="tag urgent">紧急</span>
            </c:if>
            <c:if test="${task.priority == 'HIGH'}">
              <span class="tag high">高</span>
            </c:if>
            <c:if test="${task.priority == 'MEDIUM'}">
              <span class="tag medium">中</span>
            </c:if>
            <c:if test="${task.priority == 'LOW'}">
              <span class="tag low">普通</span>
            </c:if>
            <span class="tag ${task.status == 'CLAIMED' ? 'claimed' : task.status == 'IN_PROGRESS' ? 'progress' : task.status == 'COMPLETED' ? 'completed' : 'approved'}">
              ${task.status == 'CLAIMED' ? '已认领' : task.status == 'IN_PROGRESS' ? '进行中' : task.status == 'COMPLETED' ? '待审核' : '已完成'}
            </span>
          </div>

          <div class="card-info">
            <div><span class="label">地址:</span> ${task.address}</div>
            <div><span class="label">时间:</span> <fmt:formatDate value="${task.scheduledDate}" pattern="MM-dd"/> ${task.scheduledTime}</div>
            <div><span class="label">志愿者:</span> ${task.volunteerName}</div>
          </div>

          <c:if test="${task.status == 'APPROVED' && not empty task.feedback}">
            <div class="card-feedback">
              评分: ${task.rating}/5 | 反馈: ${task.feedback}
            </div>
          </c:if>

          <div class="card-actions">
            <button class="btn btn-detail" onclick="viewDetail('${task.id}')">查看</button>
            <c:if test="${task.status == 'CLAIMED'}">
              <button class="btn btn-start" onclick="startTask('${task.id}')">开始执行</button>
              <button class="btn btn-cancel" onclick="cancelTask('${task.id}')">放弃</button>
            </c:if>
            <c:if test="${task.status == 'IN_PROGRESS'}">
              <button class="btn btn-submit" onclick="submitTask('${task.id}')">提交完成</button>
              <button class="btn btn-cancel" onclick="cancelTask('${task.id}')">放弃</button>
            </c:if>
            <c:if test="${task.status == 'COMPLETED'}">
              <div class="status-text waiting">等待管理员审核中...</div>
            </c:if>
            <c:if test="${task.status == 'APPROVED'}">
              <div class="status-text done">任务已完成并通过审核</div>
            </c:if>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>

  <c:if test="${empty list}">
    <div class="empty">
      <h2>暂无任务</h2>
      <p>前往<a href="${pageContext.request.contextPath}/volunteer/task/hall">任务大厅</a>认领新任务</p>
    </div>
  </c:if>
</div>

<script>
function viewDetail(id) {
  window.location.href = '${pageContext.request.contextPath}/volunteer/task/detail/' + id;
}

function startTask(id) {
  if (!confirm('确定要开始执行这个任务吗？需验证您的当前位置。')) {
    return;
  }

  // 定义发送请求的函数
  const sendRequest = (lat, lng) => {
    let url = '${pageContext.request.contextPath}/volunteer/task/start/' + id;
    let params = [];
    if (lat != null && lng != null) {
        params.push('lat=' + lat);
        params.push('lng=' + lng);
    }
    if (params.length > 0) {
        url += '?' + params.join('&');
    }

    fetch(url, {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
      if (data.success) location.reload();
    })
    .catch(err => {
        console.error(err);
        alert('网络请求失败，请检查网络');
    });
  };

  // 尝试获取定位
  if ("geolocation" in navigator) {
      const options = {
          enableHighAccuracy: true,
          timeout: 10000,
          maximumAge: 0
      };

      navigator.geolocation.getCurrentPosition(
          (position) => {
              console.log("定位成功:", position.coords.latitude, position.coords.longitude);
              sendRequest(position.coords.latitude, position.coords.longitude);
          },
          (error) => {
              let errorMsg = "";
              switch(error.code) {
                  case error.PERMISSION_DENIED:
                      errorMsg = "您拒绝了定位请求，无法进行地理围栏签到。";
                      break;
                  case error.POSITION_UNAVAILABLE:
                      errorMsg = "位置信息不可用。";
                      break;
                  case error.TIMEOUT:
                      errorMsg = "请求用户地理位置超时。";
                      break;
                  case error.UNKNOWN_ERROR:
                      errorMsg = "未知错误。";
                      break;
              }
              console.warn("定位失败: " + errorMsg);
              sendRequest(null, null);
          },
          options
      );
  } else {
      console.warn("浏览器不支持地理定位");
      sendRequest(null, null);
  }
}

function submitTask(id) {
  const note = prompt('请输入完成说明（如：已完成购物并送达）:');
  if (note) {
    fetch('${pageContext.request.contextPath}/volunteer/task/submit/' + id, {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'completionNote=' + encodeURIComponent(note)
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
      if (data.success) location.reload();
    });
  }
}

function cancelTask(id) {
  if (confirm('确定要放弃这个任务吗？')) {
    fetch('${pageContext.request.contextPath}/volunteer/task/cancel/' + id, {
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
