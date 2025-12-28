<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>我的关爱人员 - 家属服务中心</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: #FAF5F0; min-height: 100vh; }
    .gov-header {
      background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
      height: 60px;
      padding: 0 40px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }
    .gov-header h1 {
      color: white;
      font-size: 20px;
      font-weight: 600;
    }
    .gov-header .actions {
      display: flex;
      gap: 20px;
    }
    .gov-header .actions a {
      color: white;
      text-decoration: none;
      font-size: 14px;
      padding: 6px 16px;
      border-radius: 4px;
      transition: background 0.3s;
    }
    .gov-header .actions a:hover {
      background: rgba(255,255,255,0.2);
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 30px 20px;
    }
    .page-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24px;
    }
    .page-title {
      font-size: 24px;
      color: #1e293b;
      font-weight: 700;
    }
    .btn-add {
      background: white;
      color: #D32F2F;
      border: 2px solid #D32F2F;
      padding: 10px 24px;
      border-radius: 6px;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      transition: all 0.3s;
    }
    .btn-add:hover {
      background: #D32F2F;
      color: white;
    }
    .stats-row {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 20px;
      margin-bottom: 24px;
    }
    .stat-card {
      background: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
      text-align: center;
      border-left: 4px solid #D32F2F;
    }
    .stat-value {
      font-size: 32px;
      font-weight: 700;
      color: #D32F2F;
    }
    .stat-label {
      font-size: 14px;
      color: #64748b;
      margin-top: 4px;
    }
    .elderly-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
      gap: 20px;
    }
    .elderly-card {
      background: white;
      border-radius: 8px;
      padding: 24px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
      border: 1px solid #e2e8f0;
      transition: all 0.3s;
    }
    .elderly-card:hover {
      box-shadow: 0 4px 16px rgba(0,0,0,0.1);
      transform: translateY(-2px);
    }
    .card-header {
      display: flex;
      align-items: center;
      gap: 16px;
      margin-bottom: 16px;
    }
    .avatar {
      width: 64px;
      height: 64px;
      border-radius: 8px;
      background: linear-gradient(135deg, #B71C1C, #D32F2F);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 24px;
      font-weight: 700;
      overflow: hidden;
    }
    .avatar img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .card-info h3 {
      font-size: 18px;
      color: #1e293b;
      margin-bottom: 4px;
    }
    .card-info p {
      font-size: 13px;
      color: #64748b;
    }
    .status-badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      margin-left: auto;
    }
    .status-pending {
      background: rgba(245,158,11,0.15);
      color: #d97706;
    }
    .status-approved {
      background: rgba(16,185,129,0.15);
      color: #059669;
    }
    .status-rejected {
      background: rgba(239,68,68,0.15);
      color: #dc2626;
    }
    .card-details {
      margin-bottom: 16px;
    }
    .detail-row {
      display: flex;
      justify-content: space-between;
      padding: 8px 0;
      border-bottom: 1px solid #f1f5f9;
      font-size: 14px;
    }
    .detail-row:last-child {
      border-bottom: none;
    }
    .detail-label {
      color: #64748b;
    }
    .detail-value {
      color: #1e293b;
      font-weight: 500;
    }
    .care-level {
      display: inline-block;
      padding: 2px 8px;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 600;
    }
    .care-urgent { background: rgba(239,68,68,0.15); color: #dc2626; }
    .care-high { background: rgba(249,115,22,0.15); color: #ea580c; }
    .care-medium { background: rgba(234,179,8,0.15); color: #ca8a04; }
    .care-low { background: rgba(16,185,129,0.15); color: #059669; }
    .card-actions {
      display: flex;
      gap: 8px;
    }
    .btn-action {
      flex: 1;
      padding: 8px 12px;
      border: 1px solid #e2e8f0;
      border-radius: 6px;
      background: white;
      color: #475569;
      font-size: 13px;
      font-weight: 500;
      cursor: pointer;
      text-align: center;
      text-decoration: none;
      transition: all 0.3s;
    }
    .btn-action:hover {
      border-color: #D32F2F;
      color: #D32F2F;
    }
    .btn-action.primary {
      background: #D32F2F;
      color: white;
      border-color: #D32F2F;
    }
    .btn-action.primary:hover {
      background: #B71C1C;
    }
    .empty-state {
      text-align: center;
      padding: 60px 20px;
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    }
    .empty-icon {
      font-size: 64px;
      margin-bottom: 16px;
    }
    .empty-title {
      font-size: 20px;
      color: #1e293b;
      margin-bottom: 8px;
    }
    .empty-desc {
      color: #64748b;
      margin-bottom: 24px;
    }
    .alert {
      padding: 12px 16px;
      border-radius: 6px;
      margin-bottom: 20px;
      font-size: 14px;
    }
    .alert-success {
      background: rgba(16,185,129,0.1);
      border-left: 4px solid #10b981;
      color: #059669;
    }
    .alert-error {
      background: rgba(239,68,68,0.1);
      border-left: 4px solid #ef4444;
      color: #dc2626;
    }
    .alert-info {
      background: rgba(59,130,246,0.1);
      border-left: 4px solid #3b82f6;
      color: #2563eb;
    }
    @media (max-width: 768px) {
      .gov-header { padding: 0 16px; }
      .container { padding: 20px 16px; }
      .stats-row { grid-template-columns: 1fr; }
      .elderly-grid { grid-template-columns: 1fr; }
      .page-header { flex-direction: column; gap: 16px; align-items: flex-start; }
    }
  </style>
</head>
<body>
<header class="gov-header">
  <h1>我的关爱人员</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/user/family/dashboard">返回控制台</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-error">${error}</div>
  </c:if>

  <div class="page-header">
    <h1 class="page-title">我的关爱人员</h1>
    <a href="${pageContext.request.contextPath}/user/family/elderly/add" class="btn-add">+ 添加关爱人员</a>
  </div>

  <div class="stats-row">
    <div class="stat-card">
      <div class="stat-value">${totalCount != null ? totalCount : 0}</div>
      <div class="stat-label">总人数</div>
    </div>
    <div class="stat-card">
      <div class="stat-value">${approvedCount != null ? approvedCount : 0}</div>
      <div class="stat-label">已审核通过</div>
    </div>
    <div class="stat-card">
      <div class="stat-value">${pendingCount != null ? pendingCount : 0}</div>
      <div class="stat-label">待审核</div>
    </div>
  </div>

  <c:choose>
    <c:when test="${not empty elderlyList}">
      <div class="elderly-grid">
        <c:forEach items="${elderlyList}" var="elderly">
          <div class="elderly-card">
            <div class="card-header">
              <div class="avatar">
                <c:choose>
                  <c:when test="${not empty elderly.photoUrl}">
                    <img src="${pageContext.request.contextPath}${elderly.photoUrl}" alt="${elderly.name}">
                  </c:when>
                  <c:otherwise>
                    ${elderly.name.substring(0,1)}
                  </c:otherwise>
                </c:choose>
              </div>
              <div class="card-info">
                <h3>${elderly.name}</h3>
                <p>${elderly.age}岁 · ${elderly.gender == 'MALE' ? '男' : '女'}</p>
              </div>
              <span class="status-badge ${elderly.auditStatus == 'PENDING' ? 'status-pending' : elderly.auditStatus == 'APPROVED' ? 'status-approved' : 'status-rejected'}">
                <c:choose>
                  <c:when test="${elderly.auditStatus == 'PENDING'}">待审核</c:when>
                  <c:when test="${elderly.auditStatus == 'APPROVED'}">已通过</c:when>
                  <c:when test="${elderly.auditStatus == 'REJECTED'}">已拒绝</c:when>
                  <c:otherwise>待审核</c:otherwise>
                </c:choose>
              </span>
            </div>
            <div class="card-details">
              <div class="detail-row">
                <span class="detail-label">关爱等级</span>
                <span class="care-level ${elderly.careLevel == 'URGENT' ? 'care-urgent' : elderly.careLevel == 'HIGH' ? 'care-high' : elderly.careLevel == 'MEDIUM' ? 'care-medium' : 'care-low'}">
                  <c:choose>
                    <c:when test="${elderly.careLevel == 'URGENT'}">紧急</c:when>
                    <c:when test="${elderly.careLevel == 'HIGH'}">高等级</c:when>
                    <c:when test="${elderly.careLevel == 'MEDIUM'}">中等级</c:when>
                    <c:otherwise>低等级</c:otherwise>
                  </c:choose>
                </span>
              </div>
              <div class="detail-row">
                <span class="detail-label">联系电话</span>
                <span class="detail-value">${not empty elderly.phone ? elderly.phone : '未填写'}</span>
              </div>
              <div class="detail-row">
                <span class="detail-label">居住地址</span>
                <span class="detail-value">${not empty elderly.address ? elderly.address : '未填写'}</span>
              </div>
              <div class="detail-row">
                <span class="detail-label">是否独居</span>
                <span class="detail-value">${elderly.livingAlone == 1 ? '是' : '否'}</span>
              </div>
            </div>
            <div class="card-actions">
              <a href="${pageContext.request.contextPath}/user/family/elderly/detail/${elderly.id}" class="btn-action">查看详情</a>
              <c:if test="${elderly.auditStatus == 'APPROVED'}">
                <a href="${pageContext.request.contextPath}/demand/family/create?elderlyId=${elderly.id}" class="btn-action primary">发布需求</a>
              </c:if>
              <c:if test="${elderly.auditStatus == 'REJECTED'}">
                <a href="${pageContext.request.contextPath}/user/family/elderly/edit/${elderly.id}" class="btn-action">重新编辑</a>
              </c:if>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:when>
    <c:otherwise>
      <div class="empty-state">
        <div class="empty-icon">&#128100;</div>
        <div class="empty-title">暂无关爱人员</div>
        <div class="empty-desc">您还没有添加关爱人员，点击下方按钮添加您的家人</div>
        <a href="${pageContext.request.contextPath}/user/family/elderly/add" class="btn-add">+ 添加关爱人员</a>
      </div>
    </c:otherwise>
  </c:choose>
</div>
</body>
</html>
