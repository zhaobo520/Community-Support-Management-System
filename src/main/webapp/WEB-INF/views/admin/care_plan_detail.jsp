<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>关爱计划详情 - 管理员</title>
    <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body {
            background: #FAF5F0;
            margin: 0;
            padding: 0;
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
            margin: 0;
        }
        .gov-header .nav-right a {
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 13px;
        }
        .gov-header .nav-right a:hover {
            background: rgba(255,255,255,0.15);
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 24px;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 24px;
        }
        .page-header h2 {
            font-size: 24px;
            color: #333;
            margin: 0 0 8px 0;
        }
        .page-header .meta {
            font-size: 14px;
            color: #666;
        }
        .header-actions {
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 10px 20px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            border: none;
            transition: all 0.2s;
        }
        .btn-primary {
            background: #D32F2F;
            color: white;
        }
        .btn-primary:hover {
            background: #B71C1C;
        }
        .btn-secondary {
            background: white;
            color: #666;
            border: 1px solid #ddd;
        }
        .btn-secondary:hover {
            background: #f5f5f5;
        }
        .status-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 600;
            margin-left: 12px;
        }
        .status-active {
            background: #d1fae5;
            color: #059669;
        }
        .status-completed {
            background: #e0e7ff;
            color: #4f46e5;
        }
        .status-cancelled {
            background: #f3f4f6;
            color: #6b7280;
        }
        .detail-card {
            background: white;
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .card-title {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin: 0 0 16px 0;
            padding-left: 12px;
            border-left: 3px solid #D32F2F;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
        }
        .info-item {
            padding: 12px;
            background: #f8f9fa;
            border-radius: 4px;
        }
        .info-item label {
            display: block;
            font-size: 12px;
            color: #999;
            margin-bottom: 4px;
        }
        .info-item .value {
            font-size: 15px;
            color: #333;
            font-weight: 500;
        }
        .description-box {
            padding: 16px;
            background: #f8f9fa;
            border-radius: 4px;
            border-left: 3px solid #D32F2F;
            line-height: 1.8;
            color: #333;
        }
        .progress-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
        }
        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        .progress-title {
            font-size: 14px;
            color: #666;
        }
        .progress-percent {
            font-size: 24px;
            font-weight: 700;
            color: #D32F2F;
        }
        .progress-bar {
            width: 100%;
            height: 12px;
            background: #e5e7eb;
            border-radius: 6px;
            overflow: hidden;
            margin-bottom: 12px;
        }
        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #D32F2F, #B71C1C);
            border-radius: 6px;
        }
        .progress-stats {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
            color: #666;
        }
        .person-card {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 16px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .person-avatar {
            width: 50px;
            height: 50px;
            border-radius: 8px;
            background: linear-gradient(135deg, #D32F2F, #B71C1C);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            font-weight: 600;
        }
        .person-avatar.blue {
            background: linear-gradient(135deg, #1976D2, #1565C0);
        }
        .person-avatar.green {
            background: linear-gradient(135deg, #10b981, #059669);
        }
        .person-info h4 {
            margin: 0 0 4px 0;
            font-size: 15px;
            color: #333;
        }
        .person-info p {
            margin: 0;
            font-size: 13px;
            color: #666;
        }
        .status-actions {
            display: flex;
            gap: 10px;
            margin-top: 16px;
        }
        .btn-status {
            padding: 8px 16px;
            border-radius: 4px;
            font-size: 13px;
            cursor: pointer;
            border: none;
        }
        .btn-status.active {
            background: #d1fae5;
            color: #059669;
        }
        .btn-status.completed {
            background: #e0e7ff;
            color: #4f46e5;
        }
        .btn-status.cancelled {
            background: #f3f4f6;
            color: #6b7280;
        }
        .btn-status:hover {
            opacity: 0.8;
        }
        .alert {
            padding: 12px 16px;
            border-radius: 4px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-success {
            background: #d1fae5;
            color: #059669;
        }
        .alert-error {
            background: #fee2e2;
            color: #dc2626;
        }
        .empty-info {
            text-align: center;
            padding: 20px;
            color: #999;
            font-size: 14px;
        }
        @media (max-width: 768px) {
            .info-grid { grid-template-columns: 1fr; }
            .page-header { flex-direction: column; gap: 16px; }
        }
    </style>
</head>
<body>

<header class="gov-header">
    <h1>关爱计划详情</h1>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/admin/care-plan/list">返回列表</a>
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
        <div>
            <h2>
                ${plan.planName}
                <span class="status-badge
                    ${plan.status == 'ACTIVE' ? 'status-active' :
                      plan.status == 'COMPLETED' ? 'status-completed' : 'status-cancelled'}">
                    ${plan.status == 'ACTIVE' ? '进行中' :
                      plan.status == 'COMPLETED' ? '已完成' : '已取消'}
                </span>
            </h2>
            <div class="meta">
                创建时间：<fmt:formatDate value="${plan.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                | 最后更新：<fmt:formatDate value="${plan.updatedAt}" pattern="yyyy-MM-dd HH:mm"/>
            </div>
        </div>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/admin/care-plan/edit/${plan.id}" class="btn btn-primary">编辑计划</a>
            <a href="${pageContext.request.contextPath}/admin/care-plan/list" class="btn btn-secondary">返回列表</a>
        </div>
    </div>

    <!-- 基本信息 -->
    <div class="detail-card">
        <h3 class="card-title">基本信息</h3>
        <div class="info-grid">
            <div class="info-item">
                <label>服务类型</label>
                <div class="value">${not empty plan.serviceType ? plan.serviceType : '综合服务'}</div>
            </div>
            <div class="info-item">
                <label>服务频率</label>
                <div class="value">${not empty plan.serviceFrequency ? plan.serviceFrequency : '按需服务'}</div>
            </div>
            <div class="info-item">
                <label>开始日期</label>
                <div class="value"><fmt:formatDate value="${plan.startDate}" pattern="yyyy年MM月dd日"/></div>
            </div>
            <div class="info-item">
                <label>结束日期</label>
                <div class="value"><fmt:formatDate value="${plan.endDate}" pattern="yyyy年MM月dd日"/></div>
            </div>
        </div>
        <c:if test="${not empty plan.description}">
            <div style="margin-top: 16px;">
                <label style="font-size: 12px; color: #999; display: block; margin-bottom: 8px;">计划描述</label>
                <div class="description-box">${plan.description}</div>
            </div>
        </c:if>
    </div>

    <!-- 服务进度 -->
    <div class="detail-card">
        <h3 class="card-title">服务进度</h3>
        <div class="progress-section">
            <div class="progress-header">
                <span class="progress-title">总体完成进度</span>
                <span class="progress-percent">${plan.progressPercentage}%</span>
            </div>
            <div class="progress-bar">
                <div class="progress-bar-fill" style="width: ${plan.progressPercentage}%"></div>
            </div>
            <div class="progress-stats">
                <span>已完成 ${plan.completedServices != null ? plan.completedServices : 0} 次服务</span>
                <span>计划总计 ${plan.totalServices != null ? plan.totalServices : 0} 次服务</span>
            </div>
        </div>
    </div>

    <!-- 关联家属 -->
    <div class="detail-card">
        <h3 class="card-title">关联家属</h3>
        <c:choose>
            <c:when test="${not empty familyUser}">
                <div class="person-card">
                    <c:choose>
                        <c:when test="${not empty familyUser.avatar}">
                            <img src="${pageContext.request.contextPath}${familyUser.avatar}"
                                 class="person-avatar blue" style="object-fit: cover;" alt=""
                                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                            <div class="person-avatar blue" style="display:none;">
                                ${familyUser.fullName != null && familyUser.fullName.length() > 0 ? familyUser.fullName.substring(0,1) : 'F'}
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="person-avatar blue">
                                ${familyUser.fullName != null && familyUser.fullName.length() > 0 ? familyUser.fullName.substring(0,1) : 'F'}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="person-info">
                        <h4>${familyUser.fullName != null ? familyUser.fullName : familyUser.username}</h4>
                        <p>联系电话：${not empty familyUser.phone ? familyUser.phone : '暂无'}</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-info">暂无关联家属信息</div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 关爱对象 -->
    <div class="detail-card">
        <h3 class="card-title">关爱对象</h3>
        <c:choose>
            <c:when test="${not empty elderlyInfo}">
                <div class="person-card">
                    <c:choose>
                        <c:when test="${not empty elderlyInfo.photoUrl}">
                            <img src="${pageContext.request.contextPath}${elderlyInfo.photoUrl}"
                                 class="person-avatar" style="object-fit: cover;" alt=""
                                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                            <div class="person-avatar" style="display:none;">
                                ${elderlyInfo.name != null && elderlyInfo.name.length() > 0 ? elderlyInfo.name.substring(0,1) : 'E'}
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="person-avatar">
                                ${elderlyInfo.name != null && elderlyInfo.name.length() > 0 ? elderlyInfo.name.substring(0,1) : 'E'}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="person-info">
                        <h4>${elderlyInfo.name}</h4>
                        <p>
                            <c:if test="${not empty elderlyInfo.age}">年龄：${elderlyInfo.age}岁</c:if>
                            <c:if test="${not empty elderlyInfo.gender}">
                                | 性别：<c:choose>
                                    <c:when test="${elderlyInfo.gender == 'M'}">男</c:when>
                                    <c:when test="${elderlyInfo.gender == 'F'}">女</c:when>
                                    <c:when test="${elderlyInfo.gender == 'MALE'}">男</c:when>
                                    <c:when test="${elderlyInfo.gender == 'FEMALE'}">女</c:when>
                                    <c:otherwise>${elderlyInfo.gender}</c:otherwise>
                                </c:choose>
                            </c:if>
                        </p>
                        <c:if test="${not empty elderlyInfo.address}">
                            <p>地址：${elderlyInfo.address}</p>
                        </c:if>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-info">暂无关联关爱对象</div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 负责志愿者 -->
    <div class="detail-card">
        <h3 class="card-title">负责志愿者</h3>
        <c:choose>
            <c:when test="${not empty volunteer}">
                <div class="person-card">
                    <c:choose>
                        <c:when test="${not empty volunteer.avatar}">
                            <img src="${pageContext.request.contextPath}${volunteer.avatar}"
                                 class="person-avatar green" style="object-fit: cover;" alt=""
                                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                            <div class="person-avatar green" style="display:none;">
                                ${volunteer.fullName != null && volunteer.fullName.length() > 0 ? volunteer.fullName.substring(0,1) : 'V'}
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="person-avatar green">
                                ${volunteer.fullName != null && volunteer.fullName.length() > 0 ? volunteer.fullName.substring(0,1) : 'V'}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="person-info">
                        <h4>${volunteer.fullName != null ? volunteer.fullName : volunteer.username}</h4>
                        <p>联系电话：${not empty volunteer.phone ? volunteer.phone : '暂无'}</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-info">暂未分配志愿者</div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 服务记录 -->
    <div class="detail-card">
        <h3 class="card-title">服务记录</h3>
        <c:choose>
            <c:when test="${not empty records}">
                <c:forEach items="${records}" var="record">
                    <c:set var="borderColor" value="#f59e0b"/>
                    <c:set var="bgColor" value="#fef3c7"/>
                    <c:set var="textColor" value="#d97706"/>
                    <c:set var="statusText" value="待审核"/>
                    <c:if test="${record.auditStatus == 'APPROVED'}">
                        <c:set var="borderColor" value="#10b981"/>
                        <c:set var="bgColor" value="#d1fae5"/>
                        <c:set var="textColor" value="#059669"/>
                        <c:set var="statusText" value="已通过"/>
                    </c:if>
                    <c:if test="${record.auditStatus == 'REJECTED'}">
                        <c:set var="borderColor" value="#ef4444"/>
                        <c:set var="bgColor" value="#fee2e2"/>
                        <c:set var="textColor" value="#dc2626"/>
                        <c:set var="statusText" value="已拒绝"/>
                    </c:if>
                    <div style="padding: 16px; background: #f8f9fa; border-radius: 8px; margin-bottom: 12px; border-left: 3px solid ${borderColor};">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                            <span style="font-weight: 600; color: #333;">
                                第${record.periodNumber}周期 第${record.serviceNumber}次服务
                            </span>
                            <span style="padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: 600; background: ${bgColor}; color: ${textColor};">
                                ${statusText}
                            </span>
                        </div>
                        <div style="font-size: 13px; color: #666; margin-bottom: 8px;">
                            服务日期：<fmt:formatDate value="${record.serviceDate}" pattern="yyyy-MM-dd"/>
                            <c:if test="${not empty record.serviceTimeStart}">
                                ${record.serviceTimeStart} - ${record.serviceTimeEnd}
                            </c:if>
                        </div>
                        <div style="font-size: 14px; color: #333; margin-bottom: 8px;">
                            ${record.serviceContent}
                        </div>
                        <c:if test="${not empty record.servicePhotos}">
                            <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-top: 8px;">
                                <c:forEach items="${record.photoList}" var="photo">
                                    <img src="${pageContext.request.contextPath}${photo}" style="width: 60px; height: 60px; object-fit: cover; border-radius: 4px; cursor: pointer;" onclick="window.open(this.src)" alt="服务照片">
                                </c:forEach>
                            </div>
                        </c:if>
                        <c:if test="${record.auditStatus == 'PENDING'}">
                            <div style="margin-top: 12px; display: flex; gap: 8px;">
                                <a href="${pageContext.request.contextPath}/admin/care-plan/record/${record.id}" style="padding: 6px 12px; background: #e0e7ff; color: #4f46e5; border-radius: 4px; font-size: 12px; text-decoration: none;">查看详情</a>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-info">暂无服务记录</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    // 页面无需状态管理脚本
</script>
</body>
</html>
