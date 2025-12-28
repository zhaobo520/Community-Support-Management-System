<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>接单大厅</title>
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
            background: white;
            border-radius: 4px;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid #D32F2F;
        }
        h1 {
            color: #D32F2F;
            margin-bottom: 10px;
            font-size: 28px;
        }
        .subtitle {
            color: #666;
            margin-bottom: 20px;
        }
        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .back-btn, .my-plans-btn {
            display: inline-block;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 2px;
            font-size: 14px;
        }
        .back-btn {
            background: white;
            color: #D32F2F;
            border: 2px solid #D32F2F;
        }
        .my-plans-btn {
            background: #D32F2F;
            color: white;
            border: 2px solid #D32F2F;
        }
        .stats-bar {
            display: flex;
            gap: 20px;
            margin: 20px 0;
            padding: 20px;
            background: #FFF5F5;
            border-radius: 4px;
            border-left: 4px solid #D32F2F;
        }
        .stat-item {
            text-align: center;
        }
        .stat-value {
            font-size: 32px;
            font-weight: bold;
            color: #D32F2F;
        }
        .stat-label {
            font-size: 14px;
            color: #666;
        }
        .plan-list {
            margin-top: 20px;
        }
        .plan-card {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            padding: 25px;
            margin-bottom: 20px;
            transition: all 0.3s;
        }
        .plan-card:hover {
            border-color: #D32F2F;
            box-shadow: 0 4px 12px rgba(211,47,47,0.15);
        }
        .plan-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        .plan-title {
            font-size: 20px;
            font-weight: bold;
            color: #333;
        }
        .plan-date {
            font-size: 12px;
            color: #999;
        }
        .plan-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        .info-item {
            font-size: 14px;
        }
        .info-item .label {
            color: #999;
            margin-bottom: 3px;
        }
        .info-item .value {
            color: #333;
            font-weight: 500;
        }
        .plan-description {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 4px;
            margin: 15px 0;
            font-size: 14px;
            color: #666;
            line-height: 1.6;
        }
        .plan-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e0e0e0;
        }
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
        }
        .btn-claim {
            background: #D32F2F;
            color: white;
        }
        .btn-claim:hover {
            background: #B71C1C;
        }
        .btn-claim:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: #666;
        }
        .empty-state h3 {
            margin-bottom: 10px;
            color: #999;
            font-size: 20px;
        }
        .empty-state p {
            color: #bbb;
        }
        .message {
            padding: 15px;
            margin: 15px 0;
            border-radius: 4px;
        }
        .message.success {
            background: #E8F5E9;
            color: #2E7D32;
            border-left: 4px solid #4CAF50;
        }
        .message.error {
            background: #FFEBEE;
            color: #C62828;
            border-left: 4px solid #F44336;
        }
        .tag {
            display: inline-block;
            padding: 4px 10px;
            background: #FFF5F5;
            color: #D32F2F;
            border-radius: 2px;
            font-size: 12px;
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/user/volunteer/dashboard" class="back-btn">返回仪表盘</a>
            <a href="${pageContext.request.contextPath}/volunteer/care-plan/list" class="my-plans-btn">我的计划</a>
        </div>

        <h1>接单大厅</h1>
        <p class="subtitle">浏览并认领需要帮助的关爱计划，为关爱对象提供温暖服务</p>

        <div class="stats-bar">
            <div class="stat-item">
                <div class="stat-value">${claimableCount}</div>
                <div class="stat-label">待认领计划</div>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="message success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>

        <div class="plan-list">
            <c:choose>
                <c:when test="${empty planList}">
                    <div class="empty-state">
                        <h3>暂无待认领的计划</h3>
                        <p>当前没有需要认领的关爱计划，请稍后再来查看</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${planList}" var="plan">
                        <div class="plan-card" id="plan-${plan.id}">
                            <div class="plan-header">
                                <div>
                                    <div class="plan-title">${plan.planName}</div>
                                    <div class="plan-date">
                                        发布时间：<fmt:formatDate value="${plan.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                    </div>
                                </div>
                                <div>
                                    <span class="tag">${plan.serviceType}</span>
                                    <span class="tag">${plan.periodTypeText}</span>
                                </div>
                            </div>

                            <div class="plan-info">
                                <div class="info-item">
                                    <div class="label">关爱对象姓名</div>
                                    <div class="value">${plan.elderlyName}</div>
                                </div>
                                <div class="info-item">
                                    <div class="label">服务地址</div>
                                    <div class="value">${plan.elderlyAddress}</div>
                                </div>
                                <div class="info-item">
                                    <div class="label">服务频率</div>
                                    <div class="value">${plan.serviceFrequency}</div>
                                </div>
                                <div class="info-item">
                                    <div class="label">服务周期</div>
                                    <div class="value">
                                        <fmt:formatDate value="${plan.startDate}" pattern="MM/dd"/> -
                                        <fmt:formatDate value="${plan.endDate}" pattern="MM/dd"/>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="label">总服务次数</div>
                                    <div class="value">${plan.totalServices} 次</div>
                                </div>
                                <div class="info-item">
                                    <div class="label">家属联系人</div>
                                    <div class="value">${plan.familyName}</div>
                                </div>
                            </div>

                            <c:if test="${not empty plan.description}">
                                <div class="plan-description">
                                    <strong>计划描述：</strong>${plan.description}
                                </div>
                            </c:if>

                            <div class="plan-actions">
                                <button class="btn btn-claim" onclick="claimPlan(${plan.id})">立即认领</button>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        function claimPlan(planId) {
            if (!confirm('确定要认领这个关爱计划吗？认领后您需要按计划提供服务。')) {
                return;
            }

            var btn = event.target;
            btn.disabled = true;
            btn.textContent = '认领中...';

            fetch('${pageContext.request.contextPath}/volunteer/care-plan/claim/' + planId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('认领成功！');
                    document.getElementById('plan-' + planId).style.display = 'none';
                    // 更新统计数字
                    var countEl = document.querySelector('.stat-value');
                    if (countEl) {
                        var count = parseInt(countEl.textContent) - 1;
                        countEl.textContent = count;
                    }
                } else {
                    alert(data.message || '认领失败，请重试');
                    btn.disabled = false;
                    btn.textContent = '立即认领';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('系统错误，请重试');
                btn.disabled = false;
                btn.textContent = '立即认领';
            });
        }
    </script>
</body>
</html>
