<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>志愿者团队</title>
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
            transition: all 0.3s;
        }

        .btn-back:hover {
            background: #D32F2F;
            color: white;
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

        .volunteer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 25px;
        }

        .volunteer-card {
            background: white;
            border-radius: 4px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
            border-left: 4px solid #D32F2F;
        }

        .volunteer-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
        }

        .card-header {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .avatar {
            width: 80px;
            height: 80px;
            border-radius: 4px;
            background: linear-gradient(135deg, #B71C1C, #D32F2F);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: white;
            font-weight: bold;
            flex-shrink: 0;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .card-info h3 {
            font-size: 22px;
            color: #333;
            margin-bottom: 8px;
        }

        .info-row {
            font-size: 13px;
            color: #666;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .verified-badge {
            display: inline-block;
            padding: 4px 10px;
            background: #D32F2F;
            color: white;
            border-radius: 2px;
            font-size: 11px;
            font-weight: bold;
            margin-top: 6px;
        }

        .section-title {
            font-size: 14px;
            color: #999;
            margin: 20px 0 12px 0;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .section-title-readonly {
            font-size: 11px;
            color: #ccc;
            font-weight: normal;
        }

        .skills {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .skill-tag {
            padding: 6px 12px;
            background: rgba(211, 47, 47, 0.1);
            color: #D32F2F;
            border-radius: 2px;
            font-size: 12px;
            font-weight: bold;
            border: 1px solid rgba(211, 47, 47, 0.2);
        }

        .skill-tag-empty {
            color: #ccc;
            background: #f5f5f5;
            border: 1px solid #e0e0e0;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            padding: 16px;
            background: #FAF5F0;
            border-radius: 4px;
            margin-bottom: 16px;
        }

        .stat-box {
            text-align: center;
        }

        .stat-value {
            font-size: 20px;
            font-weight: bold;
            color: #D32F2F;
            margin-bottom: 4px;
        }

        .stat-text {
            font-size: 11px;
            color: #999;
        }

        .contact-btn {
            width: 100%;
            padding: 12px;
            background: white;
            color: #D32F2F;
            border: 2px solid #D32F2F;
            border-radius: 2px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }

        .contact-btn:hover {
            background: #D32F2F;
            color: white;
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
            .volunteer-grid {
                grid-template-columns: 1fr;
            }

            .stats-bar {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1>志愿者团队</h1>
            <p class="header-subtitle">为您家人提供专业服务的志愿者队伍</p>
        </div>
        <a href="${pageContext.request.contextPath}/user/family/dashboard" class="btn-back">← 返回首页</a>
    </div>

    <!-- Stats Bar -->
    <div class="stats-bar">
        <div class="stat-item">
            <div class="stat-number">${not empty volunteers ? volunteers.size() : 0}</div>
            <div class="stat-label">认证志愿者</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">${not empty volunteers ? volunteers.size() : 0}</div>
            <div class="stat-label">专业服务</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">${not empty volunteers ? volunteers.size() : 0}</div>
            <div class="stat-label">优质团队</div>
        </div>
    </div>

    <!-- Volunteer Grid -->
    <c:choose>
        <c:when test="${not empty volunteers}">
            <div class="volunteer-grid">
                <c:forEach items="${volunteers}" var="vol">
                    <div class="volunteer-card">
                        <div class="card-header">
                            <c:choose>
                                <c:when test="${not empty vol.avatar}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(vol.avatar, '/')}">
                                            <img src="${pageContext.request.contextPath}${vol.avatar}" class="avatar" style="object-fit: cover;" alt="">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}${vol.avatar}" class="avatar" style="object-fit: cover;" alt="">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar">${vol.fullName.substring(0,1)}</div>
                                </c:otherwise>
                            </c:choose>
                            <div class="card-info">
                                <h3>${vol.fullName}</h3>
                                <div class="info-row">${vol.phone}</div>
                                <div class="info-row">
                                    <c:if test="${not empty vol.gender}">
                                        ${vol.gender == 'MALE' ? '男' : vol.gender == 'FEMALE' ? '女' : ''}
                                    </c:if>
                                    <c:if test="${not empty vol.age}">
                                        · ${vol.age}岁
                                    </c:if>
                                </div>
                                <span class="verified-badge">已认证</span>
                            </div>
                        </div>

                        <!-- 技能标签 -->
                        <div class="section-title">
                            专长技能
                            <span class="section-title-readonly">(参考)</span>
                        </div>
                        <div class="skills">
                            <c:choose>
                                <c:when test="${not empty vol.skillList}">
                                    <c:forEach items="${vol.skillList}" var="skill" varStatus="status">
                                        <c:if test="${status.index < 6}">
                                            <span class="skill-tag">${skill.skill.skillName}</span>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${vol.skillList.size() > 6}">
                                        <span class="skill-tag">+${vol.skillList.size() - 6}项</span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <span class="skill-tag skill-tag-empty">暂无技能标签</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- 服务数据 -->
                        <div class="stats-row">
                            <div class="stat-box">
                                <div class="stat-value">${vol.serviceHours != null ? vol.serviceHours : 0}h</div>
                                <div class="stat-text">服务时长</div>
                            </div>
                            <div class="stat-box">
                                <div class="stat-value">${vol.taskCount != null ? vol.taskCount : 0}</div>
                                <div class="stat-text">完成任务</div>
                            </div>
                            <div class="stat-box">
                                <div class="stat-value">
                                    <c:choose>
                                        <c:when test="${vol.averageRating != null && vol.averageRating > 0}">
                                            ${vol.averageRating}
                                        </c:when>
                                        <c:otherwise>
                                            暂无
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="stat-text">平均评分</div>
                            </div>
                        </div>

                        <!-- 服务区域 -->
                        <c:if test="${not empty vol.serviceArea}">
                            <div class="section-title">服务区域</div>
                            <div style="padding:8px 12px;background:#f8f9fa;border-radius:4px;margin-bottom:12px;font-size:13px;color:#666;">
                                ${vol.serviceArea}
                            </div>
                        </c:if>

                        <!-- 联系按钮 -->
                        <button class="contact-btn" onclick="contactVolunteer('${vol.fullName}', '${vol.phone}')">
                            联系志愿者
                        </button>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-icon">👥</div>
                <div class="empty-title">暂无志愿者</div>
                <div class="empty-desc">当前没有认证的志愿者，请稍后再试</div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    function contactVolunteer(name, phone) {
        alert('志愿者：' + name + '\n联系电话：' + phone + '\n\n您可以直接拨打电话联系志愿者！');
    }
</script>
</body>
</html>


