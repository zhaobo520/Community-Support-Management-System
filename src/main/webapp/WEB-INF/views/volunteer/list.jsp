<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>志愿者管理</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: 'Microsoft YaHei', sans-serif;
      background: #FAF5F0;
      min-height: 100vh;
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
    }
    .gov-header .actions {
      display: flex;
      gap: 20px;
    }
    .gov-header .actions a {
      color: white;
      text-decoration: none;
      font-size: 14px;
      transition: opacity 0.3s;
    }
    .gov-header .actions a:hover {
      opacity: 0.8;
    }
    .container {
      padding: 30px 40px;
    }
    .stats {
      display: grid;
      grid-template-columns: repeat(5, 1fr);
      gap: 16px;
      margin-bottom: 24px;
    }
    .stat-card {
      background: white;
      padding: 20px;
      border-radius: 4px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      cursor: pointer;
      transition: all 0.3s;
      border-left: 4px solid #D32F2F;
    }
    .stat-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.12);
    }
    .stat-card.active {
      border-left: 4px solid #B71C1C;
      background: #FFF8F5;
    }
    .stat-number {
      font-size: 32px;
      font-weight: 700;
      margin-bottom: 8px;
    }
    .stat-card.pending .stat-number { color: #f59e0b; }
    .stat-card.approved .stat-number { color: #4CAF50; }
    .stat-card.rejected .stat-number { color: #D32F2F; }
    .stat-card.suspended .stat-number { color: #666; }
    .stat-label {
      font-size: 14px;
      color: #666;
    }
    .filters {
      background: white;
      padding: 16px 20px;
      border-radius: 4px;
      margin-bottom: 20px;
      display: flex;
      gap: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }
    .filters select, .filters input {
      padding: 8px 12px;
      border: 1px solid #E0E0E0;
      border-radius: 2px;
      font-size: 14px;
    }
    .filters select:focus, .filters input:focus {
      outline: none;
      border-color: #D32F2F;
    }
    .filters button {
      padding: 8px 20px;
      background: white;
      color: #D32F2F;
      border: 1px solid #D32F2F;
      border-radius: 2px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
    }
    .filters button:hover {
      background: #D32F2F;
      color: white;
    }
    .volunteer-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
      gap: 20px;
    }
    .volunteer-card {
      background: white;
      border-radius: 4px;
      padding: 24px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      transition: all 0.3s;
      border-left: 4px solid #D32F2F;
    }
    .volunteer-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.12);
    }
    .card-header {
      display: flex;
      gap: 16px;
      margin-bottom: 16px;
    }
    .avatar {
      width: 60px;
      height: 60px;
      border-radius: 50%;
      background: #D32F2F;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 24px;
      font-weight: 700;
      flex-shrink: 0;
    }
    .card-info h3 {
      font-size: 18px;
      color: #212121;
      margin-bottom: 6px;
    }
    .card-info .phone {
      font-size: 13px;
      color: #666;
      margin-bottom: 8px;
    }
    .status-badge {
      display: inline-block;
      padding: 4px 10px;
      border-radius: 2px;
      font-size: 12px;
      font-weight: 600;
    }
    .status-badge.pending { background: rgba(245,158,11,0.15); color: #f59e0b; }
    .status-badge.approved { background: rgba(76,175,80,0.15); color: #4CAF50; }
    .status-badge.rejected { background: rgba(211,47,47,0.15); color: #D32F2F; }
    .status-badge.suspended { background: rgba(102,102,102,0.15); color: #666; }
    .skills {
      display: flex;
      gap: 6px;
      flex-wrap: wrap;
      margin-bottom: 16px;
    }
    .skill-tag {
      padding: 4px 10px;
      background: rgba(211,47,47,0.1);
      color: #D32F2F;
      border-radius: 2px;
      font-size: 12px;
      font-weight: 600;
    }
    .stats-row {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 12px;
      margin-bottom: 16px;
      padding: 12px;
      background: #FAF5F0;
      border-radius: 4px;
    }
    .stat-item {
      text-align: center;
    }
    .stat-value {
      font-size: 18px;
      font-weight: 700;
      color: #212121;
    }
    .stat-text {
      font-size: 11px;
      color: #666;
      margin-top: 2px;
    }
    .actions {
      display: flex;
      gap: 8px;
    }
    .btn {
      flex: 1;
      padding: 8px;
      border: 1px solid #D32F2F;
      border-radius: 2px;
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      text-align: center;
      background: white;
      color: #D32F2F;
      transition: all 0.3s;
      text-decoration: none;
      display: inline-block;
    }
    .btn:hover {
      background: #D32F2F;
      color: white;
    }
    .btn-approve {
      border-color: #4CAF50;
      color: #4CAF50;
    }
    .btn-approve:hover {
      background: #4CAF50;
      color: white;
    }
    .btn-reject {
      border-color: #D32F2F;
      color: #D32F2F;
    }
    .btn-reject:hover {
      background: #D32F2F;
      color: white;
    }
    .btn-suspend {
      border-color: #666;
      color: #666;
    }
    .btn-suspend:hover {
      background: #666;
      color: white;
    }
    .empty-state {
      text-align: center;
      padding: 60px 20px;
      background: white;
      border-radius: 4px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }
    .empty-state h2 {
      color: #666;
      font-size: 20px;
      margin-bottom: 12px;
    }
    .empty-state p {
      color: #999;
      font-size: 14px;
    }
  </style>
</head>
<body>
<header class="gov-header">
  <h1>志愿者管理</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/user/admin/dashboard">返回控制台</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <div class="stats">
    <div class="stat-card pending ${empty status ? 'active' : ''}" onclick="filterByStatus('')">
      <div class="stat-number">${pendingCount + approvedCount + rejectedCount + suspendedCount}</div>
      <div class="stat-label">全部志愿者</div>
    </div>
    <div class="stat-card pending ${status == 'PENDING' ? 'active' : ''}" onclick="filterByStatus('PENDING')">
      <div class="stat-number">${pendingCount}</div>
      <div class="stat-label">待审核</div>
    </div>
    <div class="stat-card approved ${status == 'APPROVED' ? 'active' : ''}" onclick="filterByStatus('APPROVED')">
      <div class="stat-number">${approvedCount}</div>
      <div class="stat-label">已认证</div>
    </div>
    <div class="stat-card rejected ${status == 'REJECTED' ? 'active' : ''}" onclick="filterByStatus('REJECTED')">
      <div class="stat-number">${rejectedCount}</div>
      <div class="stat-label">已拒绝</div>
    </div>
    <div class="stat-card suspended ${status == 'SUSPENDED' ? 'active' : ''}" onclick="filterByStatus('SUSPENDED')">
      <div class="stat-number">${suspendedCount}</div>
      <div class="stat-label">已暂停</div>
    </div>
  </div>

  <div class="filters">
    <form action="${pageContext.request.contextPath}/admin/volunteer/list" method="get" style="display:flex;gap:12px;width:100%;">
      <select name="status" onchange="this.form.submit()">
        <option value="">全部状态</option>
        <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>待审核</option>
        <option value="APPROVED" ${status == 'APPROVED' ? 'selected' : ''}>已认证</option>
        <option value="REJECTED" ${status == 'REJECTED' ? 'selected' : ''}>已拒绝</option>
        <option value="SUSPENDED" ${status == 'SUSPENDED' ? 'selected' : ''}>已暂停</option>
      </select>
      <input type="text" name="keyword" placeholder="搜索姓名、电话、技能..." value="${keyword}"/>
      <button type="submit">搜索</button>
    </form>
  </div>

  <c:if test="${empty list}">
    <div class="empty-state">
      <h2>暂无数据</h2>
      <p>
        <c:choose>
          <c:when test="${status == 'REJECTED'}">当前没有被拒绝的志愿者</c:when>
          <c:when test="${status == 'PENDING'}">当前没有待审核的志愿者</c:when>
          <c:when test="${status == 'APPROVED'}">当前没有已认证的志愿者</c:when>
          <c:when test="${status == 'SUSPENDED'}">当前没有已暂停的志愿者</c:when>
          <c:otherwise>暂无志愿者数据</c:otherwise>
        </c:choose>
      </p>
    </div>
  </c:if>

  <div class="volunteer-grid">
    <c:forEach items="${list}" var="vol">
      <div class="volunteer-card">
        <div class="card-header">
          <c:choose>
            <c:when test="${not empty vol.avatar}">
              <img src="${pageContext.request.contextPath}${vol.avatar}" class="avatar" style="object-fit: cover;" alt="">
            </c:when>
            <c:otherwise>
              <div class="avatar">${vol.fullName.substring(0,1)}</div>
            </c:otherwise>
          </c:choose>
          <div class="card-info">
            <h3>${vol.fullName}</h3>
            <div class="phone">${vol.phone}</div>
            <span class="status-badge ${vol.volunteerStatus == 'PENDING' ? 'pending' : vol.volunteerStatus == 'APPROVED' ? 'approved' : vol.volunteerStatus == 'REJECTED' ? 'rejected' : 'suspended'}">
              <c:choose>
                <c:when test="${vol.volunteerStatus == 'PENDING'}">待审核</c:when>
                <c:when test="${vol.volunteerStatus == 'APPROVED'}">已认证</c:when>
                <c:when test="${vol.volunteerStatus == 'REJECTED'}">已拒绝</c:when>
                <c:otherwise>已暂停</c:otherwise>
              </c:choose>
            </span>
          </div>
        </div>

        <c:choose>
          <c:when test="${not empty vol.skillList}">
            <div class="skills">
              <c:forEach items="${vol.skillList}" var="skill" varStatus="status">
                <c:if test="${status.index < 8}">
                  <span class="skill-tag">${skill.skill.skillName}</span>
                </c:if>
              </c:forEach>
              <c:if test="${vol.skillList.size() > 8}">
                <span class="skill-tag">+${vol.skillList.size() - 8}</span>
              </c:if>
            </div>
          </c:when>
          <c:otherwise>
            <div class="skills">
              <span class="skill-tag" style="background: #f0f0f0; color: #999;">暂无技能标签</span>
            </div>
          </c:otherwise>
        </c:choose>

        <div class="stats-row">
          <div class="stat-item">
            <div class="stat-value">${vol.serviceHours != null ? vol.serviceHours : 0}</div>
            <div class="stat-text">服务时长(h)</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">${vol.taskCount != null ? vol.taskCount : 0}</div>
            <div class="stat-text">完成任务</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">${vol.averageRating != null ? vol.averageRating : 0}</div>
            <div class="stat-text">平均评分</div>
          </div>
        </div>

        <div class="actions">
          <a href="${pageContext.request.contextPath}/admin/volunteer/detail/${vol.id}" class="btn">查看详情</a>
          <c:if test="${vol.volunteerStatus == 'PENDING'}">
            <button class="btn btn-approve" onclick="approveVolunteer(${vol.id})">通过</button>
            <button class="btn btn-reject" onclick="rejectVolunteer(${vol.id})">拒绝</button>
          </c:if>
          <c:if test="${vol.volunteerStatus == 'APPROVED'}">
            <button class="btn btn-suspend" onclick="suspendVolunteer(${vol.id})">暂停</button>
          </c:if>
          <c:if test="${vol.volunteerStatus == 'REJECTED'}">
            <button class="btn btn-approve" onclick="approveVolunteer(${vol.id})">重新通过</button>
          </c:if>
          <c:if test="${vol.volunteerStatus == 'SUSPENDED'}">
            <button class="btn btn-approve" onclick="approveVolunteer(${vol.id})">恢复服务</button>
          </c:if>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<script>
const contextPath = '${pageContext.request.contextPath}';

function filterByStatus(status) {
  window.location.href = contextPath + '/admin/volunteer/list?status=' + status;
}

function approveVolunteer(id) {
  if (confirm('确定要审核通过吗？')) {
    fetch(contextPath + '/admin/volunteer/approve/' + id, {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
      if (data.success) location.reload();
    });
  }
}

function rejectVolunteer(id) {
  if (confirm('确定要拒绝该志愿者吗？')) {
    fetch(contextPath + '/admin/volunteer/reject/' + id, {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
      if (data.success) location.reload();
    });
  }
}

function suspendVolunteer(id) {
  if (confirm('确定要暂停该志愿者的服务吗？')) {
    fetch(contextPath + '/admin/volunteer/suspend/' + id, {
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
