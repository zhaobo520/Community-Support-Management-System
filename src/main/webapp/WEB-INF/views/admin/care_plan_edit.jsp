<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑关爱计划 - 管理员</title>
    <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body {
            background: #FAF5F0;
            margin: 0;
            padding: 0;
            font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        }
        .gov-header {
            background: linear-gradient(135deg, #B71C1C 0%, #D32F2F 100%);
            height: 64px;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 12px rgba(0,0,0,0.15);
        }
        .gov-header h1 {
            color: white;
            font-size: 18px;
            font-weight: 600;
            margin: 0;
        }
        .gov-header .nav-right a {
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 13px;
        }
        .gov-header .nav-right a:hover {
            background: rgba(255,255,255,0.15);
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 24px;
        }
        .page-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        .page-title h2 {
            font-size: 24px;
            color: #333;
            margin: 0;
        }
        .btn-back {
            padding: 8px 16px;
            background: white;
            color: #666;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
        }
        .form-card {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
        }
        .form-section {
            margin-bottom: 24px;
            padding-bottom: 24px;
            border-bottom: 1px solid #f0f0f0;
        }
        .form-section:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }
        .form-section h3 {
            font-size: 16px;
            color: #333;
            margin: 0 0 16px 0;
            padding-left: 12px;
            border-left: 3px solid #D32F2F;
        }
        .form-group {
            margin-bottom: 16px;
        }
        .form-group label {
            display: block;
            font-size: 14px;
            color: #333;
            margin-bottom: 6px;
            font-weight: 500;
        }
        .form-group label .required {
            color: #D32F2F;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #D32F2F;
        }
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .form-hint {
            font-size: 12px;
            color: #999;
            margin-top: 4px;
        }
        .btn-submit {
            width: 100%;
            padding: 14px;
            background: #D32F2F;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-submit:hover {
            background: #B71C1C;
        }
        .alert {
            padding: 12px 16px;
            border-radius: 4px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-error {
            background: #fee2e2;
            color: #dc2626;
        }
    </style>
</head>
<body>

<header class="gov-header">
    <h1>编辑关爱计划</h1>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/admin/care-plan/detail/${plan.id}">返回详情</a>
    </div>
</header>

<div class="container">
    <div class="page-title">
        <h2>编辑计划</h2>
        <a href="${pageContext.request.contextPath}/admin/care-plan/detail/${plan.id}" class="btn-back">← 返回</a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <div class="form-card">
        <form action="${pageContext.request.contextPath}/admin/care-plan/edit" method="post">
            <input type="hidden" name="id" value="${plan.id}">

            <div class="form-section">
                <h3>基本信息</h3>
                <div class="form-group">
                    <label>计划名称 <span class="required">*</span></label>
                    <input type="text" name="planName" value="${plan.planName}" required>
                </div>
                <div class="form-group">
                    <label>计划描述</label>
                    <textarea name="description">${plan.description}</textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>服务类型</label>
                        <select name="serviceType">
                            <option value="">请选择服务类型</option>
                            <option value="生活照料" ${plan.serviceType == '生活照料' ? 'selected' : ''}>生活照料</option>
                            <option value="健康护理" ${plan.serviceType == '健康护理' ? 'selected' : ''}>健康护理</option>
                            <option value="精神慰藉" ${plan.serviceType == '精神慰藉' ? 'selected' : ''}>精神慰藉</option>
                            <option value="家政服务" ${plan.serviceType == '家政服务' ? 'selected' : ''}>家政服务</option>
                            <option value="陪同就医" ${plan.serviceType == '陪同就医' ? 'selected' : ''}>陪同就医</option>
                            <option value="代购代办" ${plan.serviceType == '代购代办' ? 'selected' : ''}>代购代办</option>
                            <option value="综合服务" ${plan.serviceType == '综合服务' ? 'selected' : ''}>综合服务</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>服务频率</label>
                        <select name="serviceFrequency">
                            <option value="">请选择服务频率</option>
                            <option value="每天1次" ${plan.serviceFrequency == '每天1次' ? 'selected' : ''}>每天1次</option>
                            <option value="每周1次" ${plan.serviceFrequency == '每周1次' ? 'selected' : ''}>每周1次</option>
                            <option value="每周2次" ${plan.serviceFrequency == '每周2次' ? 'selected' : ''}>每周2次</option>
                            <option value="每周3次" ${plan.serviceFrequency == '每周3次' ? 'selected' : ''}>每周3次</option>
                            <option value="每月2次" ${plan.serviceFrequency == '每月2次' ? 'selected' : ''}>每月2次</option>
                            <option value="每月4次" ${plan.serviceFrequency == '每月4次' ? 'selected' : ''}>每月4次</option>
                            <option value="按需服务" ${plan.serviceFrequency == '按需服务' ? 'selected' : ''}>按需服务</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <h3>时间与次数</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label>开始日期 <span class="required">*</span></label>
                        <input type="date" name="startDate" value="<fmt:formatDate value='${plan.startDate}' pattern='yyyy-MM-dd'/>" required>
                    </div>
                    <div class="form-group">
                        <label>结束日期 <span class="required">*</span></label>
                        <input type="date" name="endDate" value="<fmt:formatDate value='${plan.endDate}' pattern='yyyy-MM-dd'/>" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>计划总服务次数 <span class="required">*</span></label>
                        <input type="number" name="totalServices" value="${plan.totalServices}" min="1" required>
                    </div>
                    <div class="form-group">
                        <label>已完成次数</label>
                        <input type="number" name="completedServices" value="${plan.completedServices != null ? plan.completedServices : 0}" min="0">
                        <div class="form-hint">当前进度：${plan.progressPercentage}%</div>
                    </div>
                </div>
                <div class="form-group">
                    <label>计划状态</label>
                    <select name="status">
                        <option value="ACTIVE" ${plan.status == 'ACTIVE' ? 'selected' : ''}>进行中</option>
                        <option value="COMPLETED" ${plan.status == 'COMPLETED' ? 'selected' : ''}>已完成</option>
                        <option value="CANCELLED" ${plan.status == 'CANCELLED' ? 'selected' : ''}>已取消</option>
                    </select>
                </div>
            </div>

            <div class="form-section">
                <h3>关联信息</h3>
                <div class="form-group">
                    <label>选择家属 <span class="required">*</span></label>
                    <select name="familyUserId" id="familySelect" required onchange="loadElderlyList()">
                        <option value="">请选择家属</option>
                        <c:forEach items="${familyUsers}" var="family">
                            <option value="${family.id}" ${plan.familyUserId == family.id ? 'selected' : ''}>
                                ${family.fullName} (${family.phone})
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>选择关爱对象</label>
                    <select name="elderlyId" id="elderlySelect">
                        <option value="">请选择关爱对象</option>
                        <c:forEach items="${elderlyList}" var="elderly">
                            <option value="${elderly.id}" ${plan.elderlyId == elderly.id ? 'selected' : ''}>
                                ${elderly.name}
                                <c:if test="${not empty elderly.age}"> (${elderly.age}岁)</c:if>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>分配志愿者</label>
                    <select name="assignedVolunteerId">
                        <option value="">暂不分配</option>
                        <c:forEach items="${volunteers}" var="volunteer">
                            <option value="${volunteer.userId}" ${plan.assignedVolunteerId == volunteer.userId ? 'selected' : ''}>
                                ${volunteer.fullName} (${volunteer.phone})
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <button type="submit" class="btn-submit">保存修改</button>
        </form>
    </div>
</div>

<script>
    function loadElderlyList() {
        var familyId = document.getElementById('familySelect').value;
        var elderlySelect = document.getElementById('elderlySelect');
        var currentElderlyId = '${plan.elderlyId}';

        if (!familyId) {
            elderlySelect.innerHTML = '<option value="">请先选择家属</option>';
            return;
        }

        elderlySelect.innerHTML = '<option value="">加载中...</option>';

        fetch('${pageContext.request.contextPath}/admin/care-plan/elderly-by-family/' + familyId)
            .then(response => response.json())
            .then(data => {
                var options = '<option value="">请选择关爱对象</option>';
                if (data && data.length > 0) {
                    data.forEach(function(elderly) {
                        var selected = (elderly.id == currentElderlyId) ? ' selected' : '';
                        options += '<option value="' + elderly.id + '"' + selected + '>' + elderly.name;
                        if (elderly.age) {
                            options += ' (' + elderly.age + '岁)';
                        }
                        options += '</option>';
                    });
                } else {
                    options = '<option value="">该家属暂无关爱对象</option>';
                }
                elderlySelect.innerHTML = options;
            })
            .catch(error => {
                console.error('Error:', error);
                elderlySelect.innerHTML = '<option value="">加载失败</option>';
            });
    }
</script>
</body>
</html>
