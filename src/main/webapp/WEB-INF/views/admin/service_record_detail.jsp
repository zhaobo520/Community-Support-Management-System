<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>服务记录详情</title>
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
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 4px;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid #D32F2F;
        }
        h1 {
            color: #D32F2F;
            margin-bottom: 30px;
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
        .back-btn:hover {
            background: #D32F2F;
            color: white;
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
        .section {
            margin-bottom: 30px;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 4px;
        }
        .section-title {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #D32F2F;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }
        .info-item {
            font-size: 14px;
        }
        .info-item .label {
            color: #999;
            margin-bottom: 5px;
        }
        .info-item .value {
            color: #333;
            font-weight: 500;
        }
        .info-item.full-width {
            grid-column: 1 / -1;
        }
        .content-box {
            background: white;
            padding: 15px;
            border-radius: 4px;
            border: 1px solid #e0e0e0;
            line-height: 1.8;
            color: #666;
        }
        .photo-gallery {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 10px;
        }
        .photo-item {
            width: 150px;
            height: 150px;
            border-radius: 4px;
            overflow: hidden;
            border: 2px solid #e0e0e0;
            cursor: pointer;
            transition: all 0.3s;
        }
        .photo-item:hover {
            border-color: #D32F2F;
            transform: scale(1.05);
        }
        .photo-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .audit-form {
            margin-top: 30px;
            padding: 25px;
            background: #FFF5F5;
            border-radius: 4px;
            border: 2px solid #D32F2F;
        }
        .audit-form h3 {
            color: #D32F2F;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            min-height: 100px;
            font-size: 14px;
        }
        .form-group textarea:focus {
            outline: none;
            border-color: #D32F2F;
        }
        .radio-group {
            display: flex;
            gap: 30px;
        }
        .radio-item {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }
        .radio-item input[type="radio"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: #D32F2F;
            color: white;
        }
        .btn-primary:hover {
            background: #B71C1C;
        }
        .btn-secondary {
            background: white;
            color: #666;
            border: 2px solid #e0e0e0;
        }
        .btn-secondary:hover {
            border-color: #999;
        }
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 2px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-pending { background: #FFF3E0; color: #E65100; }
        .badge-approved { background: #E8F5E9; color: #2E7D32; }
        .badge-rejected { background: #FFEBEE; color: #C62828; }
        /* 图片预览模态框 */
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
        <a href="${pageContext.request.contextPath}/admin/care-plan/records/pending" class="back-btn">返回待审核列表</a>

        <h1>服务记录详情</h1>

        <c:if test="${not empty success}">
            <div class="message success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>

        <!-- 服务记录基本信息 -->
        <div class="section">
            <div class="section-title">服务记录信息</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="label">所属计划</div>
                    <div class="value">${record.planName}</div>
                </div>
                <div class="info-item">
                    <div class="label">当前状态</div>
                    <div class="value">
                        <c:choose>
                            <c:when test="${record.auditStatus == 'PENDING'}">
                                <span class="badge badge-pending">待审核</span>
                            </c:when>
                            <c:when test="${record.auditStatus == 'APPROVED'}">
                                <span class="badge badge-approved">已通过</span>
                            </c:when>
                            <c:when test="${record.auditStatus == 'REJECTED'}">
                                <span class="badge badge-rejected">已拒绝</span>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
                <div class="info-item">
                    <div class="label">服务周期</div>
                    <div class="value">第${record.periodNumber}周期 第${record.serviceNumber}次服务</div>
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
                <div class="info-item">
                    <div class="label">提交时间</div>
                    <div class="value"><fmt:formatDate value="${record.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
                </div>
            </div>
        </div>

        <!-- 志愿者信息 -->
        <div class="section">
            <div class="section-title">志愿者信息</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="label">志愿者姓名</div>
                    <div class="value">${record.volunteerName}</div>
                </div>
                <div class="info-item">
                    <div class="label">关爱对象</div>
                    <div class="value">${record.elderlyName}</div>
                </div>
            </div>
        </div>

        <!-- 服务内容 -->
        <div class="section">
            <div class="section-title">服务内容</div>
            <div class="content-box">${record.serviceContent}</div>
        </div>

        <!-- 关爱对象状况 -->
        <c:if test="${not empty record.elderlyCondition}">
            <div class="section">
                <div class="section-title">关爱对象状况</div>
                <div class="content-box">${record.elderlyCondition}</div>
            </div>
        </c:if>

        <!-- 服务照片 -->
        <c:if test="${not empty record.servicePhotos}">
            <div class="section">
                <div class="section-title">服务照片</div>
                <div class="photo-gallery">
                    <c:forEach items="${record.photoList}" var="photo">
                        <div class="photo-item" onclick="showImage('${pageContext.request.contextPath}${photo}')">
                            <img src="${pageContext.request.contextPath}${photo}" alt="服务照片">
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- 备注 -->
        <c:if test="${not empty record.remarks}">
            <div class="section">
                <div class="section-title">备注</div>
                <div class="content-box">${record.remarks}</div>
            </div>
        </c:if>

        <!-- 审核信息（如果已审核） -->
        <c:if test="${record.auditStatus != 'PENDING'}">
            <div class="section">
                <div class="section-title">审核信息</div>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="label">审核人</div>
                        <div class="value">${record.auditorName}</div>
                    </div>
                    <div class="info-item">
                        <div class="label">审核时间</div>
                        <div class="value"><fmt:formatDate value="${record.auditTime}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
                    </div>
                    <c:if test="${not empty record.auditRemark}">
                        <div class="info-item full-width">
                            <div class="label">审核备注</div>
                            <div class="content-box">${record.auditRemark}</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>

        <!-- 审核表单（仅待审核状态显示） -->
        <c:if test="${record.auditStatus == 'PENDING'}">
            <form action="${pageContext.request.contextPath}/admin/care-plan/record/audit/${record.id}" method="post" class="audit-form">
                <h3>审核操作</h3>

                <div class="form-group">
                    <label>审核结果</label>
                    <div class="radio-group">
                        <label class="radio-item">
                            <input type="radio" name="auditStatus" value="APPROVED" checked>
                            <span style="color: #4CAF50; font-weight: bold;">审核通过</span>
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="auditStatus" value="REJECTED">
                            <span style="color: #F44336; font-weight: bold;">审核拒绝</span>
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <label>审核备注（拒绝时必填）</label>
                    <textarea name="auditRemark" placeholder="请输入审核备注..."></textarea>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">提交审核</button>
                    <a href="${pageContext.request.contextPath}/admin/care-plan/records/pending" class="btn btn-secondary">取消</a>
                </div>
            </form>
        </c:if>
    </div>

    <!-- 图片预览模态框 -->
    <div class="image-modal" id="imageModal" onclick="this.style.display='none'">
        <span class="modal-close">&times;</span>
        <img id="modalImage" src="" alt="预览">
    </div>

    <script>
        function showImage(src) {
            document.getElementById('modalImage').src = src;
            document.getElementById('imageModal').style.display = 'flex';
        }

        // 表单验证
        var form = document.querySelector('form');
        if (form) {
            form.addEventListener('submit', function(e) {
                var status = document.querySelector('input[name="auditStatus"]:checked').value;
                var remark = document.querySelector('textarea[name="auditRemark"]').value.trim();

                if (status === 'REJECTED' && !remark) {
                    e.preventDefault();
                    alert('拒绝时必须填写审核备注');
                    return false;
                }

                var confirmMsg = status === 'APPROVED' ? '确定要审核通过这条服务记录吗？' : '确定要拒绝这条服务记录吗？';
                if (!confirm(confirmMsg)) {
                    e.preventDefault();
                    return false;
                }
            });
        }
    </script>
</body>
</html>
