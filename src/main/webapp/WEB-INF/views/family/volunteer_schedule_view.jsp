<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>志愿者排班查看</title>
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
        .volunteer-selector {
            margin: 20px 0;
            padding: 20px;
            background: #FFF5F5;
            border-radius: 4px;
            border-left: 4px solid #D32F2F;
        }
        .volunteer-selector label {
            font-weight: bold;
            margin-right: 10px;
        }
        .volunteer-selector select {
            padding: 8px 15px;
            border: 2px solid #D32F2F;
            border-radius: 2px;
            font-size: 14px;
            min-width: 200px;
        }
        .hint {
            color: #666;
            font-size: 14px;
            margin: 15px 0;
            padding: 12px;
            background: #FFF5F5;
            border-left: 4px solid #D32F2F;
            border-radius: 2px;
        }
        .schedule-grid {
            margin: 30px 0;
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }
        th, td {
            border: 2px solid #e0e0e0;
            padding: 20px;
            text-align: center;
        }
        th {
            background: #D32F2F;
            color: white;
            font-weight: bold;
        }
        td {
            background: #fafafa;
        }
        td.available {
            background: #D32F2F;
            color: white;
        }
        td.available::after {
            content: '';
            font-size: 24px;
            display: block;
        }
        .legend {
            margin-top: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 4px;
            border-left: 4px solid #D32F2F;
        }
        .legend-item {
            display: inline-block;
            margin-right: 20px;
        }
        .legend-box {
            display: inline-block;
            width: 20px;
            height: 20px;
            margin-right: 5px;
            vertical-align: middle;
            border-radius: 3px;
        }
        .legend-box.available {
            background: #ff8a95;
        }
        .legend-box.unavailable {
            background: #fafafa;
            border: 2px solid #e0e0e0;
        }
        /* 右上角小表格 */
        .summary-widget {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            border-radius: 12px;
            padding: 15px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.2);
            z-index: 1000;
            max-width: 380px;
        }
        .summary-widget h3 {
            font-size: 14px;
            color: #f5576c;
            margin-bottom: 10px;
            font-weight: bold;
        }
        .summary-grid {
            display: grid;
            grid-template-columns: 50px repeat(7, 1fr);
            gap: 3px;
            font-size: 10px;
        }
        .summary-grid .header {
            background: #ffe5e9;
            padding: 5px 3px;
            text-align: center;
            border-radius: 3px;
            font-weight: 600;
            color: #f5576c;
        }
        .summary-grid .cell {
            background: #f8f9fa;
            padding: 8px 3px;
            text-align: center;
            border-radius: 3px;
            min-height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 9px;
            color: #999;
        }
        .summary-grid .cell.has-volunteer {
            background: #ff8a95;
            color: white;
            font-weight: 600;
            cursor: pointer;
            position: relative;
        }
        .summary-grid .cell.has-volunteer:hover::after {
            content: attr(data-volunteers);
            position: absolute;
            top: -5px;
            right: 105%;
            background: #333;
            color: white;
            padding: 6px 10px;
            border-radius: 5px;
            white-space: nowrap;
            font-size: 10px;
            z-index: 1001;
            box-shadow: 0 3px 10px rgba(0,0,0,0.3);
        }
    </style>
</head>
<body>
<!-- 右上角值班汇总小表格 -->
<div class="summary-widget">
    <h3>📅 当前值班情况</h3>
    <div class="summary-grid">
        <div class="header"></div>
        <div class="header">周一</div>
        <div class="header">周二</div>
        <div class="header">周三</div>
        <div class="header">周四</div>
        <div class="header">周五</div>
        <div class="header">周六</div>
        <div class="header">周日</div>
        
        <div class="header">上午</div>
        <c:forEach var="day" begin="1" end="7">
            <c:set var="key" value="${day}_MORNING"/>
            <c:choose>
                <c:when test="${not empty volunteerSummary[key]}">
                    <c:set var="names" value="${String.join(', ', volunteerSummary[key])}"/>
                    <div class="cell has-volunteer" data-volunteers="${names}">
                        ${volunteerSummary[key].size()}人
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="cell">-</div>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        
        <div class="header">下午</div>
        <c:forEach var="day" begin="1" end="7">
            <c:set var="key" value="${day}_AFTERNOON"/>
            <c:choose>
                <c:when test="${not empty volunteerSummary[key]}">
                    <c:set var="names" value="${String.join(', ', volunteerSummary[key])}"/>
                    <div class="cell has-volunteer" data-volunteers="${names}">
                        ${volunteerSummary[key].size()}人
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="cell">-</div>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        
        <div class="header">晚上</div>
        <c:forEach var="day" begin="1" end="7">
            <c:set var="key" value="${day}_EVENING"/>
            <c:choose>
                <c:when test="${not empty volunteerSummary[key]}">
                    <c:set var="names" value="${String.join(', ', volunteerSummary[key])}"/>
                    <div class="cell has-volunteer" data-volunteers="${names}">
                        ${volunteerSummary[key].size()}人
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="cell">-</div>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>
</div>

<div class="container">
    <a href="${pageContext.request.contextPath}/user/family/dashboard" class="back-btn">← 返回家属中心</a>
    
    <h1>📅 志愿者排班查看</h1>
    
    <div class="volunteer-selector">
        <label>选择志愿者：</label>
        <select id="volunteerSelect" onchange="changeVolunteer()">
            <c:forEach items="${volunteers}" var="vol">
                <option value="${vol.id}" ${vol.id == selectedVolunteerId ? 'selected' : ''}>
                    ${vol.fullName} (${vol.username})
                </option>
            </c:forEach>
        </select>
    </div>

    <div class="hint">
        📖 此页面仅供查看志愿者的可服务时间，方便您安排与志愿者的协作时间。显示的时段均为志愿者已确认的可服务时间。
    </div>

    <div class="schedule-grid">
        <table>
            <thead>
                <tr>
                    <th></th>
                    <th>周一</th>
                    <th>周二</th>
                    <th>周三</th>
                    <th>周四</th>
                    <th>周五</th>
                    <th>周六</th>
                    <th>周日</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th>上午</th>
                    <c:forEach var="day" begin="1" end="7">
                        <c:set var="cellKey" value="${day}_MORNING"/>
                        <td class="${scheduleMap[cellKey] ? 'available' : ''}"></td>
                    </c:forEach>
                </tr>
                <tr>
                    <th>下午</th>
                    <c:forEach var="day" begin="1" end="7">
                        <c:set var="cellKey" value="${day}_AFTERNOON"/>
                        <td class="${scheduleMap[cellKey] ? 'available' : ''}"></td>
                    </c:forEach>
                </tr>
                <tr>
                    <th>晚上</th>
                    <c:forEach var="day" begin="1" end="7">
                        <c:set var="cellKey" value="${day}_EVENING"/>
                        <td class="${scheduleMap[cellKey] ? 'available' : ''}"></td>
                    </c:forEach>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="legend">
        <span class="legend-item">
            <span class="legend-box available"></span>
            可服务时段
        </span>
        <span class="legend-item">
            <span class="legend-box unavailable"></span>
            不可服务
        </span>
    </div>
</div>

<script>
    function changeVolunteer() {
        var volunteerId = document.getElementById('volunteerSelect').value;
        window.location.href = '${pageContext.request.contextPath}/family/schedule/view?volunteerId=' + volunteerId;
    }
</script>
</body>
</html>
