<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📋 关爱计划</title>
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
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            background: white;
            border-radius: 4px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 4px solid #D32F2F;
        }

        .header h1 {
            font-size: 32px;
            color: #D32F2F;
        }

        .header-subtitle {
            color: #666;
            font-size: 14px;
            margin-top: 8px;
        }

        .btn-back {
            padding: 10px 20px;
            background: white;
            color: #D32F2F;
            border: 2px solid #D32F2F;
            border-radius: 2px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            box-shadow: none;
            transition: all 0.3s;
        }

        .btn-back:hover {
            transform: translateY(-2px);
            background: #D32F2F;
            color: white;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .stats-bar {
            background: white;
            border-radius: 4px;
            padding: 20px 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            display: flex;
            justify-content: space-around;
            align-items: center;
            border-left: 4px solid #D32F2F;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 36px;
            font-weight: bold;
            color: #D32F2F;
        }

        .stat-label {
            color: #666;
            font-size: 14px;
            margin-top: 4px;
        }

        .plans-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(450px, 1fr));
            gap: 25px;
        }

        .plan-card {
            background: white;
            border-radius: 4px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            position: relative;
            overflow: hidden;
            transition: all 0.3s;
            border-left: 4px solid #D32F2F;
            cursor: pointer;
            text-decoration: none;
            display: block;
            color: inherit;
        }

        .plan-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .plan-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: #D32F2F;
            display: none;
        }

        .plan-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .plan-title {
            font-size: 22px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }

        .plan-dates {
            font-size: 13px;
            color: #999;
        }

        .status-badge {
            padding: 6px 14px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-active {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
        }

        .status-completed {
            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            color: white;
        }

        .status-cancelled {
            background: #e5e7eb;
            color: #6b7280;
        }

        .plan-description {
            font-size: 14px;
            color: #666;
            line-height: 1.8;
            margin-bottom: 20px;
            padding: 15px;
            background: #FAF5F0;
            border-radius: 4px;
            border-left: 4px solid #D32F2F;
        }

        .plan-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-bottom: 20px;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: #666;
        }

        .info-icon {
            font-size: 18px;
        }

        .volunteer-section {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 20px;
        }

        .volunteer-header {
            font-size: 12px;
            color: #999;
            margin-bottom: 10px;
            font-weight: bold;
        }

        .volunteer-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .volunteer-avatar {
            width: 40px;
            height: 40px;
            border-radius: 4px;
            background: linear-gradient(135deg, #B71C1C, #D32F2F);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            color: white;
            font-weight: bold;
        }

        .volunteer-name {
            font-size: 14px;
            font-weight: bold;
            color: #333;
        }

        .progress-section {
            margin-top: 20px;
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .progress-label {
            font-size: 13px;
            color: #666;
            font-weight: bold;
        }

        .progress-percent {
            font-size: 18px;
            font-weight: bold;
            color: #D32F2F;
        }

        .progress-bar-bg {
            width: 100%;
            height: 12px;
            background: #e5e7eb;
            border-radius: 999px;
            overflow: hidden;
        }

        .progress-bar-fill {
            height: 100%;
            background: #D32F2F;
            border-radius: 999px;
            transition: width 0.3s ease;
        }

        .progress-stats {
            display: flex;
            justify-content: space-between;
            margin-top: 8px;
            font-size: 12px;
            color: #999;
        }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #D32F2F;
        }

        .empty-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }

        .empty-title {
            font-size: 24px;
            color: #666;
            margin-bottom: 12px;
        }

        .empty-desc {
            color: #999;
            font-size: 16px;
        }

        @media (max-width: 768px) {
            .plans-grid {
                grid-template-columns: 1fr;
            }

            .stats-bar {
                flex-direction: column;
                gap: 15px;
            }

            .plan-info {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1>关爱计划</h1>
            <p class="header-subtitle">查看为您家人定制的个性化关爱计划</p>
        </div>
        <a href="${pageContext.request.contextPath}/user/family/dashboard" class="btn-back">← 返回首页</a>
    </div>

    <!-- Stats Bar -->
    <div class="stats-bar">
        <div class="stat-item">
            <div class="stat-number">${totalPlans}</div>
            <div class="stat-label">总计划数</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">${activePlans}</div>
            <div class="stat-label">进行中</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">💝</div>
            <div class="stat-label">贴心服务</div>
        </div>
    </div>

    <!-- Plans Grid -->
    <c:choose>
        <c:when test="${not empty plans}">
            <div class="plans-grid">
                <c:forEach items="${plans}" var="plan">
                    <a href="${pageContext.request.contextPath}/user/family/care-plan/detail/${plan.id}" class="plan-card">
                        <!-- Header -->
                        <div class="plan-header">
                            <div>
                                <div class="plan-title">${plan.planName}</div>
                                <div class="plan-dates">
                                    <fmt:formatDate value="${plan.startDate}" pattern="yyyy-MM-dd"/> - 
                                    <fmt:formatDate value="${plan.endDate}" pattern="yyyy-MM-dd"/>
                                </div>
                            </div>
                            <span class="status-badge
                                ${plan.status == 'ACTIVE' ? 'status-active' :
                                  plan.status == 'COMPLETED' ? 'status-completed' : 'status-cancelled'}">
                                ${plan.status == 'ACTIVE' ? '进行中' :
                                  plan.status == 'COMPLETED' ? '已完成' : '已取消'}
                            </span>
                        </div>

                        <!-- Description -->
                        <c:if test="${not empty plan.description}">
                            <div class="plan-description">
                                ${plan.description}
                            </div>
                        </c:if>

                        <!-- Info Grid -->
                        <div class="plan-info">
                            <div class="info-item">
                                <span class="info-icon">🏥</span>
                                <span>${not empty plan.serviceType ? plan.serviceType : '综合服务'}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-icon">📅</span>
                                <span>${not empty plan.serviceFrequency ? plan.serviceFrequency : '按需服务'}</span>
                            </div>
                        </div>

                        <!-- Volunteer -->
                        <c:if test="${not empty plan.volunteerName}">
                            <div class="volunteer-section">
                                <div class="volunteer-header">负责志愿者</div>
                                <div class="volunteer-info">
                                    <div class="volunteer-avatar">
                                        ${plan.volunteerName.substring(0,1)}
                                    </div>
                                    <div class="volunteer-name">${plan.volunteerName}</div>
                                </div>
                            </div>
                        </c:if>

                        <!-- Progress -->
                        <div class="progress-section">
                            <div class="progress-header">
                                <span class="progress-label">服务进度</span>
                                <span class="progress-percent">${plan.progressPercentage}%</span>
                            </div>
                            <div class="progress-bar-bg">
                                <div class="progress-bar-fill" style="width: ${plan.progressPercentage}%"></div>
                            </div>
                            <div class="progress-stats">
                                <span>已完成 ${plan.completedServices != null ? plan.completedServices : 0} 次</span>
                                <span>总计 ${plan.totalServices != null ? plan.totalServices : 0} 次</span>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-icon">计划</div>
                <div class="empty-title">暂无关爱计划</div>
                <div class="empty-desc">您的关爱计划将在这里显示</div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
