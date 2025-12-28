<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>关爱计划管理 - 管理员</title>
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
            letter-spacing: 2px;
        }
        .gov-header .nav-right {
            display: flex;
            align-items: center;
            gap: 20px;
            color: rgba(255,255,255,0.9);
            font-size: 13px;
        }
        .gov-header .nav-right a {
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            padding: 6px 12px;
            border-radius: 4px;
            transition: all 0.2s;
        }
        .gov-header .nav-right a:hover {
            background: rgba(255,255,255,0.15);
            color: white;
        }
        .container {
            max-width: 1400px;
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
        .btn-primary {
            padding: 10px 20px;
            background: #D32F2F;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }
        .btn-primary:hover {
            background: #B71C1C;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(211,47,47,0.3);
        }
        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 24px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border-left: 4px solid #D32F2F;
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
        .stat-card.completed { border-left-color: #6366f1; }
        .stat-card.completed .number { color: #6366f1; }
        .stat-card.cancelled { border-left-color: #9ca3af; }
        .stat-card.cancelled .number { color: #9ca3af; }

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

        .plan-table {
            width: 100%;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            overflow: hidden;
        }
        .plan-table table {
            width: 100%;
            border-collapse: collapse;
        }
        .plan-table th {
            background: #f8f9fa;
            padding: 14px 16px;
            text-align: left;
            font-size: 13px;
            color: #666;
            font-weight: 600;
            border-bottom: 2px solid #eee;
        }
        .plan-table td {
            padding: 14px 16px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
            color: #333;
        }
        .plan-table tr:hover {
            background: #fafafa;
        }
        .plan-table tr:last-child td {
            border-bottom: none;
        }
        .status-badge {
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-pending {
            background: #fef3c7;
            color: #d97706;
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
        .progress-bar {
            width: 100px;
            height: 8px;
            background: #e5e7eb;
            border-radius: 4px;
            overflow: hidden;
            display: inline-block;
            vertical-align: middle;
            margin-right: 8px;
        }
        .progress-bar-fill {
            height: 100%;
            background: #D32F2F;
            border-radius: 4px;
        }
        .action-btns {
            display: flex;
            gap: 8px;
        }
        .btn-sm {
            padding: 6px 12px;
            font-size: 12px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            border: none;
        }
        .btn-view {
            background: #e0e7ff;
            color: #4f46e5;
        }
        .btn-approve {
            background: #d1fae5;
            color: #059669;
        }
        .btn-reject {
            background: #fef3c7;
            color: #d97706;
        }
        .btn-edit {
            background: #fef3c7;
            color: #d97706;
        }
        .btn-delete {
            background: #fee2e2;
            color: #dc2626;
        }
        .btn-sm:hover {
            opacity: 0.8;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-state h3 {
            font-size: 18px;
            margin-bottom: 8px;
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
            border: 1px solid #a7f3d0;
        }
        .alert-error {
            background: #fee2e2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }
        @media (max-width: 1024px) {
            .stats-row { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 768px) {
            .stats-row { grid-template-columns: 1fr; }
            .plan-table { overflow-x: auto; }
        }
    </style>
</head>
<body>

<header class="gov-header">
    <h1>关爱计划管理</h1>
    <div class="nav-right">
        <span>管理员：${currentUser.fullName}</span>
        <a href="${pageContext.request.contextPath}/user/admin/dashboard">返回首页</a>
        <a href="${pageContext.request.contextPath}/user/logout">退出</a>
    </div>
</header>

<div class="container">
    <div class="page-title">
        <h2>关爱计划列表</h2>
        <a href="${pageContext.request.contextPath}/admin/care-plan/create" class="btn-primary">
            + 创建计划
        </a>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <div class="stats-row">
        <div class="stat-card">
            <h3>总计划数</h3>
            <div class="number">${statistics.total}</div>
        </div>
        <div class="stat-card active">
            <h3>待审核</h3>
            <div class="number">${statistics.pendingAudit}</div>
        </div>
        <div class="stat-card completed">
            <h3>已通过</h3>
            <div class="number">${statistics.active + statistics.completed}</div>
        </div>
        <div class="stat-card cancelled">
            <h3>已拒绝</h3>
            <div class="number">${statistics.cancelled}</div>
        </div>
    </div>

    <div class="filter-bar">
        <label>审核状态：</label>
        <select id="statusFilter">
            <option value="">全部</option>
            <option value="PENDING" ${filterStatus == 'PENDING' ? 'selected' : ''}>待审核</option>
            <option value="APPROVED" ${filterStatus == 'APPROVED' ? 'selected' : ''}>已通过</option>
            <option value="REJECTED" ${filterStatus == 'REJECTED' ? 'selected' : ''}>已拒绝</option>
        </select>
        <button class="btn-filter" onclick="applyFilter()">筛选</button>
        <a href="${pageContext.request.contextPath}/admin/care-plan/list" class="btn-reset">重置</a>
    </div>

    <div class="plan-table">
        <c:choose>
            <c:when test="${not empty planList}">
                <table>
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>计划名称</th>
                        <th>家属</th>
                        <th>关爱对象</th>
                        <th>负责志愿者</th>
                        <th>时间范围</th>
                        <th>进度</th>
                        <th>审核状态</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${planList}" var="plan">
                        <tr>
                            <td>${plan.id}</td>
                            <td><strong>${plan.planName}</strong></td>
                            <td>${not empty plan.familyName ? plan.familyName : '-'}</td>
                            <td>${not empty plan.elderlyName ? plan.elderlyName : '-'}</td>
                            <td>${not empty plan.volunteerName ? plan.volunteerName : '未分配'}</td>
                            <td>
                                <fmt:formatDate value="${plan.startDate}" pattern="MM-dd"/> ~
                                <fmt:formatDate value="${plan.endDate}" pattern="MM-dd"/>
                            </td>
                            <td>
                                <div class="progress-bar">
                                    <div class="progress-bar-fill" style="width: ${plan.progressPercentage}%"></div>
                                </div>
                                <span>${plan.progressPercentage}%</span>
                            </td>
                            <td>
                                <span class="status-badge
                                    ${plan.auditStatus == 'PENDING' ? 'status-pending' :
                                      plan.auditStatus == 'APPROVED' ? 'status-active' : 'status-cancelled'}">
                                    ${plan.auditStatus == 'PENDING' ? '待审核' :
                                      plan.auditStatus == 'APPROVED' ? '已通过' : '已拒绝'}
                                </span>
                            </td>
                            <td>
                                <div class="action-btns">
                                    <a href="${pageContext.request.contextPath}/admin/care-plan/detail/${plan.id}"
                                       class="btn-sm btn-view">查看</a>
                                    <c:if test="${plan.auditStatus == 'PENDING'}">
                                        <button class="btn-sm btn-approve" onclick="approvePlan(${plan.id})">通过</button>
                                        <button class="btn-sm btn-reject" onclick="rejectPlan(${plan.id})">拒绝</button>
                                    </c:if>
                                    <c:if test="${plan.auditStatus != 'APPROVED'}">
                                        <button class="btn-sm btn-delete" onclick="deletePlan(${plan.id})">删除</button>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <h3>暂无关爱计划</h3>
                    <p>点击"创建计划"按钮添加新的关爱计划</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function applyFilter() {
        var status = document.getElementById('statusFilter').value;
        var url = '${pageContext.request.contextPath}/admin/care-plan/list';
        if (status) {
            url += '?auditStatus=' + status;
        }
        window.location.href = url;
    }

    function approvePlan(id) {
        if (!confirm('确定要通过这个关爱计划的审核吗？通过后将出现在志愿者接单大厅。')) {
            return;
        }

        fetch('${pageContext.request.contextPath}/admin/care-plan/approve/' + id, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('审核通过成功');
                    window.location.reload();
                } else {
                    alert(data.message || '操作失败');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('操作失败，请重试');
            });
    }

    function rejectPlan(id) {
        var remark = prompt('请输入拒绝原因：');
        if (remark === null) {
            return;
        }

        fetch('${pageContext.request.contextPath}/admin/care-plan/reject/' + id, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'remark=' + encodeURIComponent(remark)
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('已拒绝该计划');
                    window.location.reload();
                } else {
                    alert(data.message || '操作失败');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('操作失败，请重试');
            });
    }

    function deletePlan(id) {
        if (!confirm('确定要删除这个关爱计划吗？此操作不可恢复。')) {
            return;
        }

        fetch('${pageContext.request.contextPath}/admin/care-plan/delete/' + id, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('删除成功');
                    window.location.reload();
                } else {
                    alert(data.message || '删除失败');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('操作失败，请重试');
            });
    }
</script>
</body>
</html>
