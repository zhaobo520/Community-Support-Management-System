<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的关爱计划 - 志愿者</title>
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
        .gov-header .nav-right {
            display: flex;
            align-items: center;
            gap: 16px;
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 24px;
        }
        .page-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        .page-title h2 {
            font-size: 24px;
            color: #333;
            margin: 0;
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
            border-left: 4px solid #D32F2F;
            text-align: center;
        }
        .stat-card h3 {
            font-size: 13px;
            color: #666;
            margin: 0 0 8px 0;
        }
        .stat-card .number {
            font-size: 32px;
            font-weight: 700;
            color: #D32F2F;
        }
        .stat-card.active { border-left-color: #10b981; }
        .stat-card.active .number { color: #10b981; }

        .filter-bar {
            background: white;
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .filter-bar label {
            font-size: 14px;
            color: #666;
        }
        .filter-bar select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .filter-bar .btn-filter {
            padding: 8px 16px;
            background: #D32F2F;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .filter-bar .btn-reset {
            padding: 8px 16px;
            background: white;
            color: #666;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }

        .plans-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 20px;
        }
        .plan-card {
            background: white;
            border-radius: 8px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border-left: 4px solid #D32F2F;
            transition: all 0.2s;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        .plan-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        }
        .plan-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
        }
        .plan-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 6px;
        }
        .plan-dates {
            font-size: 13px;
            color: #999;
        }
        .status-badge {
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
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
        .plan-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 16px;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 6px;
        }
        .info-item {
            font-size: 13px;
        }
        .info-item label {
            color: #999;
            display: block;
            margin-bottom: 2px;
        }
        .info-item .value {
            color: #333;
            font-weight: 500;
        }
        .progress-section {
            margin-top: 16px;
        }
        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }
        .progress-label {
            font-size: 13px;
            color: #666;
        }
        .progress-percent {
            font-size: 16px;
            font-weight: 700;
            color: #D32F2F;
        }
        .progress-bar {
            width: 100%;
            height: 10px;
            background: #e5e7eb;
            border-radius: 5px;
            overflow: hidden;
        }
        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #D32F2F, #B71C1C);
            border-radius: 5px;
        }
        .progress-stats {
            display: flex;
            justify-content: space-between;
            margin-top: 6px;
            font-size: 12px;
            color: #999;
        }
        .btn-action {
            display: block;
            width: 100%;
            padding: 12px;
            margin-top: 16px;
            background: #D32F2F;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-action:hover {
            background: #B71C1C;
        }
        .btn-action.secondary {
            background: white;
            color: #D32F2F;
            border: 1px solid #D32F2F;
        }
        .btn-action.secondary:hover {
            background: #FFF5F5;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .empty-state h3 {
            font-size: 18px;
            color: #666;
            margin-bottom: 8px;
        }
        .empty-state p {
            color: #999;
            font-size: 14px;
        }
        @media (max-width: 768px) {
            .stats-row { grid-template-columns: 1fr; }
            .plans-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<header class="gov-header">
    <h1>我的关爱计划</h1>
    <div class="nav-right">
        <span>志愿者：${currentUser.fullName}</span>
        <a href="${pageContext.request.contextPath}/user/volunteer/dashboard">返回仪表盘</a>
        <a href="${pageContext.request.contextPath}/user/logout">退出</a>
    </div>
</header>

<div class="container">
    <div class="page-title">
        <h2>分配给我的关爱计划</h2>
    </div>

    <div class="stats-row">
        <div class="stat-card">
            <h3>总计划数</h3>
            <div class="number">${totalPlans}</div>
        </div>
        <div class="stat-card active">
            <h3>进行中</h3>
            <div class="number">${activePlans}</div>
        </div>
        <div class="stat-card">
            <h3>待完成服务</h3>
            <div class="number">
                <c:set var="pendingServices" value="0"/>
                <c:forEach items="${planList}" var="p">
                    <c:if test="${p.status == 'ACTIVE'}">
                        <c:set var="pendingServices" value="${pendingServices + (p.totalServices - (p.completedServices != null ? p.completedServices : 0))}"/>
                    </c:if>
                </c:forEach>
                ${pendingServices}
            </div>
        </div>
    </div>

    <div class="filter-bar">
        <label>状态筛选：</label>
        <select id="statusFilter">
            <option value="">全部</option>
            <option value="ACTIVE" ${filterStatus == 'ACTIVE' ? 'selected' : ''}>进行中</option>
            <option value="COMPLETED" ${filterStatus == 'COMPLETED' ? 'selected' : ''}>已完成</option>
            <option value="CANCELLED" ${filterStatus == 'CANCELLED' ? 'selected' : ''}>已取消</option>
        </select>
        <button class="btn-filter" onclick="applyFilter()">筛选</button>
        <a href="${pageContext.request.contextPath}/volunteer/care-plan/list" class="btn-reset">重置</a>
    </div>

    <c:choose>
        <c:when test="${not empty planList}">
            <div class="plans-grid">
                <c:forEach items="${planList}" var="plan">
                    <div class="plan-card">
                        <div class="plan-header">
                            <div>
                                <div class="plan-title">${plan.planName}</div>
                                <div class="plan-dates">
                                    <fmt:formatDate value="${plan.startDate}" pattern="yyyy-MM-dd"/> ~
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

                        <div class="plan-info">
                            <div class="info-item">
                                <label>家属</label>
                                <div class="value">${not empty plan.familyName ? plan.familyName : '-'}</div>
                            </div>
                            <div class="info-item">
                                <label>关爱对象</label>
                                <div class="value">${not empty plan.elderlyName ? plan.elderlyName : '-'}</div>
                            </div>
                            <div class="info-item">
                                <label>服务类型</label>
                                <div class="value">${not empty plan.serviceType ? plan.serviceType : '综合服务'}</div>
                            </div>
                            <div class="info-item">
                                <label>服务频率</label>
                                <div class="value">${not empty plan.serviceFrequency ? plan.serviceFrequency : '按需'}</div>
                            </div>
                        </div>

                        <div class="progress-section">
                            <div class="progress-header">
                                <span class="progress-label">服务进度</span>
                                <span class="progress-percent">${plan.progressPercentage}%</span>
                            </div>
                            <div class="progress-bar">
                                <div class="progress-bar-fill" style="width: ${plan.progressPercentage}%"></div>
                            </div>
                            <div class="progress-stats">
                                <span>已完成 ${plan.completedServices != null ? plan.completedServices : 0} 次</span>
                                <span>总计 ${plan.totalServices != null ? plan.totalServices : 0} 次</span>
                            </div>
                        </div>

                        <a href="${pageContext.request.contextPath}/volunteer/care-plan/detail/${plan.id}"
                           class="btn-action secondary">查看详情</a>

                        <c:if test="${plan.status == 'ACTIVE'}">
                            <a href="${pageContext.request.contextPath}/volunteer/care-plan/submit-record/${plan.id}"
                               class="btn-action">提交服务记录</a>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <h3>暂无分配的关爱计划</h3>
                <p>管理员分配给您的关爱计划将在这里显示</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    function applyFilter() {
        var status = document.getElementById('statusFilter').value;
        var url = '${pageContext.request.contextPath}/volunteer/care-plan/list';
        if (status) {
            url += '?status=' + status;
        }
        window.location.href = url;
    }
</script>
</body>
</html>
