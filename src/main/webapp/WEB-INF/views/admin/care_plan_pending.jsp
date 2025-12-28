<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>待审核关爱计划</title>
    <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
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
        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .back-btn {
            display: inline-block;
            padding: 10px 20px;
            background: white;
            color: #D32F2F;
            text-decoration: none;
            border-radius: 2px;
            border: 2px solid #D32F2F;
        }
        .back-btn:hover {
            background: #D32F2F;
            color: white;
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
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }
        .plan-meta {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }
        .plan-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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
        .plan-content {
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
            gap: 10px;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e0e0e0;
        }
        .btn {
            padding: 10px 25px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .btn-approve {
            background: #4CAF50;
            color: white;
        }
        .btn-approve:hover {
            background: #388E3C;
        }
        .btn-reject {
            background: #F44336;
            color: white;
        }
        .btn-reject:hover {
            background: #D32F2F;
        }
        .btn-detail {
            background: white;
            color: #D32F2F;
            border: 1px solid #D32F2F;
        }
        .btn-detail:hover {
            background: #FFF5F5;
        }
        .btn:disabled {
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
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 2px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-pending { background: #FFF3E0; color: #E65100; }
        /* 模态框 */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 4px;
            max-width: 500px;
            width: 90%;
        }
        .modal-content h3 {
            color: #333;
            margin-bottom: 20px;
        }
        .modal-content textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            min-height: 100px;
            margin-bottom: 20px;
        }
        .modal-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/admin/care-plan/list" class="back-btn">返回计划列表</a>
        </div>

        <h1>${pageTitle != null ? pageTitle : '待审核关爱计划'}</h1>

        <div class="stats-bar">
            <div class="stat-item">
                <div class="stat-value">${planList.size()}</div>
                <div class="stat-label">待审核计划</div>
            </div>
        </div>

        <c:if test="${not empty success}">
            <div class="message success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>

        <div class="plan-list">
            <c:choose>
                <c:when test="${empty planList}">
                    <div class="empty-state">
                        <h3>暂无待审核的关爱计划</h3>
                        <p>所有计划都已审核完成</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${planList}" var="plan">
                        <div class="plan-card" id="plan-${plan.id}">
                            <div class="plan-header">
                                <div>
                                    <div class="plan-title">${plan.planName}</div>
                                    <div class="plan-meta">
                                        提交时间：<fmt:formatDate value="${plan.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                    </div>
                                </div>
                                <span class="badge badge-pending">待审核</span>
                            </div>

                            <div class="plan-info">
                                <div class="info-item">
                                    <div class="label">关爱对象</div>
                                    <div class="value">${plan.elderlyName}</div>
                                </div>
                                <div class="info-item">
                                    <div class="label">申请家属</div>
                                    <div class="value">${plan.familyUserName}</div>
                                </div>
                                <div class="info-item">
                                    <div class="label">计划周期</div>
                                    <div class="value">
                                        <fmt:formatDate value="${plan.startDate}" pattern="yyyy-MM-dd"/> 至
                                        <fmt:formatDate value="${plan.endDate}" pattern="yyyy-MM-dd"/>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="label">服务设置</div>
                                    <div class="value">
                                        共${plan.totalPeriods}个周期，每周期${plan.servicesPerPeriod}次服务
                                    </div>
                                </div>
                            </div>

                            <c:if test="${not empty plan.serviceContent}">
                                <div class="plan-content">
                                    <strong>服务内容：</strong>${plan.serviceContent}
                                </div>
                            </c:if>

                            <div class="plan-actions">
                                <button class="btn btn-approve" onclick="approvePlan(${plan.id})">审核通过</button>
                                <button class="btn btn-reject" onclick="showRejectModal(${plan.id})">审核拒绝</button>
                                <a href="${pageContext.request.contextPath}/admin/care-plan/audit/${plan.id}" class="btn btn-detail">详细审核</a>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 拒绝原因模态框 -->
    <div class="modal" id="rejectModal">
        <div class="modal-content">
            <h3>审核拒绝</h3>
            <p style="color: #666; margin-bottom: 15px;">请填写拒绝原因，以便家属了解并改进</p>
            <textarea id="rejectRemark" placeholder="请输入拒绝原因..."></textarea>
            <div class="modal-actions">
                <button class="btn btn-detail" onclick="hideRejectModal()">取消</button>
                <button class="btn btn-reject" onclick="confirmReject()">确认拒绝</button>
            </div>
        </div>
    </div>

    <script>
        var currentRejectId = null;

        function approvePlan(planId) {
            if (!confirm('确定要审核通过这个关爱计划吗？')) {
                return;
            }

            var card = document.getElementById('plan-' + planId);
            var btns = card.querySelectorAll('.btn');
            btns.forEach(function(btn) { btn.disabled = true; });

            fetch('${pageContext.request.contextPath}/admin/care-plan/approve/' + planId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    card.style.display = 'none';
                    updatePendingCount(-1);
                    alert('审核通过！');
                } else {
                    alert(data.message || '操作失败');
                    btns.forEach(function(btn) { btn.disabled = false; });
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('系统错误');
                btns.forEach(function(btn) { btn.disabled = false; });
            });
        }

        function showRejectModal(planId) {
            currentRejectId = planId;
            document.getElementById('rejectRemark').value = '';
            document.getElementById('rejectModal').style.display = 'flex';
        }

        function hideRejectModal() {
            document.getElementById('rejectModal').style.display = 'none';
            currentRejectId = null;
        }

        function confirmReject() {
            var remark = document.getElementById('rejectRemark').value.trim();
            if (!remark) {
                alert('请填写拒绝原因');
                return;
            }

            var card = document.getElementById('plan-' + currentRejectId);
            var btns = card.querySelectorAll('.btn');
            btns.forEach(function(btn) { btn.disabled = true; });

            fetch('${pageContext.request.contextPath}/admin/care-plan/reject/' + currentRejectId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'remark=' + encodeURIComponent(remark)
            })
            .then(response => response.json())
            .then(data => {
                hideRejectModal();
                if (data.success) {
                    card.style.display = 'none';
                    updatePendingCount(-1);
                    alert('已拒绝！');
                } else {
                    alert(data.message || '操作失败');
                    btns.forEach(function(btn) { btn.disabled = false; });
                }
            })
            .catch(error => {
                console.error('Error:', error);
                hideRejectModal();
                alert('系统错误');
                btns.forEach(function(btn) { btn.disabled = false; });
            });
        }

        function updatePendingCount(delta) {
            var countEl = document.querySelector('.stat-value');
            if (countEl) {
                var count = parseInt(countEl.textContent) + delta;
                countEl.textContent = Math.max(0, count);
            }
        }

        // 点击模态框外部关闭
        document.getElementById('rejectModal').addEventListener('click', function(e) {
            if (e.target === this) {
                hideRejectModal();
            }
        });
    </script>
</body>
</html>
