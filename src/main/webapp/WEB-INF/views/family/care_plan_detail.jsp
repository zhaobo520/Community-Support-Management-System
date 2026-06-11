<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>关爱计划详情</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #FAF5F0;
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1000px;
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
        .back-btn {
            display: inline-block;
            padding: 10px 20px;
            background: white;
            color: #D32F2F;
            text-decoration: none;
            border-radius: 2px;
            border: 2px solid #D32F2F;
            margin-bottom: 20px;
        }
        .status-badges {
            margin: 15px 0;
        }
        .badge {
            display: inline-block;
            padding: 6px 15px;
            border-radius: 2px;
            font-size: 14px;
            font-weight: bold;
            margin-right: 10px;
        }
        .badge-pending { background: #FFF3E0; color: #E65100; }
        .badge-approved { background: #FBE9E7; color: #B71C1C; }
        .badge-rejected { background: #FFEBEE; color: #C62828; }
        .badge-active { background: #FBE9E7; color: #B71C1C; }
        .badge-completed { background: #E0E0E0; color: #424242; }
        .badge-unclaimed { background: #FFF8E1; color: #F57F17; }
        .badge-claimed { background: #FBE9E7; color: #B71C1C; }
        .info-section {
            background: #FFF5F5;
            border-radius: 4px;
            padding: 20px;
            margin: 20px 0;
            border-left: 4px solid #D32F2F;
        }
        .info-section h3 {
            color: #D32F2F;
            margin-bottom: 15px;
            font-size: 16px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .info-item {
            font-size: 14px;
        }
        .info-item .label {
            color: #666;
            margin-bottom: 5px;
        }
        .info-item .value {
            color: #333;
            font-weight: bold;
        }
        .progress-section {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            padding: 20px;
            margin: 20px 0;
        }
        .progress-section h3 {
            color: #333;
            margin-bottom: 15px;
        }
        .progress-bar {
            height: 20px;
            background: #e0e0e0;
            border-radius: 10px;
            overflow: hidden;
            margin: 10px 0;
        }
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #D32F2F, #F44336);
            transition: width 0.5s;
        }
        .progress-stats {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: #666;
        }
        .records-section {
            margin-top: 30px;
        }
        .records-section h3 {
            color: #D32F2F;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #FFF5F5;
        }
        .record-card {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            padding: 20px;
            margin-bottom: 15px;
        }
        .record-card:hover {
            border-color: #D32F2F;
        }
        .record-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .record-date {
            font-weight: bold;
            color: #333;
        }
        .record-status {
            padding: 4px 10px;
            border-radius: 2px;
            font-size: 12px;
        }
        .record-content {
            color: #666;
            font-size: 14px;
            margin: 10px 0;
        }
        .record-photos {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 10px;
        }
        .record-photo {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 4px;
            cursor: pointer;
        }
        .volunteer-info {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px;
            background: #FAF5F0;
            border-radius: 4px;
            margin: 15px 0;
        }
        .volunteer-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            background: #D32F2F;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
        }
        .volunteer-details h4 {
            color: #333;
            margin-bottom: 5px;
        }
        .volunteer-details p {
            color: #666;
            font-size: 14px;
        }
        .empty-records {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        .message {
            padding: 15px;
            margin: 15px 0;
            border-radius: 4px;
        }
        .message.success {
            background: #FBE9E7;
            color: #B71C1C;
            border-left: 4px solid #D32F2F;
        }
        .message.error {
            background: #FFEBEE;
            color: #C62828;
            border-left: 4px solid #F44336;
        }
        /* 图片预览模态框 */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.9);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .modal img {
            max-width: 90%;
            max-height: 90%;
        }
        .modal-close {
            position: absolute;
            top: 20px;
            right: 30px;
            color: white;
            font-size: 30px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/family/care-plan/list" class="back-btn">返回列表</a>

        <h1>${plan.planName}</h1>

        <div class="status-badges">
            <span class="badge badge-${plan.auditStatus.toLowerCase()}">${plan.auditStatusText}</span>
            <c:if test="${plan.auditStatus == 'APPROVED'}">
                <span class="badge badge-${plan.claimStatus.toLowerCase()}">${plan.claimStatusText}</span>
            </c:if>
            <span class="badge badge-${plan.status.toLowerCase()}">${plan.statusText}</span>
        </div>

        <c:if test="${not empty message}">
            <div class="message success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>

        <div class="info-section">
            <h3>计划信息</h3>
            <div class="info-grid">
                <div class="info-item">
                    <div class="label">关爱对象姓名</div>
                    <div class="value">${plan.elderlyName}</div>
                </div>
                <div class="info-item">
                    <div class="label">服务类型</div>
                    <div class="value">${plan.serviceType}</div>
                </div>
                <div class="info-item">
                    <div class="label">服务频率</div>
                    <div class="value">${plan.serviceFrequency}</div>
                </div>
                <div class="info-item">
                    <div class="label">周期类型</div>
                    <div class="value">${plan.periodTypeText}</div>
                </div>
                <div class="info-item">
                    <div class="label">开始日期</div>
                    <div class="value"><fmt:formatDate value="${plan.startDate}" pattern="yyyy-MM-dd"/></div>
                </div>
                <div class="info-item">
                    <div class="label">结束日期</div>
                    <div class="value"><fmt:formatDate value="${plan.endDate}" pattern="yyyy-MM-dd"/></div>
                </div>
                <div class="info-item">
                    <div class="label">每周期服务次数</div>
                    <div class="value">${plan.servicesPerPeriod} 次</div>
                </div>
                <div class="info-item">
                    <div class="label">总周期数</div>
                    <div class="value">${plan.totalPeriods} 个周期</div>
                </div>
            </div>
            <c:if test="${not empty plan.description}">
                <div style="margin-top: 15px;">
                    <div class="label">计划描述</div>
                    <div class="value" style="font-weight: normal; line-height: 1.6;">${plan.description}</div>
                </div>
            </c:if>
        </div>

        <c:if test="${plan.auditStatus == 'REJECTED'}">
            <div class="info-section" style="border-left-color: #F44336;">
                <h3 style="color: #F44336;">审核拒绝原因</h3>
                <p>${plan.auditRemark}</p>
            </div>
        </c:if>

        <c:if test="${plan.claimStatus == 'CLAIMED' && not empty plan.volunteerName}">
            <div class="volunteer-info">
                <c:choose>
                    <c:when test="${not empty plan.volunteerAvatar}">
                        <img src="${pageContext.request.contextPath}${plan.volunteerAvatar}" class="volunteer-avatar" style="object-fit: cover;" alt="头像">
                    </c:when>
                    <c:otherwise>
                        <div class="volunteer-avatar">${plan.volunteerName.substring(0,1)}</div>
                    </c:otherwise>
                </c:choose>
                <div class="volunteer-details">
                    <h4>服务志愿者：${plan.volunteerName}</h4>
                    <p>联系电话：${plan.volunteerPhone}</p>
                    <p>认领时间：<fmt:formatDate value="${plan.claimedTime}" pattern="yyyy-MM-dd HH:mm"/></p>
                </div>
            </div>
        </c:if>

        <c:if test="${plan.claimStatus == 'CLAIMED'}">
            <div class="progress-section">
                <h3>服务进度</h3>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: ${plan.progressPercentage}%"></div>
                </div>
                <div class="progress-stats">
                    <span>已完成：${plan.approvedServices} 次</span>
                    <span>待审核：${plan.completedServices - plan.approvedServices} 次</span>
                    <span>总计：${plan.totalServices} 次</span>
                </div>
            </div>
        </c:if>

        <div class="records-section">
            <h3>服务记录</h3>
            <c:choose>
                <c:when test="${empty records}">
                    <div class="empty-records">
                        <p>暂无服务记录</p>
                        <c:if test="${plan.claimStatus == 'UNCLAIMED'}">
                            <p style="margin-top: 10px;">等待志愿者认领后开始服务</p>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${records}" var="record">
                        <div class="record-card">
                            <div class="record-header">
                                <div class="record-date">
                                    第${record.periodNumber}周期 第${record.serviceNumber}次服务 -
                                    <fmt:formatDate value="${record.serviceDate}" pattern="yyyy-MM-dd"/>
                                    <c:if test="${not empty record.serviceTimeStart}">
                                        ${record.serviceTimeStart} - ${record.serviceTimeEnd}
                                    </c:if>
                                </div>
                                <span class="record-status badge-${record.auditStatus.toLowerCase()}">${record.auditStatusText}</span>
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
                            <div style="margin-top: 10px; font-size: 12px; color: #999;">
                                提交时间：<fmt:formatDate value="${record.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                <c:if test="${record.auditStatus != 'PENDING'}">
                                    | 审核时间：<fmt:formatDate value="${record.auditTime}" pattern="yyyy-MM-dd HH:mm"/>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 图片预览模态框 -->
    <div class="modal" id="imageModal" onclick="this.style.display='none'">
        <span class="modal-close">&times;</span>
        <img id="modalImage" src="" alt="预览">
    </div>

    <script>
        function showImage(src) {
            document.getElementById('modalImage').src = src;
            document.getElementById('imageModal').style.display = 'flex';
        }
    </script>
</body>
</html>

