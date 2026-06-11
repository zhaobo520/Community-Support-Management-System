<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>积分排行榜</title>
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
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        .header h1 {
            font-size: 32px;
            margin-bottom: 10px;
            color: #D32F2F;
        }

        .header p {
            font-size: 16px;
            opacity: 0.7;
            color: #666;
        }

        .filter-tabs {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 25px;
        }

        .tab {
            padding: 10px 30px;
            border-radius: 2px;
            border: 2px solid #D32F2F;
            background: white;
            color: #D32F2F;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 500;
        }

        .tab:hover {
            background: rgba(211, 47, 47, 0.1);
            transform: translateY(-2px);
        }

        .tab.active {
            background: #D32F2F;
            color: white;
            font-weight: bold;
            box-shadow: 0 4px 15px rgba(211, 47, 47, 0.3);
        }

        .my-rank-card {
            background: white;
            border-radius: 4px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #D32F2F;
            display: flex;
            justify-content: space-around;
            align-items: center;
        }

        .my-rank-item {
            text-align: center;
        }

        .my-rank-label {
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .my-rank-value {
            font-size: 28px;
            font-weight: bold;
            color: #D32F2F;
        }

        .ranking-list {
            background: white;
            border-radius: 4px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #D32F2F;
        }

        .ranking-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            transition: all 0.3s;
            border-radius: 12px;
            margin-bottom: 8px;
        }

        .ranking-item:hover {
            background: #f8f9ff;
            transform: scale(1.01);
        }

        .ranking-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .rank-number {
            width: 50px;
            text-align: center;
            font-size: 20px;
            font-weight: bold;
            color: #999;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .ranking-item.top-1 {
            background: linear-gradient(to right, #fffbeb, #ffffff);
            border: 2px solid #fcd34d;
        }
        .ranking-item.top-2 {
            background: linear-gradient(to right, #f8fafc, #ffffff);
            border: 2px solid #cbd5e1;
        }
        .ranking-item.top-3 {
            background: linear-gradient(to right, #fff7ed, #ffffff);
            border: 2px solid #fdba74;
        }

        .top-badge {
            font-size: 28px;
            line-height: 1;
        }

        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin: 0 15px;
            object-fit: cover;
            border: 2px solid #f0f0f0;
            background-color: #eee;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: #999;
            font-weight: bold;
        }

        .user-info {
            flex: 1;
        }

        .user-name {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }

        .user-stats {
            font-size: 12px;
            color: #666;
        }

        .points {
            font-size: 20px;
            font-weight: bold;
            color: #D32F2F;
            min-width: 80px;
            text-align: right;
        }

        .ranking-item.top-1 .points { color: #D97706; }
        .ranking-item.top-2 .points { color: #D32F2F; }
        .ranking-item.top-3 .points { color: #D97706; }

        .back-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 24px;
            background: white;
            color: #D32F2F;
            border: 2px solid #D32F2F;
            border-radius: 2px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s;
        }

        .back-btn:hover {
            background: #D32F2F;
            color: white;
            transform: translateY(-2px);
        }
        
        .self-tag {
            background: #D32F2F;
            color: white;
            font-size: 10px;
            padding: 2px 6px;
            border-radius: 4px;
            margin-left: 8px;
            vertical-align: middle;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>志愿者风云榜</h1>
        <p>感谢每一位无私奉献的志愿者</p>
    </div>
    
    <div class="filter-tabs">
        <button class="tab ${empty type || type == 'TOTAL' ? 'active' : ''}" onclick="location.href='?type=TOTAL'">总榜</button>
        <button class="tab ${type == 'MONTH' ? 'active' : ''}" onclick="location.href='?type=MONTH'">本月榜</button>
        <button class="tab ${type == 'YEAR' ? 'active' : ''}" onclick="location.href='?type=YEAR'">本年榜</button>
    </div>

    <c:if test="${currentUser.roleType == 'VOLUNTEER'}">
        <div class="my-rank-card">
            <div class="my-rank-item">
                <div class="my-rank-label">我的排名</div>
                <div class="my-rank-value">
                    <c:choose>
                        <c:when test="${myRanking > 0}">
                             <span style="color: #3b82f6;">#${myRanking}</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #94a3b8; font-size: 20px;">未上榜</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="my-rank-item">
                <div class="my-rank-label">我的积分</div>
                <div class="my-rank-value">${myPoints != null ? myPoints : 0}</div>
            </div>
             <div class="my-rank-item">
                <div class="my-rank-label">当前榜单</div>
                <div class="my-rank-value" style="font-size: 16px; color: #64748b;">
                    <c:choose>
                        <c:when test="${type == 'MONTH'}">本月排行</c:when>
                        <c:when test="${type == 'YEAR'}">本年排行</c:when>
                        <c:otherwise>总排行</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </c:if>

    <div class="ranking-list">
        <c:forEach items="${rankingList}" var="item" varStatus="status">
            <div class="ranking-item ${status.index == 0 ? 'top-1' : (status.index == 1 ? 'top-2' : (status.index == 2 ? 'top-3' : ''))}">
                <div class="rank-number">
                    <c:choose>
                        <c:when test="${status.index == 0}"><span class="top-badge">1</span></c:when>
                        <c:when test="${status.index == 1}"><span class="top-badge">2</span></c:when>
                        <c:when test="${status.index == 2}"><span class="top-badge">3</span></c:when>
                        <c:otherwise>${status.index + 1}</c:otherwise>
                    </c:choose>
                </div>
                
                <div class="user-avatar">
                    <c:choose>
                        <c:when test="${not empty item.avatar}">
                             <c:choose>
                                <c:when test="${fn:startsWith(item.avatar, pageContext.request.contextPath)}">
                                  <img src="${pageContext.request.contextPath}${item.avatar}" alt="" style="width:100%;height:100%;border-radius:50%;object-fit:cover;"/>
                                </c:when>
                                <c:otherwise>
                                  <img src="${pageContext.request.contextPath}${item.avatar}" alt="" style="width:100%;height:100%;border-radius:50%;object-fit:cover;"/>
                                </c:otherwise>
                              </c:choose>
                        </c:when>
                        <c:otherwise>
                            ${fn:substring(item.full_name != null ? item.full_name : item.username, 0, 1)}
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="user-info">
                    <div class="user-name">
                        ${item.full_name != null ? item.full_name : item.username}
                        <c:if test="${currentUser.id == item.user_id}">
                            <span class="self-tag">我</span>
                        </c:if>
                    </div>
                    <div class="user-stats">完成任务：${item.completed_tasks} 个</div>
                </div>
                <div class="points">${item.total_points} 分</div>
            </div>
        </c:forEach>
        
        <c:if test="${empty rankingList}">
            <div style="text-align: center; padding: 40px; color: #999;">
                <div style="font-size: 40px; margin-bottom: 10px;">📊</div>
                暂无排行数据
            </div>
        </c:if>
    </div>

    <div style="text-align: center;">
        <c:choose>
            <c:when test="${currentUser.roleType == 'VOLUNTEER'}">
                <a href="${pageContext.request.contextPath}/user/volunteer/dashboard" class="back-btn">← 返回首页</a>
            </c:when>
            <c:when test="${currentUser.roleType == 'FAMILY'}">
                <a href="${pageContext.request.contextPath}/user/family/dashboard" class="back-btn">← 返回首页</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/user/admin/dashboard" class="back-btn">← 返回首页</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>

