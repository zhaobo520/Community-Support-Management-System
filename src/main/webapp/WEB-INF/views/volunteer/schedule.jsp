<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>排班管理</title>
    <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', sans-serif;
            background: #FAF5F0;
            min-height: 100vh;
            padding: 0;
        }
        .gov-header {
            background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
            height: 60px;
            padding: 0 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            position: relative;
        }
        .gov-header::before {
            content: '★';
            position: absolute;
            left: 20px;
            color: #B71C1C;
            font-size: 24px;
        }
        .gov-header h1 {
            color: white;
            font-size: 20px;
            font-weight: 600;
            margin-left: 50px;
            letter-spacing: 1px;
        }
        .gov-header .actions {
            display: flex;
            gap: 20px;
        }
        .gov-header .actions a {
            color: white;
            text-decoration: none;
            font-size: 14px;
            transition: opacity 0.3s;
        }
        .gov-header .actions a:hover {
            opacity: 0.8;
        }
        .container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .schedule-card {
            background: white;
            padding: 30px;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid #D32F2F;
        }
        .schedule-intro {
            margin-bottom: 20px;
            color: #666;
            font-size: 14px;
        }
        .schedule-grid {
            display: grid;
            grid-template-columns: auto repeat(7, 1fr);
            gap: 10px;
            margin-bottom: 30px;
        }
        .grid-header {
            font-weight: 700;
            color: #212121;
            text-align: center;
            padding: 10px;
            background: #FAF5F0;
            border-radius: 4px;
        }
        .grid-row-header {
            font-weight: 600;
            color: #212121;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #FAF5F0;
            border-radius: 4px;
            padding: 10px;
        }
        .grid-cell {
            aspect-ratio: 1;
            background: white;
            border: 2px solid #E0E0E0;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .grid-cell:hover {
            border-color: #D32F2F;
            background: #FFF8F5;
        }
        .grid-cell.selected {
            background: #D32F2F;
            border-color: #D32F2F;
            color: white;
        }
        .grid-cell.selected::after {
            content: '✓';
            font-weight: bold;
            font-size: 18px;
        }
        .grid-cell.busy {
            background: #666;
            border-color: #666;
            color: white;
        }
        .grid-cell.busy::after {
            content: '✕';
            font-weight: bold;
            font-size: 18px;
        }
        .actions {
            text-align: center;
            margin-top: 20px;
        }
        .save-btn {
            padding: 12px 40px;
            background: white;
            color: #D32F2F;
            border: 1px solid #D32F2F;
            border-radius: 2px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        .save-btn:hover {
            background: #D32F2F;
            color: white;
        }
        .legend {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #666;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .legend-box {
            width: 20px;
            height: 20px;
            border-radius: 2px;
        }
        .legend-available {
            background: #D32F2F;
        }
        .legend-busy {
            background: #666;
        }
        .legend-empty {
            background: white;
            border: 2px solid #E0E0E0;
        }
        .pending-section {
            margin-top: 30px;
            padding: 20px;
            background: #FFF8F5;
            border-radius: 4px;
            border-left: 4px solid #f59e0b;
        }
        .pending-section h3 {
            color: #f59e0b;
            margin-bottom: 15px;
            font-size: 16px;
        }
        .pending-item {
            background: white;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
        }
        .pending-item-info {
            font-weight: bold;
            color: #212121;
        }
        .pending-item button {
            padding: 8px 20px;
            border: 1px solid;
            border-radius: 2px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            margin-left: 10px;
        }
        .btn-agree {
            background: white;
            color: #4CAF50;
            border-color: #4CAF50;
        }
        .btn-agree:hover {
            background: #4CAF50;
            color: white;
        }
        .btn-reject {
            background: white;
            color: #D32F2F;
            border-color: #D32F2F;
        }
        .btn-reject:hover {
            background: #D32F2F;
            color: white;
        }
        .rejected-section {
            margin-top: 20px;
            padding: 20px;
            background: #FFF8F5;
            border-radius: 4px;
            border-left: 4px solid #D32F2F;
        }
        .rejected-section h3 {
            color: #D32F2F;
            margin-bottom: 15px;
            font-size: 16px;
        }
        .rejected-item {
            background: white;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 4px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
        }
        .rejected-item-title {
            font-weight: bold;
            color: #212121;
            margin-bottom: 5px;
        }
        .rejected-item-reason {
            color: #666;
            font-size: 13px;
        }
    </style>
</head>
<body>
    <header class="gov-header">
        <h1>我的排班管理</h1>
        <div class="actions">
            <a href="${pageContext.request.contextPath}/user/volunteer/dashboard">返回仪表盘</a>
            <a href="${pageContext.request.contextPath}/user/logout">退出</a>
        </div>
    </header>

    <div class="container">
        <div class="schedule-card">
            <p class="schedule-intro">请选择您每周固定的空闲时间段，系统将根据这些时间优先为您推荐任务。</p>

            <div class="legend">
                <div class="legend-item">
                    <div class="legend-box legend-available"></div>
                    <span>可服务</span>
                </div>
                <div class="legend-item">
                    <div class="legend-box legend-busy"></div>
                    <span>忙碌</span>
                </div>
                <div class="legend-item">
                    <div class="legend-box legend-empty"></div>
                    <span>未设置</span>
                </div>
            </div>
            <p class="schedule-intro" style="margin-top: 10px; font-size: 13px; color: #999;">
                点击格子可在三种状态间切换：空白 → 可服务 → 忙碌 → 空白
            </p>

            <div class="schedule-grid">
                <div></div>
                <div class="grid-header">周一</div>
                <div class="grid-header">周二</div>
                <div class="grid-header">周三</div>
                <div class="grid-header">周四</div>
                <div class="grid-header">周五</div>
                <div class="grid-header">周六</div>
                <div class="grid-header">周日</div>

                <div class="grid-row-header">上午</div>
                <c:forEach begin="1" end="7" var="day">
                    <c:set var="key" value="${day}_MORNING" />
                    <c:set var="cellClass" value="" />
                    <c:if test="${scheduleMap[key] == 'available'}">
                        <c:set var="cellClass" value="selected" />
                    </c:if>
                    <c:if test="${scheduleMap[key] == 'busy'}">
                        <c:set var="cellClass" value="busy" />
                    </c:if>
                    <div class="grid-cell ${cellClass}"
                         data-day="${day}" data-slot="MORNING"></div>
                </c:forEach>

                <div class="grid-row-header">下午</div>
                <c:forEach begin="1" end="7" var="day">
                    <c:set var="key" value="${day}_AFTERNOON" />
                    <c:set var="cellClass" value="" />
                    <c:if test="${scheduleMap[key] == 'available'}">
                        <c:set var="cellClass" value="selected" />
                    </c:if>
                    <c:if test="${scheduleMap[key] == 'busy'}">
                        <c:set var="cellClass" value="busy" />
                    </c:if>
                    <div class="grid-cell ${cellClass}"
                         data-day="${day}" data-slot="AFTERNOON"></div>
                </c:forEach>

                <div class="grid-row-header">晚上</div>
                <c:forEach begin="1" end="7" var="day">
                    <c:set var="key" value="${day}_EVENING" />
                    <c:set var="cellClass" value="" />
                    <c:if test="${scheduleMap[key] == 'available'}">
                        <c:set var="cellClass" value="selected" />
                    </c:if>
                    <c:if test="${scheduleMap[key] == 'busy'}">
                        <c:set var="cellClass" value="busy" />
                    </c:if>
                    <div class="grid-cell ${cellClass}"
                         data-day="${day}" data-slot="EVENING"></div>
                </c:forEach>
            </div>

            <div class="actions">
                <button class="save-btn" onclick="saveSchedule()">保存排班设置</button>
            </div>

            <c:if test="${not empty pendingAssignments}">
                <div class="pending-section">
                    <h3>管理员待确认排班 (${pendingAssignments.size()})</h3>
                    <c:forEach items="${pendingAssignments}" var="item">
                        <div class="pending-item">
                            <div class="pending-item-info">
                                周${item.dayOfWeek} -
                                <c:choose>
                                    <c:when test="${item.timeSlot == 'MORNING'}">上午</c:when>
                                    <c:when test="${item.timeSlot == 'AFTERNOON'}">下午</c:when>
                                    <c:otherwise>晚上</c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <button class="btn-agree" onclick="confirmAssignment(${item.dayOfWeek}, '${item.timeSlot}', true)">同意</button>
                                <button class="btn-reject" onclick="rejectAssignment(${item.dayOfWeek}, '${item.timeSlot}')">拒绝</button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <c:if test="${not empty rejectedAssignments}">
                <div class="rejected-section">
                    <h3>已拒绝排班 (${rejectedAssignments.size()})</h3>
                    <c:forEach items="${rejectedAssignments}" var="item">
                        <div class="rejected-item">
                            <div class="rejected-item-title">
                                周${item.dayOfWeek} -
                                <c:choose>
                                    <c:when test="${item.timeSlot == 'MORNING'}">上午</c:when>
                                    <c:when test="${item.timeSlot == 'AFTERNOON'}">下午</c:when>
                                    <c:otherwise>晚上</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="rejected-item-reason">拒绝理由：${item.rejectReason}</div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        document.querySelectorAll('.grid-cell').forEach(cell => {
            cell.addEventListener('click', function() {
                if (this.classList.contains('selected')) {
                    this.classList.remove('selected');
                    this.classList.add('busy');
                } else if (this.classList.contains('busy')) {
                    this.classList.remove('busy');
                } else {
                    this.classList.add('selected');
                }
            });
        });

        function saveSchedule() {
            const scheduleData = {};
            document.querySelectorAll('.grid-cell').forEach(cell => {
                const day = cell.getAttribute('data-day');
                const slot = cell.getAttribute('data-slot');
                const key = day + '_' + slot;

                if (cell.classList.contains('selected')) {
                    scheduleData[key] = 'available';
                } else if (cell.classList.contains('busy')) {
                    scheduleData[key] = 'busy';
                } else {
                    scheduleData[key] = 'empty';
                }
            });

            fetch('${pageContext.request.contextPath}/volunteer/schedule/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(scheduleData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('排班设置已保存');
                } else {
                    alert('保存失败：' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('保存失败，请稍后重试');
            });
        }

        function confirmAssignment(dayOfWeek, timeSlot, agree) {
            fetch('${pageContext.request.contextPath}/volunteer/schedule/confirm', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'dayOfWeek=' + dayOfWeek + '&timeSlot=' + timeSlot + '&agree=' + agree
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('操作成功！');
                    location.reload();
                } else {
                    alert('操作失败：' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('操作失败，请稍后重试');
            });
        }

        function rejectAssignment(dayOfWeek, timeSlot) {
            var reason = prompt('请输入拒绝理由：');
            if (!reason || reason.trim() === '') {
                alert('拒绝理由不能为空');
                return;
            }

            fetch('${pageContext.request.contextPath}/volunteer/schedule/confirm', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'dayOfWeek=' + dayOfWeek + '&timeSlot=' + timeSlot + '&agree=false&reason=' + encodeURIComponent(reason)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('已拒绝该排班');
                    location.reload();
                } else {
                    alert('操作失败：' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('操作失败，请稍后重试');
            });
        }
    </script>
</body>
</html>
