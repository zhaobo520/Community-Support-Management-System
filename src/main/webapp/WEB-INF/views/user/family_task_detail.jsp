<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>服务详情 - 社区关爱协同平台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
    }
    .page-header {
      background: linear-gradient(135deg, #B71C1C 0%, #D32F2F 100%);
      padding: 20px 60px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 2px 12px rgba(0,0,0,0.15);
    }
    .page-header h1 {
      color: white;
      font-size: 22px;
      font-weight: 600;
    }
    .page-header .btn-back {
      background: white;
      color: #D32F2F;
      padding: 8px 20px;
      border-radius: 6px;
      text-decoration: none;
      font-weight: 600;
      font-size: 14px;
      transition: all 0.3s;
    }
    .page-header .btn-back:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    }
    .container {
      max-width: 900px;
      margin: 0 auto;
      padding: 30px 20px;
    }
    .card {
      background: white;
      border-radius: 8px;
      padding: 40px 50px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      border-left: 4px solid #D32F2F;
    }
    .header {
      display: flex;
      justify-content: space-between;
      align-items: start;
      margin-bottom: 32px;
      padding-bottom: 24px;
      border-bottom: 2px solid #e2e8f0;
    }
    .header-left h1 {
      font-size: 26px;
      color: #1e293b;
      margin-bottom: 12px;
    }
    .elderly-avatar {
      width: 80px;
      height: 80px;
      border-radius: 8px;
      object-fit: cover;
      box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }
    .elderly-avatar-placeholder {
      width: 80px;
      height: 80px;
      border-radius: 8px;
      background: linear-gradient(135deg, #B71C1C, #D32F2F);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
      font-size: 32px;
      font-weight: 700;
      box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }
    .tags {
      display: flex;
      gap: 8px;
      margin-bottom: 16px;
    }
    .tag {
      padding: 6px 14px;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 600;
    }
    .tag.urgent { background: rgba(239,68,68,0.15); color: #dc2626; }
    .tag.high { background: rgba(249,115,22,0.15); color: #ea580c; }
    .tag.medium { background: rgba(234,179,8,0.15); color: #ca8a04; }
    .tag.low { background: rgba(16,185,129,0.15); color: #059669; }
    .tag.status-pending { background: rgba(211,47,47,0.15); color: #D32F2F; }
    .tag.status-claimed { background: rgba(139,92,246,0.15); color: #7c3aed; }
    .tag.status-progress { background: rgba(245,158,11,0.15); color: #d97706; }
    .tag.status-completed { background: rgba(59,130,246,0.15); color: #2563eb; }
    .tag.status-approved { background: rgba(16,185,129,0.15); color: #059669; }
    .section {
      margin-bottom: 32px;
    }
    .section-title {
      font-size: 18px;
      color: #1e293b;
      margin-bottom: 16px;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 8px;
      padding-bottom: 8px;
      border-bottom: 2px solid #f1f5f9;
    }
    .section-title::before {
      content: '';
      width: 4px;
      height: 20px;
      background: #D32F2F;
      border-radius: 2px;
    }
    .info-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 16px;
    }
    .info-item {
      background: #f8fafc;
      padding: 16px;
      border-radius: 6px;
    }
    .info-item.full {
      grid-column: 1 / -1;
    }
    .info-label {
      font-size: 12px;
      color: #94a3b8;
      margin-bottom: 6px;
      font-weight: 600;
    }
    .info-value {
      font-size: 15px;
      color: #1e293b;
      font-weight: 600;
    }
    .description-box {
      background: #f8fafc;
      padding: 20px;
      border-radius: 6px;
      line-height: 1.8;
      color: #475569;
      border-left: 3px solid #D32F2F;
    }
    /* 执行照片样式 */
    .photo-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
      gap: 16px;
      margin-top: 16px;
    }
    .photo-item {
      position: relative;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      background: #f8fafc;
    }
    .photo-item img {
      width: 100%;
      height: 180px;
      object-fit: cover;
      cursor: pointer;
      transition: transform 0.3s;
    }
    .photo-item img:hover {
      transform: scale(1.05);
    }
    .photo-item video {
      width: 100%;
      height: 180px;
      object-fit: cover;
      background: #000;
    }
    .empty-photos {
      text-align: center;
      color: #94a3b8;
      padding: 40px;
      background: #f8fafc;
      border-radius: 8px;
    }
    .rating-display {
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .rating-stars {
      display: flex;
      gap: 2px;
    }
    .star {
      font-size: 20px;
      color: #f59e0b;
    }
    .star-empty {
      color: #e2e8f0;
    }
    .rating-text {
      font-size: 14px;
      color: #64748b;
    }
    .actions {
      display: flex;
      gap: 12px;
      margin-top: 32px;
      padding-top: 24px;
      border-top: 2px solid #f1f5f9;
    }
    .btn {
      flex: 1;
      padding: 14px;
      border: none;
      border-radius: 6px;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      text-align: center;
      text-decoration: none;
      transition: all 0.3s;
    }
    .btn-secondary {
      background: #f1f5f9;
      color: #475569;
    }
    .btn-secondary:hover {
      background: #e2e8f0;
    }
    @media (max-width: 768px) {
      .page-header { padding: 16px 20px; }
      .container { padding: 20px 16px; }
      .card { padding: 24px 20px; }
      .info-grid { grid-template-columns: 1fr; }
      .photo-grid { grid-template-columns: repeat(2, 1fr); }
    }
  </style>
</head>
<body>
<!-- 页面头部 -->
<header class="page-header">
  <h1>服务详情</h1>
  <a href="${pageContext.request.contextPath}/user/family/service-records" class="btn-back">← 返回服务记录</a>
</header>

<div class="container">
  <div class="card">
    <div class="header">
      <div class="header-left">
        <h1>${taskInfo.taskTitle}</h1>
        <div class="tags">
          <span class="tag ${taskInfo.priority == 'URGENT' ? 'urgent' : taskInfo.priority == 'HIGH' ? 'high' : taskInfo.priority == 'MEDIUM' ? 'medium' : 'low'}">
            ${taskInfo.priority == 'URGENT' ? '紧急' : taskInfo.priority == 'HIGH' ? '高优先级' : taskInfo.priority == 'MEDIUM' ? '中等' : '普通'}
          </span>
          <span class="tag ${taskInfo.status == 'PENDING' ? 'status-pending' : taskInfo.status == 'CLAIMED' ? 'status-claimed' : taskInfo.status == 'IN_PROGRESS' ? 'status-progress' : taskInfo.status == 'COMPLETED' ? 'status-completed' : 'status-approved'}">
            <c:choose>
              <c:when test="${taskInfo.status == 'PENDING'}">待领取</c:when>
              <c:when test="${taskInfo.status == 'CLAIMED'}">已领取</c:when>
              <c:when test="${taskInfo.status == 'IN_PROGRESS'}">服务中</c:when>
              <c:when test="${taskInfo.status == 'COMPLETED'}">已完成</c:when>
              <c:when test="${taskInfo.status == 'APPROVED'}">已完成</c:when>
              <c:otherwise>已取消</c:otherwise>
            </c:choose>
          </span>
        </div>
      </div>
      <!-- 关爱对象照片 -->
      <c:set var="displayName" value="${not empty taskInfo.elderlyName ? taskInfo.elderlyName : (not empty taskInfo.demand.contactPerson ? taskInfo.demand.contactPerson : '')}" />
      <c:choose>
        <c:when test="${not empty taskInfo.elderlyPhotoUrl}">
          <c:choose>
            <c:when test="${taskInfo.elderlyPhotoUrl.startsWith('http') || taskInfo.elderlyPhotoUrl.startsWith(pageContext.request.contextPath)}">
              <img src="${taskInfo.elderlyPhotoUrl}" alt="${displayName}" class="elderly-avatar">
            </c:when>
            <c:otherwise>
              <img src="${pageContext.request.contextPath}${taskInfo.elderlyPhotoUrl}" alt="${displayName}" class="elderly-avatar">
            </c:otherwise>
          </c:choose>
        </c:when>
        <c:otherwise>
          <div class="elderly-avatar-placeholder">
            ${not empty displayName ? displayName.substring(0,1) : '?'}
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 基本信息 -->
    <div class="section">
      <div class="section-title">基本信息</div>
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">服务对象</div>
          <div class="info-value">${not empty displayName ? displayName : '未指定'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">服务类型</div>
          <div class="info-value">
            <c:choose>
              <c:when test="${taskInfo.taskType == 'SHOPPING'}">代购服务</c:when>
              <c:when test="${taskInfo.taskType == 'MEDICAL'}">陪同就医</c:when>
              <c:when test="${taskInfo.taskType == 'CLEANING'}">清洁服务</c:when>
              <c:when test="${taskInfo.taskType == 'ACCOMPANY'}">陪伴服务</c:when>
              <c:when test="${taskInfo.taskType == 'REPAIR'}">维修服务</c:when>
              <c:otherwise>其他服务</c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="info-item">
          <div class="info-label">服务地址</div>
          <div class="info-value">${taskInfo.address}</div>
        </div>
        <div class="info-item">
          <div class="info-label">联系电话</div>
          <div class="info-value">${taskInfo.contactPhone}</div>
        </div>
        <div class="info-item">
          <div class="info-label">预约日期</div>
          <div class="info-value"><fmt:formatDate value="${taskInfo.scheduledDate}" pattern="yyyy年MM月dd日"/></div>
        </div>
        <div class="info-item">
          <div class="info-label">预约时段</div>
          <div class="info-value">${taskInfo.scheduledTime}</div>
        </div>
      </div>
    </div>

    <!-- 任务描述 -->
    <c:if test="${not empty taskInfo.description}">
      <div class="section">
        <div class="section-title">服务需求</div>
        <div class="description-box">${taskInfo.description}</div>
      </div>
    </c:if>

    <!-- 需求情景图片 -->
    <c:if test="${not empty taskInfo.demand && not empty taskInfo.demand.attachmentUrl}">
      <div class="section">
        <div class="section-title">需求图片</div>
        <div style="background:#f8fafc;padding:20px;border-radius:8px;text-align:center;">
          <img src="${pageContext.request.contextPath}${taskInfo.demand.attachmentUrl}"
               alt="需求情景图片"
               style="max-width:100%;max-height:400px;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.1);cursor:pointer;"
               onclick="window.open('${pageContext.request.contextPath}${taskInfo.demand.attachmentUrl}', '_blank')"/>
          <div style="color:#94a3b8;font-size:13px;margin-top:10px;">点击图片查看大图</div>
        </div>
      </div>
    </c:if>

    <!-- 执行信息 -->
    <c:if test="${not empty taskInfo.volunteerName}">
      <div class="section">
        <div class="section-title">服务执行</div>
        <div class="info-grid">
          <div class="info-item">
            <div class="info-label">服务志愿者</div>
            <div class="info-value">${taskInfo.volunteerName}</div>
          </div>
          <div class="info-item">
            <div class="info-label">认领时间</div>
            <div class="info-value"><fmt:formatDate value="${taskInfo.claimedTime}" pattern="yyyy-MM-dd HH:mm"/></div>
          </div>
          <c:if test="${not empty taskInfo.completedTime}">
            <div class="info-item">
              <div class="info-label">完成时间</div>
              <div class="info-value"><fmt:formatDate value="${taskInfo.completedTime}" pattern="yyyy-MM-dd HH:mm"/></div>
            </div>
          </c:if>
        </div>
        <c:if test="${not empty taskInfo.completionNote}">
          <div style="margin-top:16px;">
            <div class="info-label" style="margin-bottom:8px;">完成说明</div>
            <div class="description-box">${taskInfo.completionNote}</div>
          </div>
        </c:if>
      </div>
    </c:if>

    <!-- 执行照片/视频 -->
    <div class="section">
      <div class="section-title">服务记录（照片/视频）</div>
      <c:choose>
        <c:when test="${not empty taskInfo.executionPhotos}">
          <div class="photo-grid">
            <c:forEach items="${taskInfo.executionPhotos.split(',')}" var="media">
              <c:if test="${not empty media}">
                <div class="photo-item">
                  <c:choose>
                    <c:when test="${media.toLowerCase().endsWith('.mp4') || media.toLowerCase().endsWith('.avi') || media.toLowerCase().endsWith('.mov') || media.toLowerCase().endsWith('.webm') || media.toLowerCase().endsWith('.mkv')}">
                      <video src="${media}" controls></video>
                    </c:when>
                    <c:otherwise>
                      <img src="${media}" alt="服务照片" onclick="window.open('${media}', '_blank')">
                    </c:otherwise>
                  </c:choose>
                </div>
              </c:if>
            </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <div class="empty-photos">暂无服务照片或视频</div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 审核评价 -->
    <c:if test="${taskInfo.status == 'APPROVED' && not empty taskInfo.rating}">
      <div class="section">
        <div class="section-title">服务评价</div>
        <div class="info-grid">
          <div class="info-item">
            <div class="info-label">服务评分</div>
            <div class="info-value">
              <div class="rating-display">
                <div class="rating-stars">
                  <c:forEach begin="1" end="5" var="i">
                    <span class="star ${i <= taskInfo.rating ? '' : 'star-empty'}">★</span>
                  </c:forEach>
                </div>
                <span class="rating-text">(${taskInfo.rating}/5)</span>
              </div>
            </div>
          </div>
          <c:if test="${not empty taskInfo.feedback}">
            <div class="info-item full">
              <div class="info-label">评价反馈</div>
              <div class="info-value">${taskInfo.feedback}</div>
            </div>
          </c:if>
        </div>
      </div>
    </c:if>

    <!-- 返回按钮 -->
    <div class="actions">
      <a href="${pageContext.request.contextPath}/user/family/service-records" class="btn btn-secondary">← 返回服务记录</a>
    </div>
  </div>
</div>
</body>
</html>
