<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>关爱计划详情 - 志愿者</title>
    <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body {
            background: #FAF5F0;
            margin: 0;
            padding: 0;
            font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            min-height: 100vh;
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
            max-width: 900px;
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
        .btn-back {
            padding: 10px 20px;
            background: white;
            color: #666;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
        }
        .btn-back:hover {
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
        .progress-card {
            background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
            border-radius: 8px;
            padding: 24px;
            color: white;
            margin-bottom: 20px;
        }
        .progress-card h3 {
            margin: 0 0 16px 0;
            font-size: 16px;
            opacity: 0.9;
        }
        .progress-main {
            display: flex;
            align-items: center;
            gap: 24px;
            margin-bottom: 16px;
        }
        .progress-percent {
            font-size: 48px;
            font-weight: 700;
        }
        .progress-detail {
            flex: 1;
        }
        .progress-bar-white {
            width: 100%;
            height: 12px;
            background: rgba(255,255,255,0.3);
            border-radius: 6px;
            overflow: hidden;
            margin-bottom: 8px;
        }
        .progress-bar-fill-white {
            height: 100%;
            background: white;
            border-radius: 6px;
        }
        .progress-text {
            font-size: 14px;
            opacity: 0.9;
        }
        .action-section {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.2);
        }
        .action-section p {
            margin: 0 0 12px 0;
            font-size: 14px;
            opacity: 0.9;
        }
        .btn-complete {
            display: inline-block;
            padding: 12px 24px;
            background: white;
            color: #D32F2F;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-complete:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        .btn-complete:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
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
            background: linear-gradient(135deg, #1976D2, #1565C0);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            font-weight: 600;
        }
        .person-avatar.elderly {
            background: linear-gradient(135deg, #D32F2F, #B71C1C);
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
        .empty-info {
            text-align: center;
            padding: 20px;
            color: #999;
            font-size: 14px;
        }
    </style>
</head>
<body>

<header class="gov-header">
    <h1>关爱计划详情</h1>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/volunteer/care-plan/list">返回列表</a>
    </div>
</header>

<div class="container">
    <c:if test="${empty plan}">
        <div style="background: #fee2e2; padding: 20px; border-radius: 8px; margin-bottom: 20px; color: #dc2626;">
            <strong>错误：</strong>计划数据未加载，请返回列表重试。
        </div>
    </c:if>

    <c:if test="${not empty plan}">
    <div class="page-header">
        <div>
            <h2>
                <c:out value="${plan.planName}" default="未命名计划"/>
                <c:choose>
                    <c:when test="${plan.status eq 'ACTIVE'}">
                        <span class="status-badge status-active">进行中</span>
                    </c:when>
                    <c:when test="${plan.status eq 'COMPLETED'}">
                        <span class="status-badge status-completed">已完成</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge status-cancelled"><c:out value="${plan.statusText}" default="未知"/></span>
                    </c:otherwise>
                </c:choose>
            </h2>
            <div class="meta">
                <fmt:formatDate value="${plan.startDate}" pattern="yyyy年MM月dd日"/> -
                <fmt:formatDate value="${plan.endDate}" pattern="yyyy年MM月dd日"/>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/volunteer/care-plan/list" class="btn-back">← 返回列表</a>
    </div>

    <!-- 服务进度卡片 -->
    <div class="progress-card">
        <h3>服务进度</h3>
        <div class="progress-main">
            <c:set var="progressPct" value="${plan.progressPercentage != null ? plan.progressPercentage : 0}"/>
            <div class="progress-percent" id="progressPercent">${progressPct}%</div>
            <div class="progress-detail">
                <div class="progress-bar-white">
                    <div class="progress-bar-fill-white" id="progressBar" style="width: ${progressPct}%"></div>
                </div>
                <div class="progress-text">
                    已完成 <span id="completedCount">${plan.completedServices != null ? plan.completedServices : 0}</span> 次服务，
                    计划总计 ${plan.totalServices != null ? plan.totalServices : 0} 次
                </div>
            </div>
        </div>

        <c:if test="${plan.status eq 'ACTIVE'}">
            <div class="action-section">
                <p>完成服务后，请提交服务记录（需上传服务照片，经管理员审核后计入进度）</p>
                <a href="${pageContext.request.contextPath}/volunteer/care-plan/submit-record/${plan.id}" class="btn-complete">
                    提交服务记录
                </a>
            </div>
        </c:if>

        <c:if test="${plan.status eq 'COMPLETED'}">
            <div class="action-section">
                <p>此计划已全部完成，感谢您的辛勤付出！</p>
            </div>
        </c:if>
    </div>

    <!-- 基本信息 -->
    <div class="detail-card">
        <h3 class="card-title">计划信息</h3>
        <div class="info-grid">
            <div class="info-item">
                <label>服务类型</label>
                <div class="value"><c:out value="${plan.serviceType}" default="综合服务"/></div>
            </div>
            <div class="info-item">
                <label>服务频率</label>
                <div class="value"><c:out value="${plan.serviceFrequency}" default="按需服务"/></div>
            </div>
            <div class="info-item">
                <label>创建时间</label>
                <div class="value"><fmt:formatDate value="${plan.createdAt}" pattern="yyyy-MM-dd HH:mm"/></div>
            </div>
            <div class="info-item">
                <label>最后更新</label>
                <div class="value"><fmt:formatDate value="${plan.updatedAt}" pattern="yyyy-MM-dd HH:mm"/></div>
            </div>
        </div>
        <c:if test="${not empty plan.description}">
            <div style="margin-top: 16px;">
                <label style="font-size: 12px; color: #999; display: block; margin-bottom: 8px;">计划描述</label>
                <div class="description-box"><c:out value="${plan.description}"/></div>
            </div>
        </c:if>
    </div>

    <!-- 家属信息 -->
    <div class="detail-card">
        <h3 class="card-title">家属信息</h3>
        <c:choose>
            <c:when test="${not empty familyUser}">
                <div class="person-card">
                    <div class="person-avatar">
                        <c:choose>
                            <c:when test="${not empty familyUser.fullName}">
                                ${fn:substring(familyUser.fullName, 0, 1)}
                            </c:when>
                            <c:otherwise>F</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="person-info">
                        <h4><c:out value="${familyUser.fullName}" default="${familyUser.username}"/></h4>
                        <p>联系电话：<c:out value="${familyUser.phone}" default="暂无"/></p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-info">暂无家属信息</div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 关爱对象信息 -->
    <div class="detail-card">
        <h3 class="card-title">关爱对象</h3>
        <c:choose>
            <c:when test="${not empty elderlyInfo}">
                <div class="person-card">
                    <div class="person-avatar elderly">
                        <c:choose>
                            <c:when test="${not empty elderlyInfo.name}">
                                ${fn:substring(elderlyInfo.name, 0, 1)}
                            </c:when>
                            <c:otherwise>E</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="person-info">
                        <h4><c:out value="${elderlyInfo.name}"/></h4>
                        <p>
                            <c:if test="${not empty elderlyInfo.age}">年龄：${elderlyInfo.age}岁</c:if>
                            <c:if test="${not empty elderlyInfo.gender}">
                                | 性别：<c:choose>
                                    <c:when test="${elderlyInfo.gender eq 'M'}">男</c:when>
                                    <c:when test="${elderlyInfo.gender eq 'F'}">女</c:when>
                                    <c:otherwise>${elderlyInfo.gender}</c:otherwise>
                                </c:choose>
                            </c:if>
                        </p>
                        <c:if test="${not empty elderlyInfo.address}">
                            <p>地址：<c:out value="${elderlyInfo.address}"/></p>
                        </c:if>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-info">暂无关爱对象信息</div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 服务记录 -->
    <div class="detail-card">
        <h3 class="card-title">我的服务记录</h3>
        <c:choose>
            <c:when test="${not empty records}">
                <c:forEach items="${records}" var="record">
                    <div style="padding: 16px; background: #f8f9fa; border-radius: 8px; margin-bottom: 12px; border-left: 3px solid #f59e0b;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                            <span style="font-weight: 600; color: #333;">
                                第${record.periodNumber}周期 第${record.serviceNumber}次服务
                            </span>
                            <span style="padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: 600; background: #fef3c7; color: #d97706;">
                                <c:choose>
                                    <c:when test="${record.auditStatus eq 'APPROVED'}">已通过</c:when>
                                    <c:when test="${record.auditStatus eq 'REJECTED'}">已拒绝</c:when>
                                    <c:otherwise>待审核</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div style="font-size: 13px; color: #666; margin-bottom: 8px;">
                            服务日期：<fmt:formatDate value="${record.serviceDate}" pattern="yyyy-MM-dd"/>
                        </div>
                        <div style="font-size: 14px; color: #333; margin-bottom: 8px;">
                            <c:out value="${record.serviceContent}"/>
                        </div>
                        <c:if test="${not empty record.servicePhotos}">
                            <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-top: 8px;">
                                <c:forEach items="${record.photoList}" var="photo">
                                    <img src="${pageContext.request.contextPath}${photo}"
                                         style="width: 80px; height: 80px; object-fit: cover; border-radius: 4px; cursor: pointer; border: 1px solid #ddd;"
                                         onclick="window.open(this.src)" alt="服务照片">
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-info">暂无服务记录，请提交服务记录</div>
            </c:otherwise>
        </c:choose>
    </div>
    </c:if>
</div>

</body>
</html>
