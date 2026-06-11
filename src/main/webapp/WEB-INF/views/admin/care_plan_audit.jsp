<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>审核关爱计划</title>
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
            background: #FBE9E7;
            color: #B71C1C;
            border-left: 4px solid #D32F2F;
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
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/admin/care-plan/pending" class="back-btn">返回待审核列表</a>

        <h1>审核关爱计划</h1>

        <c:if test="${not empty success}">
            <div class="message success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>

        <!-- 计划基本信息 -->
        <div class="section">
            <div class="section-title">计划基本信息</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="label">计划名称</div>
                    <div class="value">${plan.planName}</div>
                </div>
                <div class="info-item">
                    <div class="label">当前状态</div>
                    <div class="value"><span class="badge badge-pending">待审核</span></div>
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
                    <div class="value">共${plan.totalPeriods}个周期，每周期${plan.servicesPerPeriod}次服务</div>
                </div>
                <div class="info-item">
                    <div class="label">提交时间</div>
                    <div class="value"><fmt:formatDate value="${plan.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
                </div>
            </div>
            <c:if test="${not empty plan.serviceContent}">
                <div class="info-item full-width" style="margin-top: 15px;">
                    <div class="label">服务内容</div>
                    <div class="content-box">${plan.serviceContent}</div>
                </div>
            </c:if>
        </div>

        <!-- 关爱对象信息 -->
        <c:if test="${elderlyInfo != null}">
            <div class="section">
                <div class="section-title">关爱对象信息</div>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="label">姓名</div>
                        <div class="value">${elderlyInfo.name}</div>
                    </div>
                    <div class="info-item">
                        <div class="label">年龄</div>
                        <div class="value">${elderlyInfo.age}岁</div>
                    </div>
                    <div class="info-item">
                        <div class="label">性别</div>
                        <div class="value">${elderlyInfo.gender == 1 ? '男' : '女'}</div>
                    </div>
                    <div class="info-item">
                        <div class="label">关爱等级</div>
                        <div class="value">${elderlyInfo.careLevel}</div>
                    </div>
                    <div class="info-item full-width">
                        <div class="label">居住地址</div>
                        <div class="value">${elderlyInfo.address}</div>
                    </div>
                    <c:if test="${not empty elderlyInfo.healthCondition}">
                        <div class="info-item full-width">
                            <div class="label">健康状况</div>
                            <div class="content-box">${elderlyInfo.healthCondition}</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>

        <!-- 申请家属信息 -->
        <c:if test="${familyUser != null}">
            <div class="section">
                <div class="section-title">申请家属信息</div>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="label">姓名</div>
                        <div class="value">${familyUser.fullName}</div>
                    </div>
                    <div class="info-item">
                        <div class="label">联系电话</div>
                        <div class="value">${familyUser.phone}</div>
                    </div>
                    <div class="info-item">
                        <div class="label">用户名</div>
                        <div class="value">${familyUser.username}</div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- 审核表单 -->
        <form action="${pageContext.request.contextPath}/admin/care-plan/audit/${plan.id}" method="post" class="audit-form">
            <h3>审核操作</h3>

            <div class="form-group">
                <label>审核结果</label>
                <div class="radio-group">
                    <label class="radio-item">
                        <input type="radio" name="auditStatus" value="APPROVED" checked>
                        <span style="color: #D32F2F; font-weight: bold;">审核通过</span>
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
                <a href="${pageContext.request.contextPath}/admin/care-plan/pending" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>

    <script>
        // 表单验证
        document.querySelector('form').addEventListener('submit', function(e) {
            var status = document.querySelector('input[name="auditStatus"]:checked').value;
            var remark = document.querySelector('textarea[name="auditRemark"]').value.trim();

            if (status === 'REJECTED' && !remark) {
                e.preventDefault();
                alert('拒绝时必须填写审核备注');
                return false;
            }

            var confirmMsg = status === 'APPROVED' ? '确定要审核通过这个关爱计划吗？' : '确定要拒绝这个关爱计划吗？';
            if (!confirm(confirmMsg)) {
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>

