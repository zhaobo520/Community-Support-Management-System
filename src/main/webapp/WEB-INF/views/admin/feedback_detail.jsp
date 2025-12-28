<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>反馈详情</title>
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
            padding: 20px;
        }

        .gov-header {
            background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
            height: 60px;
            padding: 0 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            position: relative;
            margin-bottom: 40px;
            border-radius: 4px;
        }

        .gov-header::before {
            content: '★';
            position: absolute;
            left: 20px;
            color: #B71C1C;
            font-size: 24px;
        }

        .gov-header h1 {
            color: white;
            font-size: 20px;
            font-weight: 600;
            margin-left: 50px;
            letter-spacing: 1px;
            margin: 0;
        }

        .btn-back {
            padding: 8px 20px;
            background: white;
            color: #D32F2F;
            border: 2px solid white;
            border-radius: 2px;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
        }

        .btn-back:hover {
            background: rgba(255,255,255,0.9);
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
        }

        .card {
            background: white;
            border-radius: 4px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #D32F2F;
        }

        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
            margin-bottom: 20px;
        }

        .feedback-type {
            padding: 6px 14px;
            border-radius: 2px;
            font-size: 12px;
            font-weight: bold;
            color: white;
        }

        .type-rating { background: #10b981; }
        .type-suggestion { background: #3b82f6; }
        .type-complaint { background: #f97316; }

        .feedback-status {
            padding: 6px 14px;
            border-radius: 2px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-pending { background: #fef3c7; color: #d97706; }
        .status-processing { background: #dbeafe; color: #2563eb; }
        .status-resolved { background: #d1fae5; color: #059669; }

        .section-title {
            font-size: 14px;
            font-weight: bold;
            color: #999;
            margin-bottom: 10px;
            margin-top: 20px;
        }

        .content-box {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 2px;
            border-left: 4px solid #D32F2F;
            font-size: 15px;
            line-height: 1.8;
            color: #333;
        }

        .meta-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin: 20px 0;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: #666;
        }

        .response-form {
            margin-top: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }

        .form-select,
        .form-textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e5e7eb;
            border-radius: 2px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s;
        }

        .form-textarea {
            min-height: 150px;
            resize: vertical;
        }

        .form-select:focus,
        .form-textarea:focus {
            outline: none;
            border-color: #D32F2F;
            box-shadow: 0 0 0 3px rgba(211, 47, 47, 0.1);
        }

        .btn-submit {
            width: 100%;
            padding: 15px;
            background: white;
            color: #D32F2F;
            border: 2px solid #D32F2F;
            border-radius: 2px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-submit:hover {
            background: #D32F2F;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(211, 47, 47, 0.3);
        }

        .existing-response {
            padding: 20px;
            background: #d1fae5;
            border-radius: 2px;
            border-left: 4px solid #10b981;
            margin-top: 20px;
        }

        .response-header {
            font-size: 12px;
            color: #059669;
            font-weight: bold;
            margin-bottom: 10px;
        }

        h2 {
            font-size: 22px;
            margin-bottom: 20px;
            color: #212121;
        }

        h3 {
            font-size: 18px;
            margin-bottom: 20px;
            color: #212121;
        }
    </style>
</head>
<body>
<header class="gov-header">
    <h1>反馈详情</h1>
    <a href="${pageContext.request.contextPath}/admin/feedback/list" class="btn-back">返回列表</a>
</header>

<div class="container">
    <!-- Feedback Detail -->
    <div class="card">
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

        <h2>${feedback.title}</h2>

        <div class="meta-grid">
            <div class="meta-item">
                <span>提交时间：<fmt:formatDate value="${feedback.createdAt}" pattern="yyyy-MM-dd HH:mm"/></span>
            </div>
            <c:if test="${feedback.rating != null}">
                <div class="meta-item">
                    <span>评分：${feedback.rating} 分</span>
                </div>
            </c:if>
            <c:if test="${not empty feedback.volunteerName}">
                <div class="meta-item">
                    <span>关联志愿者：${feedback.volunteerName}</span>
                </div>
            </c:if>
        </div>

        <div class="section-title">反馈内容</div>
        <div class="content-box">${feedback.content}</div>

        <!-- Existing Response -->
        <c:if test="${not empty feedback.response}">
            <div class="existing-response">
                <div class="response-header">管理员回复</div>
                <div style="font-size:15px;line-height:1.8;color:#333;">${feedback.response}</div>
                <c:if test="${feedback.respondedAt != null}">
                    <div style="font-size:12px;color:#059669;margin-top:10px;">
                        回复时间：<fmt:formatDate value="${feedback.respondedAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </div>
                </c:if>
            </div>
        </c:if>

        <!-- Response Form -->
        <div class="response-form">
            <h3>${empty feedback.response ? '添加回复' : '修改回复'}</h3>
            <form action="${pageContext.request.contextPath}/admin/feedback/respond/${feedback.id}" method="post">
                <div class="form-group">
                    <label class="form-label">回复内容 *</label>
                    <textarea name="response" class="form-textarea" required
                              placeholder="请输入回复内容...">${feedback.response}</textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">处理状态 *</label>
                    <select name="status" class="form-select" required>
                        <option value="PENDING" ${feedback.status == 'PENDING' ? 'selected' : ''}>待处理</option>
                        <option value="PROCESSING" ${feedback.status == 'PROCESSING' ? 'selected' : ''}>处理中</option>
                        <option value="RESOLVED" ${feedback.status == 'RESOLVED' ? 'selected' : ''}>已解决</option>
                    </select>
                </div>

                <button type="submit" class="btn-submit">提交回复</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
