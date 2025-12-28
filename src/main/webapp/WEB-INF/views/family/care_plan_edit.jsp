<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>编辑关爱计划</title>
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
            max-width: 800px;
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
            font-size: 24px;
        }
        .back-btn {
            display: inline-block;
            padding: 10px 20px;
            background: white;
            color: #D32F2F;
            text-decoration: none;
            border-radius: 4px;
            border: 2px solid #D32F2F;
            margin-bottom: 20px;
        }
        .back-btn:hover {
            background: #D32F2F;
            color: white;
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
        .form-group label .required {
            color: #D32F2F;
        }
        .form-control {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-control:focus {
            outline: none;
            border-color: #D32F2F;
        }
        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .btn-submit {
            background: #D32F2F;
            color: white;
            padding: 14px 40px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 20px;
        }
        .btn-submit:hover {
            background: #B71C1C;
        }
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .message.error {
            background: #FFEBEE;
            color: #C62828;
            border-left: 4px solid #F44336;
        }
        .message.success {
            background: #E8F5E9;
            color: #2E7D32;
            border-left: 4px solid #4CAF50;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/family/care-plan/list" class="back-btn">返回列表</a>

        <h1>编辑关爱计划</h1>

        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="message success">${message}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/family/care-plan/edit/${plan.id}" method="post">
            <div class="form-group">
                <label>关爱对象 <span class="required">*</span></label>
                <select name="elderlyId" class="form-control" required>
                    <option value="">请选择关爱对象</option>
                    <c:forEach items="${elderlyList}" var="elderly">
                        <option value="${elderly.id}" ${plan.elderlyId == elderly.id ? 'selected' : ''}>${elderly.name} - ${elderly.age}岁</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>计划名称 <span class="required">*</span></label>
                <input type="text" name="planName" class="form-control" value="${plan.planName}" required placeholder="请输入计划名称">
            </div>

            <div class="form-group">
                <label>计划描述</label>
                <textarea name="description" class="form-control" placeholder="请描述关爱计划的具体内容和目标">${plan.description}</textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>服务类型</label>
                    <input type="text" name="serviceType" class="form-control" value="${plan.serviceType}" placeholder="如：生活照料、健康护理">
                </div>
                <div class="form-group">
                    <label>服务频率</label>
                    <input type="text" name="serviceFrequency" class="form-control" value="${plan.serviceFrequency}" placeholder="如：每周3次">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>开始日期</label>
                    <input type="date" name="startDate" class="form-control" value="<fmt:formatDate value='${plan.startDate}' pattern='yyyy-MM-dd'/>">
                </div>
                <div class="form-group">
                    <label>结束日期</label>
                    <input type="date" name="endDate" class="form-control" value="<fmt:formatDate value='${plan.endDate}' pattern='yyyy-MM-dd'/>">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>周期类型</label>
                    <select name="periodType" class="form-control">
                        <option value="DAILY" ${plan.periodType == 'DAILY' ? 'selected' : ''}>每日</option>
                        <option value="WEEKLY" ${plan.periodType == 'WEEKLY' || empty plan.periodType ? 'selected' : ''}>每周</option>
                        <option value="MONTHLY" ${plan.periodType == 'MONTHLY' ? 'selected' : ''}>每月</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>每周期服务次数</label>
                    <input type="number" name="servicesPerPeriod" class="form-control" value="${plan.servicesPerPeriod != null ? plan.servicesPerPeriod : 1}" min="1">
                </div>
            </div>

            <div class="form-group">
                <label>总周期数</label>
                <input type="number" name="totalPeriods" class="form-control" value="${plan.totalPeriods != null ? plan.totalPeriods : 1}" min="1">
            </div>

            <button type="submit" class="btn-submit">保存修改</button>
        </form>
    </div>
</body>
</html>
