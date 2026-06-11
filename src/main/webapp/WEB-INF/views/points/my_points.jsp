<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的积分</title>
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
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .summary-card {
            background: white;
            border-radius: 6px;
            padding: 24px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #D32F2F;
        }
        .summary-card .label {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .summary-card .value {
            font-size: 36px;
            font-weight: bold;
            color: #D32F2F;
            margin-bottom: 5px;
        }
        .summary-card .sub-value {
            font-size: 14px;
            color: #999;
        }
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }
        @media (max-width: 900px) {
            .content-grid { grid-template-columns: 1fr; }
        }
        .section {
            background: white;
            border-radius: 6px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #D32F2F;
        }
        .section-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }
        .records-list {
            max-height: 600px;
            overflow-y: auto;
        }
        .record-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            transition: background 0.3s;
        }
        .record-item:hover { background: #f8f9ff; }
        .record-item:last-child { border-bottom: none; }
        .record-info { flex: 1; }
        .record-reason {
            font-size: 16px;
            color: #333;
            margin-bottom: 5px;
        }
        .record-time {
            font-size: 12px;
            color: #999;
        }
        .record-points {
            font-size: 24px;
            font-weight: bold;
        }
        .record-points.positive { color: #10b981; }
        .record-points.negative { color: #ef4444; }
        .badges-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 12px;
        }
        .badge-item {
            display: flex;
            align-items: center;
            padding: 14px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            transition: all 0.3s;
            background: #fff;
        }
        .badge-item.earned {
            border-color: #D32F2F;
            background: #FFF5F5;
        }
        .badge-item:hover {
            transform: translateX(5px);
        }
        .badge-mark {
            min-width: 54px;
            height: 54px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            font-size: 14px;
            font-weight: bold;
            color: white;
            background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
            box-shadow: 0 4px 10px rgba(211, 47, 47, 0.18);
        }
        .badge-item:not(.earned) .badge-mark {
            background: linear-gradient(135deg, #9ca3af 0%, #6b7280 100%);
        }
        .badge-info { flex: 1; }
        .badge-name {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin-bottom: 4px;
        }
        .badge-desc {
            font-size: 12px;
            color: #666;
            line-height: 1.6;
        }
        .badge-locked {
            font-size: 12px;
            color: #999;
            font-style: italic;
        }
        .download-cert-btn {
            margin-top: 10px;
            padding: 8px 16px;
            background: white;
            color: #D32F2F;
            border: 2px solid #D32F2F;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            font-weight: bold;
            transition: all 0.3s;
            box-shadow: 0 2px 8px rgba(211, 47, 47, 0.08);
        }
        .download-cert-btn:hover {
            background: #D32F2F;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(211, 47, 47, 0.3);
        }
        .back-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 24px;
            background: white;
            color: #D32F2F;
            border: 2px solid #D32F2F;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s;
        }
        .back-btn:hover {
            background: #D32F2F;
            color: white;
            transform: translateY(-2px);
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        .tab-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .tab-btn {
            padding: 10px 20px;
            border: none;
            background: #f0f0f0;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s;
        }
        .tab-btn.active {
            background: #D32F2F;
            color: white;
        }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>我的积分</h1>
        <p>查看积分记录和勋章成就</p>
    </div>

    <div class="summary-cards">
        <div class="summary-card">
            <div class="label">当前积分</div>
            <div class="value">${totalPoints != null ? totalPoints : 0}</div>
            <div class="sub-value">累计获得积分</div>
        </div>
        <div class="summary-card">
            <div class="label">我的排名</div>
            <div class="value">${ranking > 0 ? ranking : '-'}</div>
            <div class="sub-value">在所有志愿者中</div>
        </div>
        <div class="summary-card">
            <div class="label">勋章数量</div>
            <div class="value">${earnedBadges != null ? earnedBadges.size() : 0}</div>
            <div class="sub-value">已解锁勋章</div>
        </div>
        <div class="summary-card">
            <div class="label">积分记录</div>
            <div class="value">${records != null ? records.size() : 0}</div>
            <div class="sub-value">历史记录条数</div>
        </div>
    </div>

    <div class="content-grid">
        <div class="section">
            <div class="section-title">积分记录</div>
            <div class="records-list">
                <c:choose>
                    <c:when test="${not empty records}">
                        <c:forEach items="${records}" var="record">
                            <div class="record-item">
                                <div class="record-info">
                                    <div class="record-reason">${record.reason}</div>
                                    <div class="record-time">
                                        <fmt:formatDate value="${record.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                    </div>
                                </div>
                                <div class="record-points ${record.points > 0 ? 'positive' : 'negative'}">
                                    ${record.points > 0 ? '+' : ''}${record.points}
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            暂无积分记录<br>
                            完成任务即可获得积分
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="section">
            <div class="section-title">勋章成就</div>
            <div class="tab-buttons">
                <button class="tab-btn active" onclick="switchTab('earned', event)">已获得</button>
                <button class="tab-btn" onclick="switchTab('locked', event)">未解锁</button>
            </div>

            <div id="earned-badges" class="tab-content active">
                <div class="badges-grid">
                    <c:choose>
                        <c:when test="${not empty earnedBadges}">
                            <c:forEach items="${earnedBadges}" var="badge">
                                <div class="badge-item earned">
                                    <div class="badge-mark">已得</div>
                                    <div class="badge-info">
                                        <div class="badge-name">${badge.badgeName}</div>
                                        <div class="badge-desc">${badge.description}</div>
                                        <div class="badge-desc" style="margin-top: 4px; color: #10b981;">
                                            <fmt:formatDate value="${badge.earnedAt}" pattern="yyyy-MM-dd 获得"/>
                                        </div>
                                        <button class="download-cert-btn" onclick="downloadCertificate(${badge.id}, '${badge.badgeName}', event)">下载荣誉证书</button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                暂无勋章<br>
                                完成任务解锁成就
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div id="locked-badges" class="tab-content">
                <div class="badges-grid">
                    <c:choose>
                        <c:when test="${not empty lockedBadges}">
                            <c:forEach items="${lockedBadges}" var="badge">
                                <div class="badge-item">
                                    <div class="badge-mark">未得</div>
                                    <div class="badge-info">
                                        <div class="badge-name" style="color: #999;">${badge.badgeName}</div>
                                        <div class="badge-locked">解锁条件：${badge.unlockCondition}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">恭喜！所有勋章已解锁</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <div style="text-align: center;">
        <a href="${pageContext.request.contextPath}/user/volunteer/dashboard" class="back-btn">← 返回首页</a>
        <a href="${pageContext.request.contextPath}/points/ranking" class="back-btn" style="margin-left: 10px;">查看排行榜</a>
    </div>
</div>

<script>
    function switchTab(tab, event) {
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        event.target.classList.add('active');
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
        document.getElementById(tab + '-badges').classList.add('active');
    }

    function downloadCertificate(badgeId, badgeName, event) {
        const btn = event.target;
        const originalText = btn.innerHTML;
        btn.innerHTML = '生成中...';
        btn.disabled = true;
        const downloadUrl = '${pageContext.request.contextPath}/points/certificate/' + badgeId;
        window.location.href = downloadUrl;
        setTimeout(function() {
            btn.innerHTML = originalText;
            btn.disabled = false;
        }, 2000);
    }
</script>
</body>
</html>
