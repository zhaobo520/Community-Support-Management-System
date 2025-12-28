<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>关爱对象详情</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
      margin: 0;
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
      margin: 0;
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
      padding: 6px 16px;
      border-radius: 2px;
    }
    .gov-header .actions a:hover {
      background: rgba(255,255,255,0.2);
    }
    .container {
      max-width: 900px;
      margin: 40px auto;
      padding: 0 20px;
    }
    .back-link {
      display: inline-block;
      margin-bottom: 20px;
      color: #D32F2F;
      text-decoration: none;
      font-weight: 600;
      font-size: 14px;
    }
    .profile-card {
      background: #fff;
      border-radius: 4px;
      padding: 40px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      margin-bottom: 24px;
      border: 1px solid #E0E0E0;
    }
    .profile-header {
      display: flex;
      align-items: center;
      gap: 24px;
      margin-bottom: 32px;
      padding-bottom: 24px;
      border-bottom: 3px solid #D32F2F;
    }
    .avatar-large {
      width: 100px;
      height: 100px;
      border-radius: 4px;
      background: linear-gradient(135deg, #B71C1C, #D32F2F);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
      font-size: 42px;
      font-weight: 700;
      flex-shrink: 0;
      box-shadow: 0 2px 6px rgba(183, 28, 28, 0.3);
      overflow: hidden;
    }
    .avatar-large img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .photo-section {
      background: #FAFAFA;
      padding: 24px;
      border-radius: 4px;
      border: 1px solid #E0E0E0;
      margin-bottom: 24px;
    }
    .photo-container {
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .elderly-photo {
      max-width: 300px;
      max-height: 300px;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
      border: 3px solid #fff;
    }
    .profile-info h1 {
      font-size: 32px;
      color: #212121;
      margin-bottom: 8px;
    }
    .profile-meta {
      display: flex;
      gap: 16px;
      align-items: center;
      margin-bottom: 12px;
    }
    .meta-item {
      font-size: 14px;
      color: #666;
      padding: 4px 12px;
      background: #F5F5F5;
      border-radius: 2px;
    }
    .tags {
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
    }
    .tag {
      padding: 6px 14px;
      border-radius: 2px;
      font-size: 13px;
      font-weight: 600;
      border: 1px solid;
    }
    .tag.urgent { background: rgba(183,28,28,0.1); color: #B71C1C; border-color: rgba(183,28,28,0.3); }
    .tag.high { background: rgba(211,47,47,0.1); color: #D32F2F; border-color: rgba(211,47,47,0.3); }
    .tag.medium { background: rgba(255,82,82,0.1); color: #FF5252; border-color: rgba(255,82,82,0.3); }
    .tag.low { background: rgba(76,175,80,0.1); color: #4CAF50; border-color: rgba(76,175,80,0.3); }
    .tag.alone { background: rgba(211,47,47,0.1); color: #D32F2F; border-color: rgba(211,47,47,0.3); }
    .info-sections {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 24px;
    }
    .info-section {
      background: #FAFAFA;
      padding: 24px;
      border-radius: 4px;
      border: 1px solid #E0E0E0;
    }
    .info-section.full {
      grid-column: 1 / -1;
    }
    .section-title {
      font-size: 16px;
      font-weight: 700;
      color: #212121;
      margin-bottom: 16px;
      display: flex;
      align-items: center;
      gap: 8px;
      padding-bottom: 8px;
      border-bottom: 2px solid #E0E0E0;
    }
    .info-item {
      display: flex;
      justify-content: space-between;
      padding: 10px 0;
      border-bottom: 1px solid #E0E0E0;
    }
    .info-item:last-child {
      border-bottom: none;
    }
    .info-label {
      color: #666;
      font-size: 14px;
    }
    .info-value {
      color: #212121;
      font-size: 14px;
      font-weight: 600;
      text-align: right;
      max-width: 60%;
    }
    .special-needs {
      background: rgba(255,193,7,0.1);
      border-left: 4px solid #FFC107;
      padding: 16px 20px;
      border-radius: 4px;
      color: #5D4037;
      line-height: 1.6;
    }
    .actions {
      display: flex;
      gap: 12px;
      margin-top: 32px;
    }
    .btn {
      flex: 1;
      padding: 12px;
      border: 1px solid;
      border-radius: 2px;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      text-align: center;
      text-decoration: none;
      display: inline-block;
      transition: all 0.3s;
    }
    .btn-edit {
      background: white;
      color: #4CAF50;
      border-color: #4CAF50;
    }
    .btn-edit:hover {
      background: #4CAF50;
      color: white;
    }
    .btn-back {
      background: white;
      color: #666;
      border-color: #E0E0E0;
    }
    .btn-back:hover {
      background: #F5F5F5;
    }
  </style>
</head>
<body>
<header class="gov-header">
  <h1>关爱对象详情</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/admin/elderly/list">返回列表</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <div class="profile-card">
    <div class="profile-header">
      <div class="avatar-large">
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
        <div class="profile-meta">
          <span class="meta-item">${elderlyInfo.age}岁</span>
          <span class="meta-item">${elderlyInfo.gender == 'MALE' ? '男' : '女'}</span>
          <span class="meta-item">ID: ${elderlyInfo.id}</span>
        </div>
        <div class="tags">
          <span class="tag ${elderlyInfo.careLevel == 'URGENT' ? 'urgent' : elderlyInfo.careLevel == 'HIGH' ? 'high' : elderlyInfo.careLevel == 'MEDIUM' ? 'medium' : 'low'}">
            ${elderlyInfo.careLevel == 'URGENT' ? '紧急关爱' : elderlyInfo.careLevel == 'HIGH' ? '高等级' : elderlyInfo.careLevel == 'MEDIUM' ? '中等级' : '低等级'}
          </span>
          <c:if test="${elderlyInfo.livingAlone == 1}">
            <span class="tag alone">独居关爱对象</span>
          </c:if>
        </div>
      </div>
    </div>

    <!-- 关爱对象照片展示区域 -->
    <div class="photo-section">
      <div class="section-title">关爱对象照片</div>
      <div class="photo-container">
        <c:choose>
          <c:when test="${not empty elderlyInfo.photoUrl}">
            <c:choose>
              <c:when test="${fn:startsWith(elderlyInfo.photoUrl, pageContext.request.contextPath)}">
                <img src="${elderlyInfo.photoUrl}" alt="${elderlyInfo.name}的照片" class="elderly-photo">
              </c:when>
              <c:otherwise>
                <img src="${pageContext.request.contextPath}${elderlyInfo.photoUrl}" alt="${elderlyInfo.name}的照片" class="elderly-photo">
              </c:otherwise>
            </c:choose>
          </c:when>
          <c:otherwise>
            <div class="avatar-large" style="width:200px;height:200px;font-size:72px;">
              ${elderlyInfo.name.substring(0,1)}
            </div>
            <p style="margin-top:12px;color:#666;font-size:14px;">暂未上传照片</p>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <div class="info-sections">
      <div class="info-section">
        <div class="section-title">联系方式</div>
        <div class="info-item">
          <span class="info-label">联系电话</span>
          <span class="info-value">${elderlyInfo.phone}</span>
        </div>
        <div class="info-item">
          <span class="info-label">身份证号</span>
          <span class="info-value">${elderlyInfo.idCard}</span>
        </div>
        <div class="info-item">
          <span class="info-label">出生日期</span>
          <span class="info-value"><fmt:formatDate value="${elderlyInfo.birthDate}" pattern="yyyy-MM-dd"/></span>
        </div>
      </div>

      <div class="info-section">
        <div class="section-title">居住信息</div>
        <div class="info-item">
          <span class="info-label">居住地址</span>
          <span class="info-value">${elderlyInfo.address}</span>
        </div>
        <div class="info-item">
          <span class="info-label">居住状态</span>
          <span class="info-value">${elderlyInfo.livingAlone == 1 ? '独居' : '非独居'}</span>
        </div>
      </div>

      <div class="info-section">
        <div class="section-title">健康状况</div>
        <div class="info-item">
          <span class="info-label">健康情况</span>
          <span class="info-value">${not empty elderlyInfo.healthStatus ? elderlyInfo.healthStatus : '暂无记录'}</span>
        </div>
        <div class="info-item">
          <span class="info-label">残疾等级</span>
          <span class="info-value">${not empty elderlyInfo.disabilityLevel ? elderlyInfo.disabilityLevel : '无'}</span>
        </div>
      </div>

      <div class="info-section">
        <div class="section-title">家属信息</div>
        <div class="info-item">
          <span class="info-label">家属姓名</span>
          <span class="info-value">${not empty elderlyInfo.familyContact ? elderlyInfo.familyContact : '暂无'}</span>
        </div>
        <div class="info-item">
          <span class="info-label">家属电话</span>
          <span class="info-value">${not empty elderlyInfo.familyPhone ? elderlyInfo.familyPhone : '暂无'}</span>
        </div>
      </div>

      <c:if test="${not empty elderlyInfo.specialNeeds}">
        <div class="info-section full">
          <div class="section-title">特殊需求</div>
          <div class="special-needs">
            ${elderlyInfo.specialNeeds}
          </div>
        </div>
      </c:if>

      <div class="info-section full">
        <div class="section-title">记录信息</div>
        <div class="info-item">
          <span class="info-label">录入时间</span>
          <span class="info-value"><fmt:formatDate value="${elderlyInfo.createdTime}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
        </div>
        <c:if test="${not empty elderlyInfo.updatedTime}">
          <div class="info-item">
            <span class="info-label">更新时间</span>
            <span class="info-value"><fmt:formatDate value="${elderlyInfo.updatedTime}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
          </div>
        </c:if>
      </div>
    </div>

    <div class="actions">
      <a href="${pageContext.request.contextPath}/admin/elderly/list" class="btn btn-back">返回列表</a>
      <c:if test="${currentUser.roleType == 'STAFF'}">
        <a href="${pageContext.request.contextPath}/admin/elderly/edit/${elderlyInfo.id}" class="btn btn-edit">编辑信息</a>
      </c:if>
    </div>
  </div>
</div>
</body>
</html>
