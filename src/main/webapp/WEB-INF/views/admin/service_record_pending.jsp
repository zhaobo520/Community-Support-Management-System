<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>待审核服务记录</title>
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
        .record-list {
            margin-top: 20px;
        }
        .record-card {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            padding: 25px;
            margin-bottom: 20px;
            transition: all 0.3s;
        }
        .record-card:hover {
            border-color: #D32F2F;
            box-shadow: 0 4px 12px rgba(211,47,47,0.15);
        }
        .record-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        .record-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }
        .record-meta {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }
        .record-info {
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
        .record-content {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 4px;
            margin: 15px 0;
            font-size: 14px;
            color: #666;
            line-height: 1.6;
        }
        .record-photos {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin: 15px 0;
        }
        .record-photo {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 4px;
            cursor: pointer;
            border: 2px solid #e0e0e0;
        }
        .record-photo:hover {
            border-color: #D32F2F;
        }
        .record-actions {
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
        .modal-close {
            position: absolute;
            top: 20px;
            right: 30px;
            color: white;
            font-size: 30px;
            cursor: pointer;
        }
        .image-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.9);
            z-index: 1001;
            justify-content: center;
            align-items: center;
        }
        .image-modal img {
            max-width: 90%;
            max-height: 90%;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/admin/care-plan/list" class="back-btn">返回计划列表</a>
        </div>

        <h1>待审核服务记录</h1>

        <div class="stats-bar">
            <div class="stat-item">
                <div class="stat-value">${pendingCount}</div>
                <div class="stat-label">待审核记录</div>
            </div>
        </div>

        <c:if test="${not empty success}">
            <div class="message success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>

        <div class="record-list">
            <c:choose>
                <c:when test="${empty records}">
                    <div class="empty-state">
                        <h3>暂无待审核的服务记录</h3>
                        <p>所有服务记录都已审核完成</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${records}" var="record">
                        <div class="record-card" id="record-${record.id}">
                            <div class="record-header">
                                <div>
                                    <div class="record-title">${record.planName}</div>
                                    <div class="record-meta">
                                        第${record.periodNumber}周期 第${record.serviceNumber}次服务 |
                                        提交时间：<fmt:formatDate value="${record.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                    </div>
                                </div>
                                <span class="badge badge-pending">待审核</span>
                            </div>

                            <div class="record-info">
                                <div class="info-item">
                                    <div class="label">志愿者</div>
                                    <div class="value">${record.volunteerName}</div>
                                </div>
                                <div class="info-item">
                                    <div class="label">关爱对象</div>
                                    <div class="value">${record.elderlyName}</div>
                                </div>
                                <div class="info-item">
                                    <div class="label">服务日期</div>
                                    <div class="value"><fmt:formatDate value="${record.serviceDate}" pattern="yyyy-MM-dd"/></div>
                                </div>
                                <div class="info-item">
                                    <div class="label">服务时间</div>
                                    <div class="value">
                                        <c:choose>
                                            <c:when test="${not empty record.serviceTimeStart}">
                                                ${record.serviceTimeStart} - ${record.serviceTimeEnd}
                                            </c:when>
                                            <c:otherwise>未记录</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="record-content">
                                <strong>服务内容：</strong>${record.serviceContent}
                            </div>

                            <c:if test="${not empty record.elderlyCondition}">
                                <div class="record-content">
                                    <strong>关爱对象状况：</strong>${record.elderlyCondition}
                                </div>
                            </c:if>

                            <c:if test="${not empty record.servicePhotos}">
                                <div class="record-photos">
                                    <c:forEach items="${record.photoList}" var="photo">
                                        <img src="${pageContext.request.contextPath}${photo}" class="record-photo" onclick="showImage(this.src)" alt="服务照片">
                                    </c:forEach>
                                </div>
                            </c:if>

                            <div class="record-actions">
                                <button class="btn btn-approve" onclick="approveRecord(${record.id})">审核通过</button>
                                <button class="btn btn-reject" onclick="showRejectModal(${record.id})">审核拒绝</button>
                                <a href="${pageContext.request.contextPath}/admin/care-plan/record/${record.id}" class="btn btn-detail">查看详情</a>
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
            <p style="color: #666; margin-bottom: 15px;">请填写拒绝原因，以便志愿者了解并改进</p>
            <textarea id="rejectRemark" placeholder="请输入拒绝原因..."></textarea>
            <div class="modal-actions">
                <button class="btn btn-detail" onclick="hideRejectModal()">取消</button>
                <button class="btn btn-reject" onclick="confirmReject()">确认拒绝</button>
            </div>
        </div>
    </div>

    <!-- 图片预览模态框 -->
    <div class="image-modal" id="imageModal" onclick="this.style.display='none'">
        <span class="modal-close">&times;</span>
        <img id="modalImage" src="" alt="预览">
    </div>

    <script>
        var currentRejectId = null;

        function approveRecord(recordId) {
            if (!confirm('确定要审核通过这条服务记录吗？')) {
                return;
            }

            var card = document.getElementById('record-' + recordId);
            var btns = card.querySelectorAll('.btn');
            btns.forEach(function(btn) { btn.disabled = true; });

            fetch('${pageContext.request.contextPath}/admin/care-plan/record/approve/' + recordId, {
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

        function showRejectModal(recordId) {
            currentRejectId = recordId;
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

            var card = document.getElementById('record-' + currentRejectId);
            var btns = card.querySelectorAll('.btn');
            btns.forEach(function(btn) { btn.disabled = true; });

            fetch('${pageContext.request.contextPath}/admin/care-plan/record/reject/' + currentRejectId, {
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

        function showImage(src) {
            document.getElementById('modalImage').src = src;
            document.getElementById('imageModal').style.display = 'flex';
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
