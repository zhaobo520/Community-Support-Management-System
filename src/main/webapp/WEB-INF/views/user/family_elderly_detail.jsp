<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>关爱人员详情 - 家属服务中心</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: #FAF5F0; min-height: 100vh; padding-bottom: 40px; }
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
    .gov-header .header-actions {
      display: flex;
      gap: 20px;
    }
    .gov-header .header-actions a {
      color: white;
      text-decoration: none;
      font-size: 14px;
      padding: 6px 16px;
      border-radius: 4px;
      transition: background 0.3s;
    }
    .gov-header .header-actions a:hover {
      background: rgba(255,255,255,0.2);
    }
    .container {
      max-width: 900px;
      margin: 40px auto;
      background: #fff;
      border-radius: 8px;
      padding: 40px 50px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }
    .profile-header {
      display: flex;
      align-items: center;
      gap: 24px;
      margin-bottom: 32px;
      padding-bottom: 24px;
      border-bottom: 2px solid #f1f5f9;
    }
    .avatar {
      width: 120px;
      height: 120px;
      border-radius: 12px;
      background: linear-gradient(135deg, #B71C1C, #D32F2F);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 48px;
      font-weight: 700;
      overflow: hidden;
      flex-shrink: 0;
    }
    .avatar img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .profile-info h1 {
      font-size: 28px;
      color: #1e293b;
      margin-bottom: 8px;
    }
    .profile-info p {
      font-size: 15px;
      color: #64748b;
      margin-bottom: 12px;
    }
    .status-badge {
      display: inline-block;
      padding: 6px 16px;
      border-radius: 20px;
      font-size: 14px;
      font-weight: 600;
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
    .section {
      margin-bottom: 32px;
    }
    .section-title {
      font-size: 18px;
      color: #1e293b;
      margin-bottom: 16px;
      padding-bottom: 8px;
      border-bottom: 2px solid #e2e8f0;
      font-weight: 600;
    }
    .info-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 16px;
    }
    .info-item {
      padding: 12px 16px;
      background: #f8fafc;
      border-radius: 6px;
    }
    .info-item.full {
      grid-column: 1 / -1;
    }
    .info-label {
      font-size: 13px;
      color: #64748b;
      margin-bottom: 4px;
    }
    .info-value {
      font-size: 15px;
      color: #1e293b;
      font-weight: 500;
    }
    .care-level {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 4px;
      font-size: 13px;
      font-weight: 600;
    }
    .care-urgent { background: rgba(239,68,68,0.15); color: #dc2626; }
    .care-high { background: rgba(249,115,22,0.15); color: #ea580c; }
    .care-medium { background: rgba(234,179,8,0.15); color: #ca8a04; }
    .care-low { background: rgba(16,185,129,0.15); color: #059669; }
    .photo-section {
      margin-bottom: 32px;
    }
    .photo-display {
      text-align: center;
      padding: 20px;
      background: #f8fafc;
      border-radius: 8px;
    }
    .photo-display img {
      max-width: 300px;
      max-height: 300px;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      object-fit: cover;
    }
    .photo-display .no-photo {
      width: 200px;
      height: 200px;
      margin: 0 auto;
      background: linear-gradient(135deg, #B71C1C, #D32F2F);
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 72px;
      font-weight: 700;
    }
    .photo-display p {
      margin-top: 12px;
      color: #64748b;
      font-size: 14px;
    }
    .audit-info {
      background: rgba(59,130,246,0.1);
      border-left: 4px solid #3b82f6;
      padding: 16px;
      border-radius: 4px;
      margin-bottom: 24px;
    }
    .audit-info.rejected {
      background: rgba(239,68,68,0.1);
      border-left-color: #ef4444;
    }
    .audit-info h4 {
      font-size: 15px;
      color: #1e40af;
      margin-bottom: 8px;
    }
    .audit-info.rejected h4 {
      color: #dc2626;
    }
    .audit-info p {
      font-size: 14px;
      color: #475569;
    }
    .page-actions {
      display: flex;
      gap: 12px;
      justify-content: center;
      margin-top: 32px;
      padding-top: 24px;
      border-top: 2px solid #f1f5f9;
    }
    .btn {
      padding: 12px 32px;
      border: 2px solid;
      border-radius: 6px;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      transition: all 0.3s;
    }
    .btn-back {
      background: white;
      color: #64748b;
      border-color: #e2e8f0;
    }
    .btn-back:hover {
      background: #f8fafc;
      border-color: #cbd5e1;
    }
    .btn-edit {
      background: white;
      color: #D32F2F;
      border-color: #D32F2F;
    }
    .btn-edit:hover {
      background: #D32F2F;
      color: white;
    }
    .btn-demand {
      background: #D32F2F;
      color: white;
      border-color: #D32F2F;
    }
    .btn-demand:hover {
      background: #B71C1C;
      border-color: #B71C1C;
    }
    @media (max-width: 768px) {
      .gov-header { padding: 0 16px; }
      .container { margin: 20px 16px; padding: 24px 20px; }
      .profile-header { flex-direction: column; text-align: center; }
      .info-grid { grid-template-columns: 1fr; }
      .actions { flex-direction: column; }
    }
  </style>
</head>
<body>
<header class="gov-header">
  <h1>关爱人员详情</h1>
  <div class="header-actions">
    <a href="${pageContext.request.contextPath}/user/family/elderly/list">返回列表</a>
    <a href="${pageContext.request.contextPath}/user/family/dashboard">控制台</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <div class="profile-header">
    <div class="avatar">
      <c:choose>
        <c:when test="${not empty elderlyInfo.photoUrl}">
          <c:choose>
            <c:when test="${fn:startsWith(elderlyInfo.photoUrl, pageContext.request.contextPath)}">
              <img src="${elderlyInfo.photoUrl}" alt="${elderlyInfo.name}">
            </c:when>
            <c:otherwise>
              <img src="${pageContext.request.contextPath}${elderlyInfo.photoUrl}" alt="${elderlyInfo.name}">
            </c:otherwise>
          </c:choose>
        </c:when>
        <c:otherwise>
          ${elderlyInfo.name.substring(0,1)}
        </c:otherwise>
      </c:choose>
    </div>
    <div class="profile-info">
      <h1>${elderlyInfo.name}</h1>
      <p>${elderlyInfo.age}岁 · ${elderlyInfo.gender == 'MALE' ? '男' : '女'} · ${elderlyInfo.livingAlone == 1 ? '独居' : '非独居'}</p>
      <span class="status-badge ${elderlyInfo.auditStatus == 'PENDING' ? 'status-pending' : elderlyInfo.auditStatus == 'APPROVED' ? 'status-approved' : 'status-rejected'}">
        <c:choose>
          <c:when test="${elderlyInfo.auditStatus == 'PENDING'}">待审核</c:when>
          <c:when test="${elderlyInfo.auditStatus == 'APPROVED'}">已通过</c:when>
          <c:when test="${elderlyInfo.auditStatus == 'REJECTED'}">已拒绝</c:when>
          <c:otherwise>待审核</c:otherwise>
        </c:choose>
      </span>
    </div>
  </div>

  <c:if test="${elderlyInfo.auditStatus == 'REJECTED' && not empty elderlyInfo.auditRemark}">
    <div class="audit-info rejected">
      <h4>审核未通过</h4>
      <p><strong>拒绝原因：</strong>${elderlyInfo.auditRemark}</p>
      <p style="margin-top:8px;font-size:13px;">您可以修改信息后重新提交审核。</p>
    </div>
  </c:if>

  <c:if test="${elderlyInfo.auditStatus == 'PENDING'}">
    <div class="audit-info">
      <h4>审核中</h4>
      <p>您提交的关爱人员信息正在等待管理员审核，审核通过后即可发布服务需求。</p>
    </div>
  </c:if>

  <!-- 照片展示区域 -->
  <div class="section photo-section">
    <div class="section-title">关爱对象照片</div>
    <div class="photo-display">
      <c:choose>
        <c:when test="${not empty elderlyInfo.photoUrl}">
          <c:choose>
            <c:when test="${fn:startsWith(elderlyInfo.photoUrl, pageContext.request.contextPath)}">
              <img src="${elderlyInfo.photoUrl}" alt="${elderlyInfo.name}的照片">
            </c:when>
            <c:otherwise>
              <img src="${pageContext.request.contextPath}${elderlyInfo.photoUrl}" alt="${elderlyInfo.name}的照片">
            </c:otherwise>
          </c:choose>
          <p>照片已上传</p>
        </c:when>
        <c:otherwise>
          <div class="no-photo">${elderlyInfo.name.substring(0,1)}</div>
          <p>暂未上传照片</p>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <div class="section">
    <div class="section-title">基本信息</div>
    <div class="info-grid">
      <div class="info-item">
        <div class="info-label">姓名</div>
        <div class="info-value">${elderlyInfo.name}</div>
      </div>
      <div class="info-item">
        <div class="info-label">身份证号</div>
        <div class="info-value">${not empty elderlyInfo.idCard ? elderlyInfo.idCard : '未填写'}</div>
      </div>
      <div class="info-item">
        <div class="info-label">性别</div>
        <div class="info-value">${elderlyInfo.gender == 'MALE' ? '男' : '女'}</div>
      </div>
      <div class="info-item">
        <div class="info-label">年龄</div>
        <div class="info-value">${elderlyInfo.age}岁</div>
      </div>
      <div class="info-item">
        <div class="info-label">出生日期</div>
        <div class="info-value">
          <c:choose>
            <c:when test="${not empty elderlyInfo.birthDate}">
              <fmt:formatDate value="${elderlyInfo.birthDate}" pattern="yyyy-MM-dd"/>
            </c:when>
            <c:otherwise>未填写</c:otherwise>
          </c:choose>
        </div>
      </div>
      <div class="info-item">
        <div class="info-label">联系电话</div>
        <div class="info-value">${not empty elderlyInfo.phone ? elderlyInfo.phone : '未填写'}</div>
      </div>
      <div class="info-item full">
        <div class="info-label">居住地址</div>
        <div class="info-value">${not empty elderlyInfo.address ? elderlyInfo.address : '未填写'}</div>
      </div>
    </div>
  </div>

  <div class="section">
    <div class="section-title">健康状况</div>
    <div class="info-grid">
      <div class="info-item">
        <div class="info-label">健康状况</div>
        <div class="info-value">${not empty elderlyInfo.healthStatus ? elderlyInfo.healthStatus : '未填写'}</div>
      </div>
      <div class="info-item">
        <div class="info-label">残疾等级</div>
        <div class="info-value">${not empty elderlyInfo.disabilityLevel ? elderlyInfo.disabilityLevel : '无'}</div>
      </div>
      <div class="info-item">
        <div class="info-label">是否独居</div>
        <div class="info-value">${elderlyInfo.livingAlone == 1 ? '是' : '否'}</div>
      </div>
      <div class="info-item">
        <div class="info-label">关爱等级</div>
        <div class="info-value">
          <span class="care-level ${elderlyInfo.careLevel == 'URGENT' ? 'care-urgent' : elderlyInfo.careLevel == 'HIGH' ? 'care-high' : elderlyInfo.careLevel == 'MEDIUM' ? 'care-medium' : 'care-low'}">
            <c:choose>
              <c:when test="${elderlyInfo.careLevel == 'URGENT'}">紧急</c:when>
              <c:when test="${elderlyInfo.careLevel == 'HIGH'}">高等级</c:when>
              <c:when test="${elderlyInfo.careLevel == 'MEDIUM'}">中等级</c:when>
              <c:otherwise>低等级</c:otherwise>
            </c:choose>
          </span>
        </div>
      </div>
    </div>
  </div>

  <div class="section">
    <div class="section-title">家属联系</div>
    <div class="info-grid">
      <div class="info-item">
        <div class="info-label">与关爱对象关系</div>
        <div class="info-value">${not empty elderlyInfo.familyContact ? elderlyInfo.familyContact : '未填写'}</div>
      </div>
      <div class="info-item">
        <div class="info-label">家属电话</div>
        <div class="info-value">${not empty elderlyInfo.familyPhone ? elderlyInfo.familyPhone : '未填写'}</div>
      </div>
    </div>
  </div>

  <c:if test="${not empty elderlyInfo.specialNeeds}">
    <div class="section">
      <div class="section-title">特殊需求</div>
      <div class="info-item full">
        <div class="info-value">${elderlyInfo.specialNeeds}</div>
      </div>
    </div>
  </c:if>

  <div class="page-actions">
    <a href="${pageContext.request.contextPath}/user/family/elderly/list" class="btn btn-back">返回列表</a>
    <c:if test="${elderlyInfo.auditStatus == 'REJECTED' || elderlyInfo.auditStatus == 'PENDING'}">
      <a href="${pageContext.request.contextPath}/user/family/elderly/edit/${elderlyInfo.id}" class="btn btn-edit">编辑信息</a>
    </c:if>
    <c:if test="${elderlyInfo.auditStatus == 'APPROVED'}">
      <a href="${pageContext.request.contextPath}/demand/family/create?elderlyId=${elderlyInfo.id}" class="btn btn-demand">发布需求</a>
    </c:if>
  </div>
</div>
</body>
</html>
