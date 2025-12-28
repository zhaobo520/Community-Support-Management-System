<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>关爱计划详情</title>
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
            max-width: 1000px;
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
            font-size: 28px;
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
            transition: all 0.3s;
        }

        .btn-back:hover {
            background: #D32F2F;
            color: white;
        }

        .detail-card {
            background: white;
            border-radius: 4px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #D32F2F;
        }

        .card-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-title-icon {
            width: 32px;
            height: 32px;
            background: linear-gradient(135deg, #D32F2F, #B71C1C);
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 16px;
        }

        .plan-title-section {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 25px;
        }

        .plan-name {
            font-size: 26px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .plan-dates {
            font-size: 14px;
            color: #666;
        }

        .status-badge {
            padding: 8px 18px;
            border-radius: 4px;
            font-size: 14px;
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

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 25px;
        }

        .info-item {
            background: #FAF5F0;
            padding: 20px;
            border-radius: 4px;
            border-left: 3px solid #D32F2F;
        }

        .info-label {
            font-size: 12px;
            color: #999;
            margin-bottom: 8px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .info-value {
            font-size: 16px;
            color: #333;
            font-weight: 500;
        }

        .description-box {
            background: #FAF5F0;
            padding: 20px;
            border-radius: 4px;
            border-left: 4px solid #D32F2F;
            margin-bottom: 25px;
        }

        .description-label {
            font-size: 12px;
            color: #999;
            margin-bottom: 10px;
            font-weight: bold;
        }

        .description-text {
            font-size: 15px;
            color: #333;
            line-height: 1.8;
        }

        .progress-section {
            background: #FAF5F0;
            padding: 25px;
            border-radius: 4px;
            margin-bottom: 25px;
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .progress-title {
            font-size: 16px;
            font-weight: bold;
            color: #333;
        }

        .progress-percent {
            font-size: 28px;
            font-weight: bold;
            color: #D32F2F;
        }

        .progress-bar-bg {
            width: 100%;
            height: 16px;
            background: #e5e7eb;
            border-radius: 999px;
            overflow: hidden;
            margin-bottom: 15px;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #D32F2F, #B71C1C);
            border-radius: 999px;
            transition: width 0.5s ease;
        }

        .progress-stats {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: #666;
        }

        .volunteer-card {
            display: flex;
            align-items: center;
            gap: 20px;
            background: #FAF5F0;
            padding: 20px;
            border-radius: 4px;
        }

        .volunteer-avatar {
            width: 60px;
            height: 60px;
            border-radius: 4px;
            background: linear-gradient(135deg, #B71C1C, #D32F2F);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            font-weight: bold;
        }

        .volunteer-info h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 5px;
        }

        .volunteer-info p {
            font-size: 14px;
            color: #666;
        }

        .elderly-card {
            display: flex;
            align-items: center;
            gap: 20px;
            background: #FAF5F0;
            padding: 20px;
            border-radius: 4px;
        }

        .elderly-avatar {
            width: 60px;
            height: 60px;
            border-radius: 4px;
            background: linear-gradient(135deg, #1976D2, #1565C0);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            font-weight: bold;
        }

        .elderly-info h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 5px;
        }

        .elderly-info p {
            font-size: 14px;
            color: #666;
        }

        .empty-info {
            text-align: center;
            padding: 30px;
            color: #999;
            font-size: 14px;
        }

        .timeline-section {
            margin-top: 20px;
        }

        .timeline-item {
            display: flex;
            gap: 15px;
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .timeline-item:last-child {
            border-bottom: none;
        }

        .timeline-dot {
            width: 12px;
            height: 12px;
            background: #D32F2F;
            border-radius: 50%;
            margin-top: 4px;
            flex-shrink: 0;
        }

        .timeline-content {
            flex: 1;
        }

        .timeline-date {
            font-size: 12px;
            color: #999;
            margin-bottom: 5px;
        }

        .timeline-text {
            font-size: 14px;
            color: #333;
        }

        @media (max-width: 768px) {
            .info-grid {
                grid-template-columns: 1fr;
            }

            .plan-title-section {
                flex-direction: column;
                gap: 15px;
            }

            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1>关爱计划详情</h1>
            <p class="header-subtitle">查看计划的详细信息和服务进度</p>
        </div>
        <a href="${pageContext.request.contextPath}/user/family/care-plans" class="btn-back">← 返回列表</a>
    </div>

    <!-- Plan Basic Info -->
    <div class="detail-card">
        <div class="plan-title-section">
            <div>
                <div class="plan-name">${plan.planName}</div>
                <div class="plan-dates">
                    <fmt:formatDate value="${plan.startDate}" pattern="yyyy年MM月dd日"/> -
                    <fmt:formatDate value="${plan.endDate}" pattern="yyyy年MM月dd日"/>
                </div>
            </div>
            <span class="status-badge
                ${plan.status == 'ACTIVE' ? 'status-active' :
                  plan.status == 'COMPLETED' ? 'status-completed' : 'status-cancelled'}">
                ${plan.status == 'ACTIVE' ? '进行中' :
                  plan.status == 'COMPLETED' ? '已完成' : '已取消'}
            </span>
        </div>

        <c:if test="${not empty plan.description}">
            <div class="description-box">
                <div class="description-label">计划描述</div>
                <div class="description-text">${plan.description}</div>
            </div>
        </c:if>

        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">服务类型</div>
                <div class="info-value">${not empty plan.serviceType ? plan.serviceType : '综合服务'}</div>
            </div>
            <div class="info-item">
                <div class="info-label">服务频率</div>
                <div class="info-value">${not empty plan.serviceFrequency ? plan.serviceFrequency : '按需服务'}</div>
            </div>
            <div class="info-item">
                <div class="info-label">创建时间</div>
                <div class="info-value">
                    <fmt:formatDate value="${plan.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                </div>
            </div>
            <div class="info-item">
                <div class="info-label">最后更新</div>
                <div class="info-value">
                    <fmt:formatDate value="${plan.updatedAt}" pattern="yyyy-MM-dd HH:mm"/>
                </div>
            </div>
        </div>
    </div>

    <!-- Progress Section -->
    <div class="detail-card">
        <div class="card-title">
            <div class="card-title-icon">%</div>
            服务进度
        </div>
        <div class="progress-section">
            <div class="progress-header">
                <span class="progress-title">总体完成进度</span>
                <span class="progress-percent">${plan.progressPercentage}%</span>
            </div>
            <div class="progress-bar-bg">
                <div class="progress-bar-fill" style="width: ${plan.progressPercentage}%"></div>
            </div>
            <div class="progress-stats">
                <span>已完成 ${plan.completedServices != null ? plan.completedServices : 0} 次服务</span>
                <span>计划总计 ${plan.totalServices != null ? plan.totalServices : 0} 次服务</span>
            </div>
        </div>
    </div>

    <!-- Volunteer Info -->
    <div class="detail-card">
        <div class="card-title">
            <div class="card-title-icon">V</div>
            负责志愿者
        </div>
        <c:choose>
            <c:when test="${not empty volunteer}">
                <div class="volunteer-card">
                    <div class="volunteer-avatar">
                        ${volunteer.fullName != null ? volunteer.fullName.substring(0,1) : 'V'}
                    </div>
                    <div class="volunteer-info">
                        <h3>${volunteer.fullName != null ? volunteer.fullName : volunteer.username}</h3>
                        <p>联系电话: ${not empty volunteer.phone ? volunteer.phone : '暂无'}</p>
                    </div>
                </div>
            </c:when>
            <c:when test="${not empty plan.volunteerName}">
                <div class="volunteer-card">
                    <div class="volunteer-avatar">
                        ${plan.volunteerName.substring(0,1)}
                    </div>
                    <div class="volunteer-info">
                        <h3>${plan.volunteerName}</h3>
                        <p>负责本计划的服务执行</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-info">暂未分配志愿者</div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Elderly Info -->
    <div class="detail-card">
        <div class="card-title">
            <div class="card-title-icon">E</div>
            关爱对象
        </div>
        <c:choose>
            <c:when test="${not empty elderlyInfo}">
                <div class="elderly-card">
                    <div class="elderly-avatar">
                        ${elderlyInfo.name != null ? elderlyInfo.name.substring(0,1) : 'E'}
                    </div>
                    <div class="elderly-info">
                        <h3>${elderlyInfo.name}</h3>
                        <p>
                            <c:if test="${not empty elderlyInfo.age}">年龄: ${elderlyInfo.age}岁</c:if>
                            <c:if test="${not empty elderlyInfo.gender}">
                                | 性别: ${elderlyInfo.gender == 'M' ? '男' : elderlyInfo.gender == 'F' ? '女' : elderlyInfo.gender}
                            </c:if>
                        </p>
                        <c:if test="${not empty elderlyInfo.address}">
                            <p>地址: ${elderlyInfo.address}</p>
                        </c:if>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-info">暂无关联的关爱对象信息</div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Timeline -->
    <div class="detail-card">
        <div class="card-title">
            <div class="card-title-icon">T</div>
            计划时间线
        </div>
        <div class="timeline-section">
            <div class="timeline-item">
                <div class="timeline-dot"></div>
                <div class="timeline-content">
                    <div class="timeline-date">
                        <fmt:formatDate value="${plan.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </div>
                    <div class="timeline-text">计划创建</div>
                </div>
            </div>
            <c:if test="${plan.status == 'ACTIVE'}">
                <div class="timeline-item">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <div class="timeline-date">
                            <fmt:formatDate value="${plan.startDate}" pattern="yyyy-MM-dd"/>
                        </div>
                        <div class="timeline-text">计划开始执行</div>
                    </div>
                </div>
            </c:if>
            <c:if test="${plan.completedServices != null && plan.completedServices > 0}">
                <div class="timeline-item">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <div class="timeline-date">
                            <fmt:formatDate value="${plan.updatedAt}" pattern="yyyy-MM-dd HH:mm"/>
                        </div>
                        <div class="timeline-text">已完成 ${plan.completedServices} 次服务</div>
                    </div>
                </div>
            </c:if>
            <c:if test="${plan.status == 'COMPLETED'}">
                <div class="timeline-item">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <div class="timeline-date">
                            <fmt:formatDate value="${plan.updatedAt}" pattern="yyyy-MM-dd HH:mm"/>
                        </div>
                        <div class="timeline-text">计划已完成</div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>
