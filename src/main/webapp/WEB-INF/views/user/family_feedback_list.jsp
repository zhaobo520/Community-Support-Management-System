<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>💬 我的反馈</title>
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
            max-width: 1200px;
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
        }

        .header h1 {
            font-size: 32px;
            background: linear-gradient(135deg, #B71C1C, #D32F2F); -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .header-subtitle {
            color: #666;
            font-size: 14px;
            margin-top: 8px;
        }

        .header-actions {
            display: flex;
            gap: 15px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 2px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }

        .btn-primary { background: linear-gradient(135deg, #B71C1C, #D32F2F);
            color: white;
        }

        .btn-secondary {
            background: white;
            color: #D32F2F;
            border: 2px solid #D32F2F;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
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
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 36px;
            font-weight: bold;
            background: linear-gradient(135deg, #B71C1C, #D32F2F); -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .stat-label {
            color: #666;
            font-size: 14px;
            margin-top: 4px;
        }

        .feedback-list {
            display: grid;
            gap: 20px;
        }

        .feedback-card {
            background: white;
            border-radius: 4px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            transition: all 0.3s;
            position: relative;
        }

        .feedback-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
        }

        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .feedback-type {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .type-rating {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
        }

        .type-suggestion {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
        }

        .type-complaint {
            background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            color: white;
        }

        .feedback-status {
            padding: 6px 14px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-pending {
            background: #fef3c7;
            color: #d97706;
        }

        .status-processing {
            background: #dbeafe;
            color: #2563eb;
        }

        .status-resolved {
            background: #d1fae5;
            color: #059669;
        }

        .feedback-title {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 12px;
        }

        .feedback-content {
            font-size: 14px;
            color: #666;
            line-height: 1.8;
            margin-bottom: 15px;
        }

        .feedback-meta {
            display: flex;
            gap: 20px;
            font-size: 13px;
            color: #999;
            margin-bottom: 15px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .rating {
            display: flex;
            gap: 2px;
        }

        .star {
            font-size: 16px;
            color: #D32F2F;
        }

        .response-section {
            margin-top: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            border-left: 4px solid #10b981;
        }

        .response-header {
            font-size: 12px;
            color: #999;
            margin-bottom: 8px;
            font-weight: bold;
        }

        .response-content {
            font-size: 14px;
            color: #333;
            line-height: 1.8;
        }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
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
            margin-bottom: 30px;
        }

        @media (max-width: 768px) {
            .header-actions {
                flex-direction: column;
            }

            .stats-bar {
                flex-direction: column;
                gap: 15px;
            }

            .feedback-meta {
                flex-direction: column;
                gap: 8px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1>我的反馈</h1>
            <p class="header-subtitle">查看您提交的所有反馈和建议</p>
        </div>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/user/family/feedback/submit" class="btn btn-primary">提交新反馈</a>
            <a href="${pageContext.request.contextPath}/user/family/dashboard" class="btn btn-secondary">← 返回首页</a>
        </div>
    </div>

    <!-- Stats Bar -->
    <div class="stats-bar">
        <div class="stat-item">
            <div class="stat-number">${totalFeedbacks}</div>
            <div class="stat-label">总反馈数</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">${pendingFeedbacks}</div>
            <div class="stat-label">待处理</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">💝</div>
            <div class="stat-label">重视意见</div>
        </div>
    </div>

    <!-- Feedback List -->
    <c:choose>
        <c:when test="${not empty feedbacks}">
            <div class="feedback-list">
                <c:forEach items="${feedbacks}" var="feedback">
                    <div class="feedback-card">
                        <!-- Header -->
                        <div class="feedback-header">
                            <span class="feedback-type
                                ${feedback.feedbackType == 'RATING' ? 'type-rating' :
                                  feedback.feedbackType == 'SUGGESTION' ? 'type-suggestion' : 'type-complaint'}">
                                ${feedback.feedbackType == 'RATING' ? '服务评价' :
                                  feedback.feedbackType == 'SUGGESTION' ? '建议' : '高 投诉'}
                            </span>
                            <span class="feedback-status
                                ${feedback.status == 'PENDING' ? 'status-pending' :
                                  feedback.status == 'PROCESSING' ? 'status-processing' : 'status-resolved'}">
                                ${feedback.status == 'PENDING' ? '待处理' :
                                  feedback.status == 'PROCESSING' ? '处理中' : '已解决'}
                            </span>
                        </div>

                        <!-- Title -->
                        <div class="feedback-title">${feedback.title}</div>

                        <!-- Content -->
                        <div class="feedback-content">${feedback.content}</div>

                        <!-- Meta -->
                        <div class="feedback-meta">
                            <div class="meta-item">
                                <span></span>
                                <span><fmt:formatDate value="${feedback.createdAt}" pattern="yyyy-MM-dd HH:mm"/></span>
                            </div>
                            <c:if test="${feedback.rating != null}">
                                <div class="meta-item">
                                    <span></span>
                                    <div class="rating">
                                        <c:forEach begin="1" end="5" var="i">
                                            <span class="star">${i <= feedback.rating ? '★' : '☆'}</span>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <!-- Response -->
                        <c:if test="${not empty feedback.response}">
                            <div class="response-section">
                                <div class="response-header">管理员回复</div>
                                <div class="response-content">${feedback.response}</div>
                                <c:if test="${feedback.respondedAt != null}">
                                    <div class="feedback-meta" style="margin-top:10px;margin-bottom:0;">
                                        <div class="meta-item">
                                            <span></span>
                                            <span><fmt:formatDate value="${feedback.respondedAt}" pattern="yyyy-MM-dd HH:mm"/></span>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-icon">反馈</div>
                <div class="empty-title">暂无反馈记录</div>
                <div class="empty-desc">您还没有提交任何反馈</div>
                <a href="${pageContext.request.contextPath}/user/family/feedback/submit" class="btn btn-primary">提交第一条反馈</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
