<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>反馈管理</title>
    <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #FAF5F0;
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
            position: relative;
        }
        .gov-header::before {
            content: '★';
            position: absolute;
            left: 24px;
            color: rgba(255,255,255,0.3);
            font-size: 20px;
        }
        .gov-header h1 {
            color: white;
            font-size: 18px;
            font-weight: 600;
            margin: 0 0 0 40px;
            letter-spacing: 2px;
        }
        .gov-header a {
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            font-size: 13px;
            padding: 8px 16px;
            border-radius: 6px;
            transition: all 0.2s;
        }
        .gov-header a:hover {
            background: rgba(255,255,255,0.15);
            color: white;
        }
        .container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 28px 24px;
        }
        .stats-bar {
            background: white;
            border-radius: 8px;
            padding: 20px 28px;
            margin-bottom: 20px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            display: flex;
            justify-content: space-around;
            align-items: center;
            border-left: 4px solid #D32F2F;
        }
        .stat-item {
            text-align: center;
            cursor: pointer;
            padding: 12px 20px;
            border-radius: 6px;
            transition: all 0.2s;
        }
        .stat-item:hover {
            background: #FFF5F5;
        }
        .stat-number {
            font-size: 32px;
            font-weight: 700;
            color: #D32F2F;
        }
        .stat-label {
            color: #666;
            font-size: 13px;
            margin-top: 4px;
        }
        .filters {
            background: white;
            border-radius: 8px;
            padding: 16px 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            border-left: 4px solid #D32F2F;
        }
        .filter-btn {
            padding: 8px 16px;
            border: 1px solid #D32F2F;
            border-radius: 6px;
            background: white;
            color: #D32F2F;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .filter-btn:hover {
            background: rgba(211, 47, 47, 0.08);
        }
        .filter-btn.active {
            background: #D32F2F;
            color: white;
        }
        .feedback-list {
            display: grid;
            gap: 16px;
        }
        .feedback-card {
            background: white;
            border-radius: 8px;
            padding: 24px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            transition: all 0.2s;
            border-left: 4px solid #D32F2F;
            border: 1px solid #eee;
        }
        .feedback-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(211, 47, 47, 0.12);
            border-color: #D32F2F;
        }
        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 14px;
            padding-bottom: 14px;
            border-bottom: 1px solid #f0f0f0;
        }
        .feedback-type {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        .type-rating { background: #FBE9E7; color: #B71C1C; }
        .type-suggestion { background: #FBE9E7; color: #B71C1C; }
        .type-complaint { background: #FFF3E0; color: #E65100; }
        .feedback-status {
            padding: 5px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-pending { background: #FFF8E1; color: #F57C00; }
        .status-processing { background: #FBE9E7; color: #B71C1C; }
        .status-resolved { background: #FBE9E7; color: #B71C1C; }
        .feedback-title {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        .feedback-content {
            font-size: 13px;
            color: #666;
            line-height: 1.7;
            margin-bottom: 14px;
        }
        .feedback-meta {
            display: flex;
            gap: 20px;
            font-size: 12px;
            color: #999;
            margin-bottom: 14px;
        }
        .meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .feedback-actions {
            display: flex;
            gap: 10px;
        }
        .btn-action {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            background: #D32F2F;
            color: white;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-action:hover {
            background: #B71C1C;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(211,47,47,0.3);
        }
        .btn-success {
            background: #D32F2F;
        }
        .btn-success:hover {
            background: #B71C1C;
            box-shadow: 0 4px 12px rgba(211, 47, 47,0.3);
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 8px;
            border-left: 4px solid #D32F2F;
        }
        @media (max-width: 768px) {
            .stats-bar { flex-direction: column; gap: 12px; }
            .filters { flex-direction: column; }
            .feedback-meta { flex-direction: column; gap: 8px; }
            .feedback-actions { flex-direction: column; }
            .gov-header { padding: 0 16px; }
            .container { padding: 20px 16px; }
        }
    </style>
</head>
<body>
<header class="gov-header">
    <h1>反馈管理</h1>
    <a href="${pageContext.request.contextPath}/user/admin/dashboard">返回首页</a>
</header>

<div class="container">
    <!-- Stats Bar -->
    <div class="stats-bar">
        <div class="stat-item" onclick="location.href='${pageContext.request.contextPath}/admin/feedback/list'">
            <div class="stat-number">${totalCount}</div>
            <div class="stat-label">总反馈数</div>
        </div>
        <div class="stat-item" onclick="location.href='${pageContext.request.contextPath}/admin/feedback/list?status=PENDING'">
            <div class="stat-number">${pendingCount}</div>
            <div class="stat-label">待处理</div>
        </div>
        <div class="stat-item" onclick="location.href='${pageContext.request.contextPath}/admin/feedback/list?status=PROCESSING'">
            <div class="stat-number">${processingCount}</div>
            <div class="stat-label">处理中</div>
        </div>
        <div class="stat-item" onclick="location.href='${pageContext.request.contextPath}/admin/feedback/list?status=RESOLVED'">
            <div class="stat-number">${resolvedCount}</div>
            <div class="stat-label">已解决</div>
        </div>
    </div>

    <!-- Filters -->
    <div class="filters">
        <button class="filter-btn ${empty currentStatus ? 'active' : ''}"
                onclick="location.href='${pageContext.request.contextPath}/admin/feedback/list'">
            全部
        </button>
        <button class="filter-btn ${currentType == 'RATING' ? 'active' : ''}"
                onclick="location.href='${pageContext.request.contextPath}/admin/feedback/list?type=RATING'">
            服务评价
        </button>
        <button class="filter-btn ${currentType == 'SUGGESTION' ? 'active' : ''}"
                onclick="location.href='${pageContext.request.contextPath}/admin/feedback/list?type=SUGGESTION'">
            建议
        </button>
        <button class="filter-btn ${currentType == 'COMPLAINT' ? 'active' : ''}"
                onclick="location.href='${pageContext.request.contextPath}/admin/feedback/list?type=COMPLAINT'">
            投诉
        </button>
    </div>

    <!-- Feedback List -->
    <c:choose>
        <c:when test="${not empty feedbacks}">
            <div class="feedback-list">
                <c:forEach items="${feedbacks}" var="feedback">
                    <div class="feedback-card">
                        <div class="feedback-header">
                            <span class="feedback-type
                                ${feedback.feedbackType == 'RATING' ? 'type-rating' :
                                  feedback.feedbackType == 'SUGGESTION' ? 'type-suggestion' : 'type-complaint'}">
                                ${feedback.feedbackType == 'RATING' ? '服务评价' :
                                  feedback.feedbackType == 'SUGGESTION' ? '建议' : '投诉'}
                            </span>
                            <span class="feedback-status
                                ${feedback.status == 'PENDING' ? 'status-pending' :
                                  feedback.status == 'PROCESSING' ? 'status-processing' : 'status-resolved'}">
                                ${feedback.status == 'PENDING' ? '待处理' :
                                  feedback.status == 'PROCESSING' ? '处理中' : '已解决'}
                            </span>
                        </div>

                        <div class="feedback-title">${feedback.title}</div>
                        <div class="feedback-content">${feedback.content}</div>

                        <div class="feedback-meta">
                            <div class="meta-item">
                                <span><fmt:formatDate value="${feedback.createdAt}" pattern="yyyy-MM-dd HH:mm"/></span>
                            </div>
                            <c:if test="${feedback.rating != null}">
                                <div class="meta-item">
                                    <span>${feedback.rating} 分</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty feedback.volunteerName}">
                                <div class="meta-item">
                                    <span>志愿者：${feedback.volunteerName}</span>
                                </div>
                            </c:if>
                        </div>

                        <div class="feedback-actions">
                            <button class="btn-action"
                                    onclick="location.href='${pageContext.request.contextPath}/admin/feedback/detail/${feedback.id}'">
                                查看详情并回复
                            </button>
                            <c:if test="${feedback.status == 'PENDING'}">
                                <button class="btn-action btn-success"
                                        onclick="updateStatus(${feedback.id}, 'PROCESSING')">
                                    标记为处理中
                                </button>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div style="font-size:24px;color:#666;margin-bottom:12px;">暂无反馈</div>
                <div style="color:#999;font-size:16px;">当前筛选条件下没有反馈记录</div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
function updateStatus(id, status) {
    if (!confirm('确定要更新状态吗？')) return;

    fetch('${pageContext.request.contextPath}/admin/feedback/updateStatus', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'id=' + id + '&status=' + status
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('状态更新成功！');
            location.reload();
        } else {
            alert('操作失败：' + data.message);
        }
    })
    .catch(error => {
        alert('操作失败：' + error);
    });
}
</script>
</body>
</html>

