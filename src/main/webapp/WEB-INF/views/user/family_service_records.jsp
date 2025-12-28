<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的需求 - 家属服务中心</title>
    <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
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

        .page-header .actions a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .page-header .actions a:hover {
            background: rgba(255,255,255,0.2);
        }

        .page-header .actions a.btn-back {
            background: white;
            color: #D32F2F;
            font-weight: 600;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px 40px;
        }

        /* 统计栏 */
        .stats-bar {
            background: white;
            border-radius: 8px;
            padding: 25px 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            display: flex;
            gap: 20px;
            align-items: center;
            border-left: 4px solid #D32F2F;
            flex-wrap: wrap;
        }

        .stat-item {
            text-align: center;
            padding: 0 20px;
            border-right: 1px solid #eee;
            min-width: 100px;
        }

        .stat-item:last-child {
            border-right: none;
        }

        .stat-number {
            font-size: 28px;
            font-weight: 700;
            color: #D32F2F;
        }

        .stat-number.pending { color: #f59e0b; }
        .stat-number.approved { color: #3b82f6; }
        .stat-number.progress { color: #8b5cf6; }
        .stat-number.completed { color: #10b981; }
        .stat-number.rejected { color: #ef4444; }

        .stat-label {
            color: #666;
            font-size: 13px;
            margin-top: 6px;
        }

        /* 需求卡片网格 */
        .demand-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 20px;
        }

        .demand-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            transition: all 0.3s;
            border: 1px solid #eee;
            position: relative;
        }

        .demand-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
            border-color: #D32F2F;
        }

        /* 状态条 */
        .status-bar {
            height: 4px;
            width: 100%;
        }
        .status-bar.pending { background: linear-gradient(90deg, #f59e0b, #fbbf24); }
        .status-bar.approved { background: linear-gradient(90deg, #3b82f6, #60a5fa); }
        .status-bar.claimed { background: linear-gradient(90deg, #8b5cf6, #a78bfa); }
        .status-bar.in-progress { background: linear-gradient(90deg, #8b5cf6, #a78bfa); }
        .status-bar.completed { background: linear-gradient(90deg, #10b981, #34d399); }
        .status-bar.rejected { background: linear-gradient(90deg, #ef4444, #f87171); }

        .card-content {
            padding: 20px;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
        }

        .demand-title {
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 6px;
        }

        .demand-date {
            font-size: 12px;
            color: #94a3b8;
        }

        /* 状态标签 */
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
        }

        .status-badge.pending {
            background: rgba(245, 158, 11, 0.15);
            color: #d97706;
        }
        .status-badge.approved {
            background: rgba(59, 130, 246, 0.15);
            color: #2563eb;
        }
        .status-badge.claimed {
            background: rgba(139, 92, 246, 0.15);
            color: #7c3aed;
        }
        .status-badge.in-progress {
            background: rgba(139, 92, 246, 0.15);
            color: #7c3aed;
        }
        .status-badge.completed {
            background: rgba(16, 185, 129, 0.15);
            color: #059669;
        }
        .status-badge.rejected {
            background: rgba(239, 68, 68, 0.15);
            color: #dc2626;
        }

        /* 进度时间线 */
        .progress-timeline {
            background: #f8fafc;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 16px;
        }

        .timeline-title {
            font-size: 12px;
            color: #64748b;
            margin-bottom: 12px;
            font-weight: 600;
        }

        .timeline-steps {
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
        }

        .timeline-steps::before {
            content: '';
            position: absolute;
            top: 12px;
            left: 12px;
            right: 12px;
            height: 2px;
            background: #e2e8f0;
            z-index: 0;
        }

        .timeline-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 1;
        }

        .step-dot {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: white;
            margin-bottom: 6px;
        }

        .step-dot.active {
            background: #D32F2F;
        }

        .step-dot.completed {
            background: #10b981;
        }

        .step-label {
            font-size: 10px;
            color: #94a3b8;
            text-align: center;
            max-width: 60px;
        }

        .step-label.active {
            color: #D32F2F;
            font-weight: 600;
        }

        /* 需求详情 */
        .demand-info {
            margin-bottom: 16px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #f1f5f9;
            font-size: 13px;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            color: #64748b;
        }

        .info-value {
            color: #1e293b;
            font-weight: 500;
        }

        /* 志愿者信息 */
        .volunteer-info {
            background: #f0fdf4;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .volunteer-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #10b981, #059669);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 16px;
        }

        .volunteer-details {
            flex: 1;
        }

        .volunteer-name {
            font-size: 14px;
            font-weight: 600;
            color: #1e293b;
        }

        .volunteer-status {
            font-size: 12px;
            color: #059669;
        }

        /* 拒绝原因 */
        .reject-reason {
            background: #fef2f2;
            border-left: 3px solid #ef4444;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 16px;
        }

        .reject-reason .label {
            font-size: 12px;
            color: #dc2626;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .reject-reason .content {
            font-size: 13px;
            color: #7f1d1d;
        }

        /* 操作按钮 */
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
            text-decoration: none;
        }

        .btn:hover {
            transform: translateY(-1px);
        }

        .btn-primary {
            background: #D32F2F;
            color: white;
        }

        .btn-primary:hover {
            background: #B71C1C;
        }

        .btn-secondary {
            background: rgba(59,130,246,0.1);
            color: #2563eb;
            border: 1px solid rgba(59,130,246,0.2);
        }

        .btn-secondary:hover {
            background: rgba(59,130,246,0.2);
        }

        /* 空状态 */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            grid-column: 1 / -1;
        }

        .empty-icon {
            font-size: 64px;
            margin-bottom: 20px;
            color: #D32F2F;
        }

        .empty-title {
            font-size: 20px;
            color: #64748b;
            margin-bottom: 12px;
            font-weight: 600;
        }

        .empty-desc {
            color: #94a3b8;
            font-size: 14px;
            margin-bottom: 24px;
        }

        @media (max-width: 1200px) {
            .demand-grid { grid-template-columns: repeat(2, 1fr); }
            .container { padding: 25px 30px; }
        }

        @media (max-width: 768px) {
            .demand-grid { grid-template-columns: 1fr; }
            .container { padding: 20px; }
            .page-header { padding: 16px 20px; }
            .stats-bar { flex-direction: column; gap: 15px; }
            .stat-item { border-right: none; border-bottom: 1px solid #eee; padding-bottom: 12px; width: 100%; }
            .stat-item:last-child { border-bottom: none; padding-bottom: 0; }
        }
    </style>
</head>
<body>
<!-- 页面头部 -->
<header class="page-header">
    <h1>我的需求</h1>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/user/family/dashboard" class="btn-back">← 返回首页</a>
    </div>
</header>

<div class="container">
    <!-- 统计栏 -->
    <div class="stats-bar">
        <div class="stat-item">
            <div class="stat-number">${totalDemands}</div>
            <div class="stat-label">总需求数</div>
        </div>
        <div class="stat-item">
            <div class="stat-number pending">${pendingCount}</div>
            <div class="stat-label">待审核</div>
        </div>
        <div class="stat-item">
            <div class="stat-number approved">${approvedCount}</div>
            <div class="stat-label">待领取</div>
        </div>
        <div class="stat-item">
            <div class="stat-number progress">${inProgressCount}</div>
            <div class="stat-label">进行中</div>
        </div>
        <div class="stat-item">
            <div class="stat-number completed">${completedCount}</div>
            <div class="stat-label">已完成</div>
        </div>
        <c:if test="${rejectedCount > 0}">
            <div class="stat-item">
                <div class="stat-number rejected">${rejectedCount}</div>
                <div class="stat-label">已拒绝</div>
            </div>
        </c:if>
    </div>

    <!-- 需求卡片网格 -->
    <div class="demand-grid">
        <c:choose>
            <c:when test="${not empty demands}">
                <c:forEach items="${demands}" var="demand">
                    <c:set var="task" value="${demandTaskMap[demand.id]}" />
                    <c:set var="statusClass" value="pending" />
                    <c:set var="statusText" value="待审核" />
                    <c:set var="currentStep" value="1" />

                    <%-- 优先根据任务状态判断，如果有任务说明需求已通过审核 --%>
                    <c:choose>
                        <%-- 如果有关联任务，根据任务状态判断 --%>
                        <c:when test="${task != null}">
                            <c:choose>
                                <c:when test="${task.status == 'COMPLETED' || task.status == 'APPROVED'}">
                                    <c:set var="statusClass" value="completed" />
                                    <c:set var="statusText" value="已完成" />
                                    <c:set var="currentStep" value="5" />
                                </c:when>
                                <c:when test="${task.status == 'IN_PROGRESS'}">
                                    <c:set var="statusClass" value="in-progress" />
                                    <c:set var="statusText" value="服务中" />
                                    <c:set var="currentStep" value="4" />
                                </c:when>
                                <c:when test="${task.status == 'CLAIMED'}">
                                    <c:set var="statusClass" value="claimed" />
                                    <c:set var="statusText" value="已领取" />
                                    <c:set var="currentStep" value="3" />
                                </c:when>
                                <c:otherwise>
                                    <%-- 任务状态为PENDING，等待志愿者领取 --%>
                                    <c:set var="statusClass" value="approved" />
                                    <c:set var="statusText" value="待领取" />
                                    <c:set var="currentStep" value="2" />
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <%-- 没有任务，根据需求状态判断 --%>
                        <c:when test="${demand.status == 'REJECTED'}">
                            <c:set var="statusClass" value="rejected" />
                            <c:set var="statusText" value="已拒绝" />
                            <c:set var="currentStep" value="0" />
                        </c:when>
                        <c:when test="${demand.status == 'APPROVED'}">
                            <c:set var="statusClass" value="approved" />
                            <c:set var="statusText" value="已通过" />
                            <c:set var="currentStep" value="2" />
                        </c:when>
                        <c:when test="${demand.status == 'COMPLETED'}">
                            <c:set var="statusClass" value="completed" />
                            <c:set var="statusText" value="已完成" />
                            <c:set var="currentStep" value="5" />
                        </c:when>
                        <c:otherwise>
                            <%-- PENDING 或其他状态 --%>
                            <c:set var="statusClass" value="pending" />
                            <c:set var="statusText" value="待审核" />
                            <c:set var="currentStep" value="1" />
                        </c:otherwise>
                    </c:choose>

                    <div class="demand-card">
                        <div class="status-bar ${statusClass}"></div>
                        <div class="card-content">
                            <div class="card-header">
                                <div>
                                    <div class="demand-title">
                                        ${not empty demand.title ? demand.title : '服务需求'}
                                    </div>
                                    <div class="demand-date">
                                        <fmt:formatDate value="${demand.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                    </div>
                                </div>
                                <span class="status-badge ${statusClass}">${statusText}</span>
                            </div>

                            <%-- 进度时间线 --%>
                            <c:if test="${demand.status != 'REJECTED'}">
                                <div class="progress-timeline">
                                    <div class="timeline-title">服务进度</div>
                                    <div class="timeline-steps">
                                        <div class="timeline-step">
                                            <div class="step-dot ${currentStep >= 1 ? 'completed' : ''}">✓</div>
                                            <div class="step-label ${currentStep == 1 ? 'active' : ''}">提交</div>
                                        </div>
                                        <div class="timeline-step">
                                            <div class="step-dot ${currentStep >= 2 ? 'completed' : currentStep == 1 ? 'active' : ''}">
                                                ${currentStep >= 2 ? '✓' : '2'}
                                            </div>
                                            <div class="step-label ${currentStep == 2 ? 'active' : ''}">审核</div>
                                        </div>
                                        <div class="timeline-step">
                                            <div class="step-dot ${currentStep >= 3 ? 'completed' : currentStep == 2 ? 'active' : ''}">
                                                ${currentStep >= 3 ? '✓' : '3'}
                                            </div>
                                            <div class="step-label ${currentStep == 3 ? 'active' : ''}">领取</div>
                                        </div>
                                        <div class="timeline-step">
                                            <div class="step-dot ${currentStep >= 4 ? 'completed' : currentStep == 3 ? 'active' : ''}">
                                                ${currentStep >= 4 ? '✓' : '4'}
                                            </div>
                                            <div class="step-label ${currentStep == 4 ? 'active' : ''}">服务</div>
                                        </div>
                                        <div class="timeline-step">
                                            <div class="step-dot ${currentStep >= 5 ? 'completed' : currentStep == 4 ? 'active' : ''}">
                                                ${currentStep >= 5 ? '✓' : '5'}
                                            </div>
                                            <div class="step-label ${currentStep == 5 ? 'active' : ''}">完成</div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <%-- 拒绝原因 --%>
                            <c:if test="${demand.status == 'REJECTED' && not empty demand.reviewComment}">
                                <div class="reject-reason">
                                    <div class="label">拒绝原因</div>
                                    <div class="content">${demand.reviewComment}</div>
                                </div>
                            </c:if>

                            <%-- 志愿者信息 --%>
                            <c:if test="${task != null && task.volunteerId != null}">
                                <div class="volunteer-info">
                                    <c:choose>
                                        <c:when test="${not empty task.volunteerAvatar}">
                                            <img src="${pageContext.request.contextPath}${task.volunteerAvatar}" class="volunteer-avatar" style="object-fit: cover;" alt="">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="volunteer-avatar">
                                                ${not empty task.volunteerName ? task.volunteerName.substring(0,1) : '志'}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="volunteer-details">
                                        <div class="volunteer-name">${not empty task.volunteerName ? task.volunteerName : '志愿者'}</div>
                                        <div class="volunteer-status">
                                            <c:choose>
                                                <c:when test="${task.status == 'CLAIMED'}">已领取任务，准备服务</c:when>
                                                <c:when test="${task.status == 'IN_PROGRESS'}">正在为您服务</c:when>
                                                <c:when test="${task.status == 'COMPLETED' || task.status == 'APPROVED'}">服务已完成</c:when>
                                                <c:otherwise>已分配</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <%-- 需求详情 --%>
                            <div class="demand-info">
                                <div class="info-row">
                                    <span class="info-label">需求类型</span>
                                    <span class="info-value">
                                        <c:choose>
                                            <c:when test="${demand.demandType == 'SHOPPING'}">代购服务</c:when>
                                            <c:when test="${demand.demandType == 'MEDICAL'}">医疗陪护</c:when>
                                            <c:when test="${demand.demandType == 'CLEANING'}">清洁服务</c:when>
                                            <c:when test="${demand.demandType == 'ACCOMPANY'}">陪伴服务</c:when>
                                            <c:when test="${demand.demandType == 'REPAIR'}">维修服务</c:when>
                                            <c:otherwise>${not empty demand.demandType ? demand.demandType : '其他'}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">紧急程度</span>
                                    <span class="info-value">
                                        <c:choose>
                                            <c:when test="${demand.urgency == 'URGENT'}">紧急</c:when>
                                            <c:when test="${demand.urgency == 'HIGH'}">较急</c:when>
                                            <c:when test="${demand.urgency == 'NORMAL'}">一般</c:when>
                                            <c:otherwise>${not empty demand.urgency ? demand.urgency : '一般'}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <c:if test="${not empty demand.serviceAddress}">
                                    <div class="info-row">
                                        <span class="info-label">服务地址</span>
                                        <span class="info-value">${demand.serviceAddress}</span>
                                    </div>
                                </c:if>
                            </div>

                            <%-- 操作按钮 --%>
                            <div class="card-actions">
                                <a href="${pageContext.request.contextPath}/demand/family/detail/${demand.id}" class="btn btn-secondary">查看详情</a>
                                <c:if test="${demand.status == 'REJECTED'}">
                                    <a href="${pageContext.request.contextPath}/demand/family/edit/${demand.id}" class="btn btn-primary">重新提交</a>
                                </c:if>
                                <c:if test="${task != null && task.id != null}">
                                    <a href="${pageContext.request.contextPath}/user/family/task/detail/${task.id}" class="btn btn-primary">查看任务</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-icon">📋</div>
                    <div class="empty-title">暂无服务需求</div>
                    <div class="empty-desc">您还没有发布任何服务需求，点击下方按钮发布您的第一个需求</div>
                    <a href="${pageContext.request.contextPath}/demand/family/create" class="btn btn-primary" style="display:inline-block;padding:12px 32px;">发布需求</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
