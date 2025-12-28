<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>紧急联系</title>
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

        .section-title {
            background: white;
            padding: 20px 30px;
            border-radius: 4px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            font-size: 20px;
            font-weight: bold;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
            border-left: 4px solid #D32F2F;
        }

        .contact-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .contact-card {
            background: white;
            border-radius: 4px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
            border-left: 4px solid #D32F2F;
        }

        .contact-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
        }

        .contact-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .contact-avatar {
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
            flex-shrink: 0;
        }

        .contact-info {
            flex: 1;
        }

        .contact-name {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }

        .contact-role {
            font-size: 12px;
            color: #999;
            padding: 3px 10px;
            background: #f0f0f0;
            border-radius: 2px;
            display: inline-block;
        }

        .contact-details {
            margin-bottom: 15px;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            font-size: 14px;
            color: #666;
        }

        .detail-icon {
            font-size: 18px;
            width: 24px;
            text-align: center;
        }

        .contact-actions {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .btn-contact {
            padding: 10px;
            border: none;
            border-radius: 2px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .btn-call {
            background: #D32F2F;
            color: white;
            border: 2px solid #D32F2F;
        }

        .btn-call:hover {
            background: #B71C1C;
            border-color: #B71C1C;
        }

        .btn-message {
            background: white;
            color: #D32F2F;
            border: 2px solid #D32F2F;
        }

        .btn-message:hover {
            background: #D32F2F;
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #D32F2F;
        }

        .empty-icon {
            font-size: 60px;
            margin-bottom: 15px;
        }

        .empty-text {
            color: #999;
            font-size: 16px;
        }

        .emergency-notice {
            background: #D32F2F;
            color: white;
            padding: 20px 30px;
            border-radius: 4px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            display: flex;
            align-items: center;
            gap: 15px;
            border-left: 4px solid #B71C1C;
        }

        .emergency-icon {
            font-size: 36px;
        }

        .emergency-text {
            flex: 1;
        }

        .emergency-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .emergency-desc {
            font-size: 14px;
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            .contact-grid {
                grid-template-columns: 1fr;
            }

            .contact-actions {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1>紧急联系</h1>
            <p class="header-subtitle">遇到紧急情况可快速联系社区工作人员或志愿者</p>
        </div>
        <a href="${pageContext.request.contextPath}/user/family/dashboard" class="btn-back">← 返回首页</a>
    </div>

    <!-- Emergency Notice -->
    <div class="emergency-notice">
        <div class="emergency-icon">!</div>
        <div class="emergency-text">
            <div class="emergency-title">紧急求助热线：120 / 110</div>
            <div class="emergency-desc">如遇医疗或安全紧急情况，请先拨打紧急电话</div>
        </div>
    </div>

    <!-- Staff Section -->
    <div class="section-title">
        社区工作人员
    </div>
    <c:choose>
        <c:when test="${not empty staffList}">
            <div class="contact-grid">
                <c:forEach items="${staffList}" var="staff">
                    <div class="contact-card">
                        <div class="contact-header">
                            <div class="contact-avatar">
                                ${staff.fullName != null && !staff.fullName.isEmpty() ? staff.fullName.substring(0,1) : '工'}
                            </div>
                            <div class="contact-info">
                                <div class="contact-name">${staff.fullName != null ? staff.fullName : '工作人员'}</div>
                                <span class="contact-role">社区管理员</span>
                            </div>
                        </div>
                        <div class="contact-details">
                            <c:if test="${not empty staff.phone}">
                                <div class="detail-item">
                                    <span class="detail-icon"></span>
                                    <span>${staff.phone}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty staff.email}">
                                <div class="detail-item">
                                    <span class="detail-icon"></span>
                                    <span>${staff.email}</span>
                                </div>
                            </c:if>
                        </div>
                        <div class="contact-actions">
                            <c:if test="${not empty staff.phone}">
                                <button class="btn-contact btn-call" onclick="window.location.href='tel:${staff.phone}'">
                                    拨打电话
                                </button>
                            </c:if>
                            <c:if test="${not empty staff.email}">
                                <button class="btn-contact btn-message" onclick="window.location.href='mailto:${staff.email}'">
                                    发送邮件
                                </button>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-icon">👔</div>
                <div class="empty-text">暂无工作人员信息</div>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Volunteer Section -->
    <div class="section-title">
        志愿者团队
    </div>
    <c:choose>
        <c:when test="${not empty volunteers}">
            <div class="contact-grid">
                <c:forEach items="${volunteers}" var="vol" varStatus="status">
                    <c:if test="${status.index < 6}">
                        <div class="contact-card">
                            <div class="contact-header">
                                <div class="contact-avatar">
                                    ${vol.fullName != null && !vol.fullName.isEmpty() ? vol.fullName.substring(0,1) : '志'}
                                </div>
                                <div class="contact-info">
                                    <div class="contact-name">${vol.fullName != null ? vol.fullName : '志愿者'}</div>
                                    <span class="contact-role">认证志愿者</span>
                                </div>
                            </div>
                            <div class="contact-details">
                                <c:if test="${not empty vol.phone}">
                                    <div class="detail-item">
                                        <span class="detail-icon"></span>
                                        <span>${vol.phone}</span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty vol.serviceArea}">
                                    <div class="detail-item">
                                        <span class="detail-icon"></span>
                                        <span>${vol.serviceArea}</span>
                                    </div>
                                </c:if>
                            </div>
                            <div class="contact-actions">
                                <c:if test="${not empty vol.phone}">
                                    <button class="btn-contact btn-call" onclick="window.location.href='tel:${vol.phone}'">
                                        拨打电话
                                    </button>
                                </c:if>
                                <button class="btn-contact btn-message" onclick="alert('功能开发中')">
                                    发送消息
                                </button>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
            <c:if test="${volunteers.size() > 6}">
                <div style="text-align:center;margin-top:20px;">
                    <a href="${pageContext.request.contextPath}/user/family/volunteers" class="btn-back">
                        查看全部 ${volunteers.size()} 名志愿者 →
                    </a>
                </div>
            </c:if>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-icon">👥</div>
                <div class="empty-text">暂无志愿者信息</div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
