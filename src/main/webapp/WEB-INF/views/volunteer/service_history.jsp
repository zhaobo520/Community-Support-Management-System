<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>服务历史记录</title>
    <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', sans-serif;
            background: #FAF5F0;
            min-height: 100vh;
            padding: 0;
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
        }
        .gov-header .actions {
            display: flex;
            gap: 20px;
        }
        .gov-header .actions a {
            color: white;
            text-decoration: none;
            font-size: 14px;
            transition: opacity 0.3s;
        }
        .gov-header .actions a:hover {
            opacity: 0.8;
        }
        .container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 4px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid #D32F2F;
        }
        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #D32F2F;
            margin-bottom: 8px;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        .filter-bar {
            background: white;
            padding: 16px 20px;
            border-radius: 4px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid #D32F2F;
        }
        .filter-bar label {
            color: #212121;
            font-weight: 600;
        }
        .filter-bar input[type="month"] {
            padding: 8px 12px;
            border: 1px solid #E0E0E0;
            border-radius: 2px;
            outline: none;
        }
        .filter-bar input[type="month"]:focus {
            border-color: #D32F2F;
        }
        .filter-btn {
            padding: 8px 20px;
            background: white;
            color: #D32F2F;
            border: 1px solid #D32F2F;
            border-radius: 2px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }
        .filter-btn:hover {
            background: #D32F2F;
            color: white;
        }
        .reset-btn {
            padding: 8px 20px;
            background: white;
            color: #666;
            border: 1px solid #999;
            border-radius: 2px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            margin-left: auto;
        }
        .reset-btn:hover {
            background: #999;
            color: white;
        }
        .task-list {
            background: white;
            border-radius: 4px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid #D32F2F;
        }
        .task-item {
            padding: 20px;
            border-bottom: 1px solid #FAF5F0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background 0.2s;
            cursor: pointer;
        }
        .task-item:last-child {
            border-bottom: none;
        }
        .task-item:hover {
            background: #FAF5F0;
        }
        .task-info h3 {
            font-size: 16px;
            color: #212121;
            margin-bottom: 8px;
        }
        .task-meta {
            color: #666;
            font-size: 14px;
            display: flex;
            gap: 20px;
        }
        .task-status {
            padding: 4px 10px;
            border-radius: 2px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-approved {
            background: rgba(211, 47, 47,0.15);
            color: #D32F2F;
        }
        .status-completed {
            background: rgba(211,47,47,0.15);
            color: #D32F2F;
        }
        .rating-stars {
            color: #B71C1C;
            font-size: 16px;
            margin-top: 5px;
        }
        .empty-state {
            padding: 40px;
            text-align: center;
            color: #999;
        }
        .empty-state p {
            font-size: 14px;
        }
    </style>
</head>
<body>
    <header class="gov-header">
        <h1>服务历史记录</h1>
        <div class="actions">
            <a href="${pageContext.request.contextPath}/user/volunteer/dashboard">返回仪表盘</a>
            <a href="${pageContext.request.contextPath}/user/logout">退出</a>
        </div>
    </header>

    <div class="container">
        <div class="stats-cards">
            <div class="stat-card">
                <div class="stat-value">${totalServiceCount}</div>
                <div class="stat-label">总服务次数</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${averageRating}</div>
                <div class="stat-label">平均评分</div>
            </div>
        </div>

        <div class="filter-bar">
            <form action="${pageContext.request.contextPath}/volunteer/history/list" method="get" style="display:flex;gap:10px;align-items:center;width:100%;">
                <label>按月份筛选：</label>
                <input type="month" name="month" value="${currentMonth}">
                <button type="submit" class="filter-btn">查询</button>
                <a href="${pageContext.request.contextPath}/volunteer/history/list" class="reset-btn">重置</a>
            </form>
        </div>

        <div class="task-list">
            <c:choose>
                <c:when test="${not empty historyTasks}">
                    <c:forEach items="${historyTasks}" var="task">
                        <div class="task-item" onclick="window.location.href='${pageContext.request.contextPath}/task/detail/${task.id}'">
                            <div class="task-info">
                                <h3>${task.taskTitle}</h3>
                                <div class="task-meta">
                                    <span>完成时间：<fmt:formatDate value="${task.completedTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                                    <span>服务对象：${task.elderlyName}</span>
                                </div>
                            </div>
                            <div style="text-align:right;">
                                <c:choose>
                                    <c:when test="${task.status == 'APPROVED'}">
                                        <span class="task-status status-approved">已审核</span>
                                        <div class="rating-stars">
                                            <c:forEach begin="1" end="${task.rating}">★</c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="task-status status-completed">已完成</span>
                                        <div style="font-size:12px;color:#999;margin-top:5px;">等待审核</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>暂无服务记录</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>

