<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的关爱计划</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #FAF5F0;
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 4px;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid #D32F2F;
        }
        h1 {
            color: #D32F2F;
            margin-bottom: 10px;
            font-size: 28px;
        }
        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .back-btn, .create-btn {
            display: inline-block;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 2px;
            font-size: 14px;
        }
        .back-btn {
            background: white;
            color: #D32F2F;
            border: 2px solid #D32F2F;
        }
        .create-btn {
            background: #D32F2F;
            color: white;
            border: 2px solid #D32F2F;
        }
        .create-btn:hover {
            background: #B71C1C;
        }
        .stats-bar {
            display: flex;
            gap: 20px;
            margin: 20px 0;
            padding: 20px;
            background: #FFF5F5;
            border-radius: 4px;
            border-left: 4px solid #D32F2F;
        }
        .stat-item {
            text-align: center;
        }
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #D32F2F;
        }
        .stat-label {
            font-size: 12px;
            color: #666;
        }
        .message {
            padding: 15px;
            margin: 15px 0;
            border-radius: 4px;
        }
        .message.success {
            background: #FBE9E7;
            color: #B71C1C;
            border-left: 4px solid #D32F2F;
        }
        .message.error {
            background: #FFEBEE;
            color: #C62828;
            border-left: 4px solid #F44336;
        }
        .plan-list {
            margin-top: 20px;
        }
        .plan-card {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s;
        }
        .plan-card:hover {
            border-color: #D32F2F;
            box-shadow: 0 4px 12px rgba(211,47,47,0.15);
        }
        .plan-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        .plan-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }
        .plan-status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 2px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-pending { background: #FFF3E0; color: #E65100; }
        .status-approved { background: #FBE9E7; color: #B71C1C; }
        .status-rejected { background: #FFEBEE; color: #C62828; }
        .status-active { background: #FBE9E7; color: #B71C1C; }
        .status-completed { background: #E0E0E0; color: #424242; }
        .status-cancelled { background: #FFEBEE; color: #C62828; }
        .status-unclaimed { background: #FFF8E1; color: #F57F17; }
        .status-claimed { background: #FBE9E7; color: #B71C1C; }
        .plan-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 10px;
            margin-bottom: 15px;
        }
        .info-item {
            font-size: 14px;
            color: #666;
        }
        .info-item strong {
            color: #333;
        }
        .progress-bar {
            height: 8px;
            background: #e0e0e0;
            border-radius: 4px;
            overflow: hidden;
            margin: 10px 0;
        }
        .progress-fill {
            height: 100%;
            background: #D32F2F;
            transition: width 0.3s;
        }
        .progress-text {
            font-size: 12px;
            color: #666;
            text-align: right;
        }
        .plan-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e0e0e0;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 2px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: #D32F2F;
            color: white;
        }
        .btn-secondary {
            background: white;
            color: #D32F2F;
            border: 1px solid #D32F2F;
        }
        .btn-danger {
            background: #F44336;
            color: white;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        .empty-state h3 {
            margin-bottom: 10px;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-actions">
            <div>
                <a href="${pageContext.request.contextPath}/user/family/dashboard" class="back-btn">返回仪表盘</a>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/family/care-plan/create" class="create-btn">+ 发布关爱计划</a>
            </div>
        </div>

        <h1>我的关爱计划</h1>

        <div class="stats-bar">
            <div class="stat-item">
                <div class="stat-value">${totalCount}</div>
                <div class="stat-label">全部计划</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">${activeCount}</div>
                <div class="stat-label">进行中</div>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="message success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>

        <div class="plan-list">
            <c:choose>
                <c:when test="${empty plans}">
                    <div class="empty-state">
                        <h3>暂无关爱计划</h3>
                        <p>点击右上角"发布关爱计划"按钮创建您的第一个关爱计划</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${plans}" var="plan">
                        <div class="plan-card">
                            <div class="plan-header">
                                <div class="plan-title">${plan.planName}</div>
                                <div>
                                    <span class="plan-status status-${plan.auditStatus.toLowerCase()}">${plan.auditStatusText}</span>
                                    <c:if test="${plan.auditStatus == 'APPROVED'}">
                                        <span class="plan-status status-${plan.claimStatus.toLowerCase()}">${plan.claimStatusText}</span>
                                    </c:if>
                                </div>
                            </div>
                            <div class="plan-info">
                                <div class="info-item"><strong>关爱对象：</strong>${plan.elderlyName}</div>
                                <div class="info-item"><strong>服务类型：</strong>${plan.serviceType}</div>
                                <div class="info-item"><strong>服务频率：</strong>${plan.serviceFrequency}</div>
                                <div class="info-item">
                                    <strong>时间：</strong>
                                    <fmt:formatDate value="${plan.startDate}" pattern="yyyy-MM-dd"/> 至
                                    <fmt:formatDate value="${plan.endDate}" pattern="yyyy-MM-dd"/>
                                </div>
                                <c:if test="${not empty plan.volunteerName}">
                                    <div class="info-item"><strong>志愿者：</strong>${plan.volunteerName}</div>
                                </c:if>
                            </div>
                            <c:if test="${plan.auditStatus == 'APPROVED' && plan.claimStatus == 'CLAIMED'}">
                                <div class="progress-bar">
                                    <div class="progress-fill" style="width: ${plan.progressPercentage}%"></div>
                                </div>
                                <div class="progress-text">
                                    服务进度：${plan.approvedServices}/${plan.totalServices} 次 (${plan.progressPercentage}%)
                                </div>
                            </c:if>
                            <div class="plan-actions">
                                <a href="${pageContext.request.contextPath}/family/care-plan/detail/${plan.id}" class="btn btn-primary">查看详情</a>
                                <c:if test="${plan.auditStatus == 'PENDING'}">
                                    <a href="${pageContext.request.contextPath}/family/care-plan/edit/${plan.id}" class="btn btn-secondary">编辑</a>
                                    <form action="${pageContext.request.contextPath}/family/care-plan/delete/${plan.id}" method="post" style="display:inline;" onsubmit="return confirm('确定要删除此计划吗？');">
                                        <button type="submit" class="btn btn-danger">删除</button>
                                    </form>
                                </c:if>
                                <c:if test="${plan.auditStatus == 'APPROVED' && plan.claimStatus == 'UNCLAIMED'}">
                                    <form action="${pageContext.request.contextPath}/family/care-plan/cancel/${plan.id}" method="post" style="display:inline;" onsubmit="return confirm('确定要取消此计划吗？');">
                                        <button type="submit" class="btn btn-danger">取消计划</button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>

