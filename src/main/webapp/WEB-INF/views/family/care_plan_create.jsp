<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>发布关爱计划</title>
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
            margin-bottom: 10px;
            font-size: 28px;
        }
        .subtitle {
            color: #666;
            margin-bottom: 30px;
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
            transition: border-color 0.3s;
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
        .hint {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        .section-title {
            font-size: 16px;
            color: #D32F2F;
            margin: 30px 0 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #FFF5F5;
        }
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: #D32F2F;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
        }
        .btn-submit:hover {
            background: #B71C1C;
        }
        .message {
            padding: 15px;
            margin: 15px 0;
            border-radius: 4px;
        }
        .message.error {
            background: #FFEBEE;
            color: #C62828;
            border-left: 4px solid #F44336;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/family/care-plan/list" class="back-btn">返回列表</a>

        <h1>发布关爱计划</h1>
        <p class="subtitle">为您的家人创建一个关爱计划，审核通过后志愿者可以认领并提供服务</p>

        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/family/care-plan/create" method="post">
            <div class="section-title">基本信息</div>

            <div class="form-group">
                <label><span class="required">*</span> 选择关爱对象</label>
                <select name="elderlyId" class="form-control" required>
                    <option value="">请选择需要照顾的关爱对象</option>
                    <c:forEach items="${elderlyList}" var="elderly">
                        <option value="${elderly.id}">${elderly.name} - ${elderly.age}岁</option>
                    </c:forEach>
                </select>
                <div class="hint">如果没有关爱对象信息，请先在"关爱对象管理"中添加</div>
            </div>

            <div class="form-group">
                <label><span class="required">*</span> 计划名称</label>
                <input type="text" name="planName" class="form-control" placeholder="例如：12月日常照料计划" required maxlength="100">
            </div>

            <div class="form-group">
                <label>计划描述</label>
                <textarea name="description" class="form-control" placeholder="详细描述您希望志愿者提供的服务内容和注意事项"></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>服务类型</label>
                    <select name="serviceType" class="form-control">
                        <option value="">请选择</option>
                        <option value="生活照料">生活照料</option>
                        <option value="陪伴聊天">陪伴聊天</option>
                        <option value="代购代办">代购代办</option>
                        <option value="健康监测">健康监测</option>
                        <option value="康复护理">康复护理</option>
                        <option value="其他服务">其他服务</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>服务频率</label>
                    <input type="text" name="serviceFrequency" class="form-control" placeholder="例如：每周3次">
                </div>
            </div>

            <div class="section-title">时间安排</div>

            <div class="form-row">
                <div class="form-group">
                    <label><span class="required">*</span> 开始日期</label>
                    <input type="date" name="startDate" class="form-control" required>
                </div>
                <div class="form-group">
                    <label><span class="required">*</span> 结束日期</label>
                    <input type="date" name="endDate" class="form-control" required>
                </div>
            </div>

            <div class="section-title">周期设置</div>

            <div class="form-row">
                <div class="form-group">
                    <label>周期类型</label>
                    <select name="periodType" class="form-control">
                        <option value="DAILY">每日</option>
                        <option value="WEEKLY" selected>每周</option>
                        <option value="MONTHLY">每月</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>每周期服务次数</label>
                    <input type="number" name="servicesPerPeriod" class="form-control" value="1" min="1" max="30">
                </div>
            </div>

            <div class="form-group">
                <label>总周期数</label>
                <input type="number" name="totalPeriods" class="form-control" value="4" min="1" max="52">
                <div class="hint">例如：每周服务3次，共4周，则总服务次数为12次</div>
            </div>

            <button type="submit" class="btn-submit">提交审核</button>
        </form>
    </div>

    <script>
        // 设置日期最小值为今天
        var today = new Date().toISOString().split('T')[0];
        document.querySelector('input[name="startDate"]').setAttribute('min', today);
        document.querySelector('input[name="endDate"]').setAttribute('min', today);

        // 开始日期变化时更新结束日期最小值
        document.querySelector('input[name="startDate"]').addEventListener('change', function() {
            document.querySelector('input[name="endDate"]').setAttribute('min', this.value);
        });
    </script>
</body>
</html>
