<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>志愿者详情</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: 'Microsoft YaHei', sans-serif;
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
      max-width: 1000px;
      margin: 30px auto;
      padding: 0 20px;
    }
    .card {
      background: white;
      border-radius: 4px;
      padding: 40px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      border-left: 4px solid #D32F2F;
    }
    .profile-header {
      display: flex;
      gap: 24px;
      padding-bottom: 24px;
      border-bottom: 2px solid #E0E0E0;
      margin-bottom: 24px;
    }
    .avatar-large {
      width: 100px;
      height: 100px;
      border-radius: 50%;
      background: #D32F2F;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 40px;
      font-weight: 700;
      flex-shrink: 0;
    }
    .profile-info h1 {
      font-size: 28px;
      color: #212121;
      margin-bottom: 8px;
    }
    .info-row {
      font-size: 14px;
      color: #666;
      margin-bottom: 6px;
    }
    .status-badge {
      display: inline-block;
      padding: 6px 14px;
      border-radius: 2px;
      font-size: 13px;
      font-weight: 600;
      margin-top: 10px;
    }
    .status-badge.pending { background: rgba(245,158,11,0.15); color: #f59e0b; }
    .status-badge.approved { background: rgba(76,175,80,0.15); color: #4CAF50; }
    .status-badge.rejected { background: rgba(211,47,47,0.15); color: #D32F2F; }
    .status-badge.suspended { background: rgba(102,102,102,0.15); color: #666; }
    .section {
      margin-bottom: 28px;
    }
    .section-title {
      font-size: 18px;
      color: #D32F2F;
      font-weight: 700;
      margin-bottom: 16px;
      padding-bottom: 8px;
      border-bottom: 2px solid #FAF5F0;
    }
    .info-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 16px;
    }
    .info-item {
      background: #FAF5F0;
      padding: 14px;
      border-radius: 4px;
    }
    .info-item.full {
      grid-column: 1 / -1;
    }
    .info-label {
      font-size: 13px;
      color: #666;
      margin-bottom: 6px;
    }
    .info-value {
      font-size: 15px;
      color: #212121;
      font-weight: 600;
    }
    .skills-list {
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
    }
    .skill-tag {
      padding: 6px 12px;
      background: rgba(211,47,47,0.1);
      color: #D32F2F;
      border-radius: 2px;
      font-size: 13px;
      font-weight: 600;
    }
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 16px;
    }
    .stat-box {
      background: #FAF5F0;
      padding: 20px;
      border-radius: 4px;
      text-align: center;
      border-left: 3px solid #D32F2F;
    }
    .stat-number {
      font-size: 32px;
      font-weight: 700;
      color: #D32F2F;
      margin-bottom: 8px;
    }
    .stat-label {
      font-size: 14px;
      color: #666;
    }
    .actions {
      display: flex;
      gap: 12px;
      margin-top: 28px;
    }
    .btn {
      flex: 1;
      padding: 12px;
      border: 1px solid #D32F2F;
      border-radius: 2px;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      text-align: center;
      background: white;
      color: #D32F2F;
      transition: all 0.3s;
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
    .btn-secondary {
      border-color: #999;
      color: #666;
    }
    .btn-secondary:hover {
      background: #999;
      color: white;
    }
  </style>
</head>
<body>
<header class="gov-header">
  <h1>志愿者详情</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/admin/volunteer/list">返回列表</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <div class="card">
    <div class="profile-header">
      <c:choose>
        <c:when test="${not empty volunteer.avatar}">
          <img src="${pageContext.request.contextPath}${volunteer.avatar}" class="avatar-large" style="object-fit: cover;" alt="">
        </c:when>
        <c:otherwise>
          <div class="avatar-large">${volunteer.fullName.substring(0,1)}</div>
        </c:otherwise>
      </c:choose>
      <div class="profile-info">
        <h1>${volunteer.fullName}</h1>
        <div class="info-row">${volunteer.phone}</div>
        <div class="info-row">${volunteer.email != null ? volunteer.email : '未填写'}</div>
        <div class="info-row">${volunteer.username}</div>
        <span class="status-badge ${volunteer.volunteerStatus == 'PENDING' ? 'pending' : volunteer.volunteerStatus == 'APPROVED' ? 'approved' : volunteer.volunteerStatus == 'REJECTED' ? 'rejected' : 'suspended'}">
          <c:choose>
            <c:when test="${volunteer.volunteerStatus == 'PENDING'}">待审核</c:when>
            <c:when test="${volunteer.volunteerStatus == 'APPROVED'}">已认证</c:when>
            <c:when test="${volunteer.volunteerStatus == 'REJECTED'}">已拒绝</c:when>
            <c:otherwise>已暂停</c:otherwise>
          </c:choose>
        </span>
      </div>
    </div>

    <div class="section">
      <div class="section-title">服务统计</div>
      <div class="stats-grid">
        <div class="stat-box">
          <div class="stat-number">${volunteer.serviceHours != null ? volunteer.serviceHours : 0}</div>
          <div class="stat-label">服务时长（小时）</div>
        </div>
        <div class="stat-box">
          <div class="stat-number">${volunteer.taskCount != null ? volunteer.taskCount : 0}</div>
          <div class="stat-label">完成任务</div>
        </div>
        <div class="stat-box">
          <div class="stat-number">${volunteer.averageRating != null ? volunteer.averageRating : 0}</div>
          <div class="stat-label">平均评分</div>
        </div>
      </div>
    </div>

    <div class="section">
      <div class="section-title">个人信息</div>
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">性别</div>
          <div class="info-value">${volunteer.gender == 'MALE' ? '男' : volunteer.gender == 'FEMALE' ? '女' : '未填写'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">年龄</div>
          <div class="info-value">${volunteer.age != null ? volunteer.age : '未填写'} 岁</div>
        </div>
        <div class="info-item">
          <div class="info-label">身份证号</div>
          <div class="info-value">${volunteer.idCard != null ? volunteer.idCard : '未填写'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">出生日期</div>
          <div class="info-value">
            <c:if test="${not empty volunteer.birthDate}">
              <fmt:formatDate value="${volunteer.birthDate}" pattern="yyyy-MM-dd"/>
            </c:if>
            <c:if test="${empty volunteer.birthDate}">未填写</c:if>
          </div>
        </div>
        <div class="info-item full">
          <div class="info-label">居住地址</div>
          <div class="info-value">${volunteer.address != null ? volunteer.address : '未填写'}</div>
        </div>
      </div>
    </div>

    <div class="section">
      <div class="section-title">紧急联系人</div>
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">联系人姓名</div>
          <div class="info-value">${volunteer.emergencyContact != null ? volunteer.emergencyContact : '未填写'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">联系电话</div>
          <div class="info-value">${volunteer.emergencyPhone != null ? volunteer.emergencyPhone : '未填写'}</div>
        </div>
      </div>
    </div>

    <div class="section">
      <div class="section-title">服务信息</div>
      <div class="info-item" style="margin-bottom:16px;">
        <div class="info-label">技能标签</div>
        <div class="skills-list">
          <c:choose>
            <c:when test="${not empty volunteer.skillList}">
              <c:forEach items="${volunteer.skillList}" var="skill">
                <span class="skill-tag">${skill.skill.skillName}</span>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <span style="color:#999;">暂无技能标签</span>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">服务区域</div>
          <div class="info-value">${volunteer.serviceArea != null ? volunteer.serviceArea : '未填写'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">可服务时间</div>
          <div class="info-value">${volunteer.availableTime != null ? volunteer.availableTime : '未填写'}</div>
        </div>
      </div>
    </div>

    <c:if test="${not empty volunteer.introduction}">
      <div class="section">
        <div class="section-title">个人简介</div>
        <div class="info-item">
          <div class="info-value" style="line-height:1.8;font-weight:400;">${volunteer.introduction}</div>
        </div>
      </div>
    </c:if>

    <c:if test="${volunteer.volunteerStatus == 'APPROVED' && not empty volunteer.approveTime}">
      <div class="section">
        <div class="section-title">审核信息</div>
        <div class="info-grid">
          <div class="info-item">
            <div class="info-label">审核时间</div>
            <div class="info-value"><fmt:formatDate value="${volunteer.approveTime}" pattern="yyyy-MM-dd HH:mm"/></div>
          </div>
        </div>
      </div>
    </c:if>

    <div class="actions">
      <c:if test="${volunteer.volunteerStatus == 'PENDING'}">
        <button class="btn btn-approve" onclick="approveVolunteer()">审核通过</button>
        <button class="btn btn-reject" onclick="rejectVolunteer()">拒绝申请</button>
      </c:if>
      <c:if test="${volunteer.volunteerStatus == 'APPROVED'}">
        <button class="btn btn-suspend" onclick="suspendVolunteer()">暂停服务</button>
      </c:if>
      <button class="btn btn-secondary" onclick="history.back()">返回</button>
    </div>
  </div>
</div>

<script>
const volunteerId = ${volunteer.id};
const contextPath = '${pageContext.request.contextPath}';

function approveVolunteer() {
  if (confirm('确定要审核通过吗？')) {
    fetch(contextPath + '/admin/volunteer/approve/' + volunteerId, {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
      if (data.success) location.reload();
    });
  }
}

function rejectVolunteer() {
  if (confirm('确定要拒绝该志愿者吗？')) {
    fetch(contextPath + '/admin/volunteer/reject/' + volunteerId, {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
      if (data.success) history.back();
    });
  }
}

function suspendVolunteer() {
  if (confirm('确定要暂停该志愿者的服务吗？')) {
    fetch(contextPath + '/admin/volunteer/suspend/' + volunteerId, {
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
