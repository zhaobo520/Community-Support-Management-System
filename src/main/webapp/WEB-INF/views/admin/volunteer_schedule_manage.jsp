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
            background: #FAF5F0;
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
        td.admin-standby {
            background: #388E3C;
            color: white;
        }
        td.admin-standby::after {
            content: '◎';
            font-size: 24px;
            display: block;
        }
        /* 志愿者状态处于背景层，用不同颜色显示 */
        td.volunteer-available {
            background: #FBE9E7 !important; /* 淡红色背景=可服务 */
        }
        td.volunteer-busy {
            background: #424242 !important; /* 深灰色背景=忙碌 */
            color: #fff;
        }
        td.volunteer-standby {
            background: #C8E6C9 !important; /* 淡绿色背景=备班 */
        }
        /* 管理员指派的在前景层，会覆盖背景 */
        td.selected.volunteer-available,
        td.selected.volunteer-busy,
        td.selected.volunteer-standby {
            background: #D32F2F !important;
            color: white;
        }
        td.admin-standby.volunteer-available,
        td.admin-standby.volunteer-busy,
        td.admin-standby.volunteer-standby {
            background: #388E3C !important;
            color: white;
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
            border: 2px solid #1976D2;
        }
        .summary-widget h3 {
            font-size: 14px;
            color: #1976D2;
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
            background: #E3F2FD;
            padding: 5px 3px;
            text-align: center;
            border-radius: 2px;
            font-weight: 600;
            color: #1976D2;
        }
        .summary-grid .cell {
            background: #FAFAFA;
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
        .summary-grid .cell.has-standby {
            background: #FFA000;
            color: white;
            font-weight: 600;
            cursor: pointer;
            position: relative;
        }
        .summary-grid .cell.has-volunteer:hover::after,
        .summary-grid .cell.has-standby:hover::after {
            content: attr(data-volunteers);
            position: absolute;
            top: -5px;
            right: 105%;
            background: #1976D2;
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
            <c:set var="entry" value="${volunteerSummary[key]}"/>
            <c:choose>
                <c:when test="${entry.status == 'available'}">
                    <div class="cell has-volunteer" data-summary-key="${key}" data-volunteers="${entry.names}">${entry.count}人</div>
                </c:when>
                <c:when test="${entry.status == 'standby'}">
                    <div class="cell has-standby" data-summary-key="${key}" data-volunteers="${entry.names}">${entry.count}人</div>
                </c:when>
                <c:otherwise>
                    <div class="cell" data-summary-key="${key}">-</div>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <div class="header">下午</div>
        <c:forEach var="day" begin="1" end="7">
            <c:set var="key" value="${day}_AFTERNOON"/>
            <c:set var="entry" value="${volunteerSummary[key]}"/>
            <c:choose>
                <c:when test="${entry.status == 'available'}">
                    <div class="cell has-volunteer" data-summary-key="${key}" data-volunteers="${entry.names}">${entry.count}人</div>
                </c:when>
                <c:when test="${entry.status == 'standby'}">
                    <div class="cell has-standby" data-summary-key="${key}" data-volunteers="${entry.names}">${entry.count}人</div>
                </c:when>
                <c:otherwise>
                    <div class="cell" data-summary-key="${key}">-</div>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <div class="header">晚上</div>
        <c:forEach var="day" begin="1" end="7">
            <c:set var="key" value="${day}_EVENING"/>
            <c:set var="entry" value="${volunteerSummary[key]}"/>
            <c:choose>
                <c:when test="${entry.status == 'available'}">
                    <div class="cell has-volunteer" data-summary-key="${key}" data-volunteers="${entry.names}">${entry.count}人</div>
                </c:when>
                <c:when test="${entry.status == 'standby'}">
                    <div class="cell has-standby" data-summary-key="${key}" data-volunteers="${entry.names}">${entry.count}人</div>
                </c:when>
                <c:otherwise>
                    <div class="cell" data-summary-key="${key}">-</div>
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
        点击格子为该志愿者指派排班（红色=可服务，绿色=备班），<strong style="color:#D32F2F;">需志愿者同意后才会显示到右上角值班汇总中</strong>。再次点击切换状态，第三次点击取消指派。
        <br>
        志愿者自己标记的状态为背景色显示（无须管理员审核，志愿者可随时修改）；管理员指派的状态为前景色（覆盖背景）。
        <br>
        <span style="display:inline-block;width:14px;height:14px;background:#FBE9E7;border:1px solid #ccc;vertical-align:middle;margin-right:4px;"></span> 淡红色 = 志愿者自己标记为可服务；
        <span style="display:inline-block;width:14px;height:14px;background:#424242;border:1px solid #ccc;vertical-align:middle;margin-right:4px;"></span> 深灰色 = 志愿者标记为忙碌；
        <span style="display:inline-block;width:14px;height:14px;background:#C8E6C9;border:1px solid #ccc;vertical-align:middle;margin-right:4px;"></span> 淡绿色 = 志愿者标记为备班；
        <span style="display:inline-block;width:14px;height:14px;background:#D32F2F;border:1px solid #ccc;vertical-align:middle;margin-right:4px;"></span> 红色 = 管理员已指派（可服务）；
        <span style="display:inline-block;width:14px;height:14px;background:#388E3C;border:1px solid #ccc;vertical-align:middle;margin-right:4px;"></span> 绿色 = 管理员已指派（备班）
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
                        <c:if test="${scheduleMap[cellKey] == 'available'}">
                            <c:set var="cellClass" value="selected" />
                        </c:if>
                        <c:if test="${scheduleMap[cellKey] == 'standby'}">
                            <c:set var="cellClass" value="admin-standby" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'available'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-available" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'busy'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-busy" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'standby'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-standby" />
                        </c:if>
                        <td class="${cellClass}" data-key="${cellKey}"></td>
                    </c:forEach>
                </tr>
                <tr>
                    <th>下午</th>
                    <c:forEach var="day" begin="1" end="7">
                        <c:set var="cellKey" value="${day}_AFTERNOON"/>
                        <c:set var="cellClass" value="" />
                        <c:if test="${scheduleMap[cellKey] == 'available'}">
                            <c:set var="cellClass" value="selected" />
                        </c:if>
                        <c:if test="${scheduleMap[cellKey] == 'standby'}">
                            <c:set var="cellClass" value="admin-standby" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'available'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-available" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'busy'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-busy" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'standby'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-standby" />
                        </c:if>
                        <td class="${cellClass}" data-key="${cellKey}"></td>
                    </c:forEach>
                </tr>
                <tr>
                    <th>晚上</th>
                    <c:forEach var="day" begin="1" end="7">
                        <c:set var="cellKey" value="${day}_EVENING"/>
                        <c:set var="cellClass" value="" />
                        <c:if test="${scheduleMap[cellKey] == 'available'}">
                            <c:set var="cellClass" value="selected" />
                        </c:if>
                        <c:if test="${scheduleMap[cellKey] == 'standby'}">
                            <c:set var="cellClass" value="admin-standby" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'available'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-available" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'busy'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-busy" />
                        </c:if>
                        <c:if test="${volunteerStatusMap[cellKey] == 'standby'}">
                            <c:set var="cellClass" value="${cellClass} volunteer-standby" />
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

    // 点击切换状态：空白 → 可服务(红) → 备班(绿) → 空白
    document.querySelectorAll('td[data-key]').forEach(function(cell) {
        cell.addEventListener('click', function() {
            if (this.classList.contains('selected')) {
                this.classList.remove('selected');
                this.classList.add('admin-standby');
            } else if (this.classList.contains('admin-standby')) {
                this.classList.remove('admin-standby');
            } else {
                this.classList.add('selected');
            }
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
            if (cell.classList.contains('selected')) {
                scheduleData[key] = 'available';
            } else if (cell.classList.contains('admin-standby')) {
                scheduleData[key] = 'standby';
            } else {
                scheduleData[key] = false;
            }
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

    // 悬浮窗 10 秒轮询，跨端近实时同步当前值班情况
    function refreshSummary() {
        fetch('${pageContext.request.contextPath}/api/schedule/summary', { credentials: 'same-origin' })
            .then(r => r.ok ? r.json() : null)
            .then(data => {
                if (!data) return;
                document.querySelectorAll('[data-summary-key]').forEach(cell => {
                    const key = cell.getAttribute('data-summary-key');
                    const entry = data[key];
                    cell.classList.remove('has-volunteer', 'has-standby');
                    if (entry && entry.status === 'available') {
                        cell.classList.add('has-volunteer');
                        cell.textContent = entry.count + '人';
                        cell.setAttribute('data-volunteers', entry.names);
                    } else if (entry && entry.status === 'standby') {
                        cell.classList.add('has-standby');
                        cell.textContent = entry.count + '人';
                        cell.setAttribute('data-volunteers', entry.names);
                    } else {
                        cell.textContent = '-';
                        cell.removeAttribute('data-volunteers');
                    }
                });
            })
            .catch(() => {});
    }
    setInterval(refreshSummary, 10000);
</script>
</body>
</html>

