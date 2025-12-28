<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>志愿者排班管理</title>
    <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #FAF5F0;
            min-height: 100vh;
            padding: 0;
        }
        .gov-header {
            background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
            padding: 20px 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .gov-header h1 {
            color: white;
            font-size: 24px;
            font-weight: bold;
            margin: 0;
            display: flex;
            align-items: center;
        }
        .gov-header h1::before {
            content: '★';
            color: #B71C1C;
            margin-right: 12px;
            font-size: 28px;
        }
        .gov-header .user-info {
            color: white;
            font-size: 14px;
        }
        .main-content {
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 4px;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        h2 {
            color: #D32F2F;
            margin-bottom: 10px;
            font-size: 22px;
            font-weight: bold;
        }
        .back-btn {
            display: inline-block;
            padding: 10px 20px;
            background: white;
            color: #D32F2F;
            text-decoration: none;
            border-radius: 2px;
            margin-bottom: 20px;
            border: 2px solid #D32F2F;
            transition: all 0.3s;
        }
        .back-btn:hover {
            background: #D32F2F;
            color: white;
        }
        .volunteer-selector {
            margin: 20px 0;
            padding: 20px;
            background: #FAF5F0;
            border-radius: 4px;
        }
        .volunteer-selector label {
            font-weight: bold;
            margin-right: 10px;
            color: #333;
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
            background: #FFF3E0;
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
            cursor: pointer;
            transition: all 0.3s;
            background: #fafafa;
        }
        td:hover {
            background: #FFEBEE;
        }
        td.selected {
            background: #D32F2F;
            color: white;
        }
        td.selected::after {
            content: '\2713';
            font-size: 24px;
            display: block;
        }
        /* 志愿者状态处于背景层，用不同颜色显示 */
        td.volunteer-available {
            background: #e8f5e9 !important; /* 淡绿色背景 */
        }
        td.volunteer-busy {
            background: #ffebee !important; /* 淡红色背景 */
        }
        /* 管理员指派的在前景层，会覆盖背景 */
        td.selected.volunteer-available::before,
        td.selected.volunteer-busy::before {
            content: '';
            position: absolute;
            bottom: 2px;
            right: 2px;
            font-size: 12px;
        }
        td {
            position: relative;
        }
        /* 右上角小表格 */
        .summary-widget {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            border-radius: 4px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            z-index: 1000;
            max-width: 380px;
            border: 2px solid #D32F2F;
        }
        .summary-widget h3 {
            font-size: 14px;
            color: #D32F2F;
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
            background: #FFEBEE;
            padding: 5px 3px;
            text-align: center;
            border-radius: 2px;
            font-weight: 600;
            color: #D32F2F;
        }
        .summary-grid .cell {
            background: #FAF5F0;
            padding: 8px 3px;
            text-align: center;
            border-radius: 2px;
            min-height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 9px;
            color: #999;
        }
        .summary-grid .cell.has-volunteer {
            background: #D32F2F;
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
            border-radius: 2px;
            white-space: nowrap;
            font-size: 10px;
            z-index: 1001;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        .save-btn {
            display: block;
            width: 200px;
            margin: 30px auto;
            padding: 15px;
            background: white;
            color: #D32F2F;
            border: 2px solid #D32F2F;
            border-radius: 2px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }
        .save-btn:hover {
            background: #D32F2F;
            color: white;
        }
        .assignment-lists {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 30px;
        }
        .assignment-section {
            padding: 20px;
            background: #FAF5F0;
            border-radius: 4px;
        }
        .assignment-section h3 {
            color: #D32F2F;
            margin-bottom: 15px;
            font-size: 18px;
            font-weight: bold;
        }
        .assignment-item {
            padding: 12px;
            margin-bottom: 10px;
            background: white;
            border-radius: 2px;
            border-left: 4px solid #FFA726;
        }
        .assignment-item.rejected {
            border-left-color: #D32F2F;
        }
        .assignment-item .time {
            font-weight: bold;
            color: #333;
        }
        .assignment-item .reason {
            color: #666;
            font-size: 13px;
            margin-top: 5px;
        }
        .empty-message {
            text-align: center;
            color: #999;
            padding: 20px;
        }
    </style>
</head>
<body>
<!-- 政府风格顶部导航栏 -->
<div class="gov-header">
    <h1>志愿者排班管理系统</h1>
    <div class="user-info">管理员面板</div>
</div>

<div class="main-content">
<!-- 右上角值班汇总小表格 -->
<div class="summary-widget">
    <h3>当前值班情况</h3>
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
    <a href="${pageContext.request.contextPath}/user/admin/dashboard" class="back-btn">返回管理台</a>

    <h2>志愿者排班管理</h2>
    
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
        点击格子为该志愿者指派排班，志愿者需确认后生效。
        <span style="color: #4caf50;">■</span> 淡绿色 = 志愿者自己标记为可服务；
        <span style="color: #f44336;">■</span> 淡红色 = 志愿者标记为忙碌；
        <span style="color: #D32F2F;">■</span> 红色 = 管理员已指派
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
                        <c:set var="cellClass" value="" />
                        <c:if test="${scheduleMap[cellKey]}">
                            <c:set var="cellClass" value="selected" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'available'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-available" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'busy'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-busy" />
                        </c:if>
                        <td class="${cellClass}" data-key="${cellKey}"></td>
                    </c:forEach>
                </tr>
                <tr>
                    <th>下午</th>
                    <c:forEach var="day" begin="1" end="7">
                        <c:set var="cellKey" value="${day}_AFTERNOON"/>
                        <c:set var="cellClass" value="" />
                        <c:if test="${scheduleMap[cellKey]}">
                            <c:set var="cellClass" value="selected" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'available'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-available" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'busy'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-busy" />
                        </c:if>
                        <td class="${cellClass}" data-key="${cellKey}"></td>
                    </c:forEach>
                </tr>
                <tr>
                    <th>晚上</th>
                    <c:forEach var="day" begin="1" end="7">
                        <c:set var="cellKey" value="${day}_EVENING"/>
                        <c:set var="cellClass" value="" />
                        <c:if test="${scheduleMap[cellKey]}">
                            <c:set var="cellClass" value="selected" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'available'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-available" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'busy'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-busy" />
                        </c:if>
                        <td class="${cellClass}" data-key="${cellKey}"></td>
                    </c:forEach>
                </tr>
            </tbody>
        </table>
    </div>

    <button class="save-btn" onclick="saveSchedule()">保存排班设置</button>

    <div class="assignment-lists">
        <div class="assignment-section">
            <h3>待志愿者确认 (${pendingAssignments.size()})</h3>
            <c:choose>
                <c:when test="${empty pendingAssignments}">
                    <div class="empty-message">暂无待确认排班</div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${pendingAssignments}" var="item">
                        <div class="assignment-item">
                            <div class="time">
                                周${item.dayOfWeek} - 
                                <c:choose>
                                    <c:when test="${item.timeSlot == 'MORNING'}">上午</c:when>
                                    <c:when test="${item.timeSlot == 'AFTERNOON'}">下午</c:when>
                                    <c:otherwise>晚上</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="assignment-section">
            <h3>志愿者已拒绝 (${rejectedAssignments.size()})</h3>
            <c:choose>
                <c:when test="${empty rejectedAssignments}">
                    <div class="empty-message">暂无拒绝记录</div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${rejectedAssignments}" var="item">
                        <div class="assignment-item rejected">
                            <div class="time">
                                周${item.dayOfWeek} - 
                                <c:choose>
                                    <c:when test="${item.timeSlot == 'MORNING'}">上午</c:when>
                                    <c:when test="${item.timeSlot == 'AFTERNOON'}">下午</c:when>
                                    <c:otherwise>晚上</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="reason">拒绝理由：${item.rejectReason}</div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

</div>

<script>
    function changeVolunteer() {
        var volunteerId = document.getElementById('volunteerSelect').value;
        window.location.href = '${pageContext.request.contextPath}/admin/schedule/manage?volunteerId=' + volunteerId;
    }

    // 点击切换选中状态
    document.querySelectorAll('td[data-key]').forEach(function(cell) {
        cell.addEventListener('click', function() {
            this.classList.toggle('selected');
        });
    });

    function saveSchedule() {
        var volunteerId = document.getElementById('volunteerSelect').value;
        if (!volunteerId) {
            alert('请选择志愿者');
            return;
        }

        var scheduleData = {};
        document.querySelectorAll('td[data-key]').forEach(function(cell) {
            var key = cell.getAttribute('data-key');
            scheduleData[key] = cell.classList.contains('selected');
        });

        fetch('${pageContext.request.contextPath}/admin/schedule/update?volunteerId=' + volunteerId, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(scheduleData)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                if (data.hasConflicts) {
                    let conflictMsg = '保存成功，但检测到以下冲突：\n\n';
                    for (let key in data.conflicts) {
                        let dayName = getDayName(key);
                        let taskTitle = data.conflicts[key];
                        conflictMsg += `${dayName}：已有任务「${taskTitle}」\n`;
                    }
                    conflictMsg += '\n请注意协调时间安排。';
                    alert(conflictMsg);
                } else {
                    alert('保存成功！');
                }
                location.reload();
            } else {
                alert('保存失败：' + data.message);
            }
        })
        .catch(error => {
            alert('保存失败，请重试');
            console.error(error);
        });
    }

    function getDayName(key) {
        const parts = key.split('_');
        const dayMap = {
            '1': '周一', '2': '周二', '3': '周三', 
            '4': '周四', '5': '周五', '6': '周六', '7': '周日'
        };
        const timeMap = {
            'MORNING': '上午', 'AFTERNOON': '下午', 'EVENING': '晚上'
        };
        return dayMap[parts[0]] + timeMap[parts[1]];
    }
</script>
</body>
</html>
