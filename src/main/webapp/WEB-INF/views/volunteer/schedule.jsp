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
            background: #333;
            border-color: #333;
            color: white;
        }
        .grid-cell.busy::after {
            content: '✕';
            font-weight: bold;
            font-size: 18px;
        }
        .grid-cell.standby {
            background: #388E3C;
            border-color: #388E3C;
            color: white;
        }
        .grid-cell.standby::after {
            content: '◎';
            font-weight: bold;
            font-size: 18px;
        }
        /* 管理员指派的格子：志愿者不能直接编辑 */
        .grid-cell.admin-pending {
            border: 3px dashed #f59e0b !important;
            cursor: help;
            position: relative;
        }
        .grid-cell.admin-pending::before {
            content: '⏳';
            position: absolute;
            top: 2px;
            right: 4px;
            font-size: 12px;
            background: white;
            border-radius: 50%;
            padding: 1px 3px;
        }
        .grid-cell.admin-confirmed {
            border: 3px solid #1976D2 !important;
            cursor: help;
            position: relative;
        }
        .grid-cell.admin-confirmed::before {
            content: '🔒';
            position: absolute;
            top: 2px;
            right: 4px;
            font-size: 12px;
            background: white;
            border-radius: 50%;
            padding: 1px 3px;
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
            background: #333;
        }
        .legend-standby {
            background: #388E3C;
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
            color: #D32F2F;
            border-color: #D32F2F;
        }
        .btn-agree:hover {
            background: #D32F2F;
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
        /* 右上角悬浮值班汇总 */
        .summary-widget {
            position: fixed;
            top: 70px;
            right: 20px;
            background: white;
            border-radius: 4px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
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
        .summary-grid .s-header {
            background: #E3F2FD;
            padding: 5px 3px;
            text-align: center;
            border-radius: 2px;
            font-weight: 600;
            color: #1976D2;
        }
        .summary-grid .s-cell {
            background: #FAFAFA;
            padding: 8px 3px;
            text-align: center;
            border-radius: 2px;
            min-height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 9px;
            color: #999;
        }
        .summary-grid .s-cell.has-volunteer {
            background: #D32F2F;
            color: white;
            font-weight: 600;
            cursor: pointer;
            position: relative;
        }
        .summary-grid .s-cell.has-standby {
            background: #FFA000;
            color: white;
            font-weight: 600;
            cursor: pointer;
            position: relative;
        }
        .summary-grid .s-cell.has-volunteer:hover::after,
        .summary-grid .s-cell.has-standby:hover::after {
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

    <!-- 右上角值班汇总小表格 -->
    <div class="summary-widget">
        <h3>当前值班情况</h3>
        <div class="summary-grid">
            <div class="s-header"></div>
            <div class="s-header">周一</div>
            <div class="s-header">周二</div>
            <div class="s-header">周三</div>
            <div class="s-header">周四</div>
            <div class="s-header">周五</div>
            <div class="s-header">周六</div>
            <div class="s-header">周日</div>

            <div class="s-header">上午</div>
            <c:forEach var="day" begin="1" end="7">
                <c:set var="key" value="${day}_MORNING"/>
                <c:set var="entry" value="${volunteerSummary[key]}"/>
                <c:choose>
                    <c:when test="${entry.status == 'available'}">
                        <div class="s-cell has-volunteer" data-summary-key="${key}" data-volunteers="${entry.names}">${entry.count}人</div>
                    </c:when>
                    <c:when test="${entry.status == 'standby'}">
                        <div class="s-cell has-standby" data-summary-key="${key}" data-volunteers="${entry.names}">${entry.count}人</div>
                    </c:when>
                    <c:otherwise><div class="s-cell" data-summary-key="${key}">-</div></c:otherwise>
                </c:choose>
            </c:forEach>

            <div class="s-header">下午</div>
            <c:forEach var="day" begin="1" end="7">
                <c:set var="key" value="${day}_AFTERNOON"/>
                <c:set var="entry" value="${volunteerSummary[key]}"/>
                <c:choose>
                    <c:when test="${entry.status == 'available'}">
                        <div class="s-cell has-volunteer" data-summary-key="${key}" data-volunteers="${entry.names}">${entry.count}人</div>
                    </c:when>
                    <c:when test="${entry.status == 'standby'}">
                        <div class="s-cell has-standby" data-summary-key="${key}" data-volunteers="${entry.names}">${entry.count}人</div>
                    </c:when>
                    <c:otherwise><div class="s-cell" data-summary-key="${key}">-</div></c:otherwise>
                </c:choose>
            </c:forEach>

            <div class="s-header">晚上</div>
            <c:forEach var="day" begin="1" end="7">
                <c:set var="key" value="${day}_EVENING"/>
                <c:set var="entry" value="${volunteerSummary[key]}"/>
                <c:choose>
                    <c:when test="${entry.status == 'available'}">
                        <div class="s-cell has-volunteer" data-summary-key="${key}" data-volunteers="${entry.names}">${entry.count}人</div>
                    </c:when>
                    <c:when test="${entry.status == 'standby'}">
                        <div class="s-cell has-standby" data-summary-key="${key}" data-volunteers="${entry.names}">${entry.count}人</div>
                    </c:when>
                    <c:otherwise><div class="s-cell" data-summary-key="${key}">-</div></c:otherwise>
                </c:choose>
            </c:forEach>
        </div>
    </div>

    <div class="container">
        <div class="schedule-card">
            <p class="schedule-intro">您可以随时调整每周固定的空闲时间段，标记后会立即在值班汇总中显示。管理员指派的排班需要您同意后才会生效。</p>

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
                    <div class="legend-box legend-standby"></div>
                    <span>备班</span>
                </div>
                <div class="legend-item">
                    <div class="legend-box legend-empty"></div>
                    <span>未设置</span>
                </div>
                <div class="legend-item">
                    <div class="legend-box" style="border:3px dashed #f59e0b;background:white;"></div>
                    <span>⏳ 管理员指派 - 待您确认</span>
                </div>
                <div class="legend-item">
                    <div class="legend-box" style="border:3px solid #1976D2;background:white;"></div>
                    <span>🔒 管理员指派 - 您已同意（可修改）</span>
                </div>
            </div>
            <p class="schedule-intro" style="margin-top: 10px; font-size: 13px; color: #999;">
                您可以随时点击格子在四种状态间切换：空白 → 可服务 → 忙碌 → 备班 → 空白。<br>
                <strong style="color:#f59e0b;">待您确认</strong>的管理员指派需先点"同意/拒绝"；<strong style="color:#1976D2;">已同意</strong>的可以直接点击修改，修改后转为您自己的标记。
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
                    <c:if test="${scheduleMap[key] == 'standby'}">
                        <c:set var="cellClass" value="standby" />
                    </c:if>
                    <c:if test="${adminScheduleMap[key] == 'available'}">
                        <c:set var="cellClass" value="selected admin-${adminLockStatus[key]}" />
                    </c:if>
                    <c:if test="${adminScheduleMap[key] == 'standby'}">
                        <c:set var="cellClass" value="standby admin-${adminLockStatus[key]}" />
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
                    <c:if test="${scheduleMap[key] == 'standby'}">
                        <c:set var="cellClass" value="standby" />
                    </c:if>
                    <c:if test="${adminScheduleMap[key] == 'available'}">
                        <c:set var="cellClass" value="selected admin-${adminLockStatus[key]}" />
                    </c:if>
                    <c:if test="${adminScheduleMap[key] == 'standby'}">
                        <c:set var="cellClass" value="standby admin-${adminLockStatus[key]}" />
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
                    <c:if test="${scheduleMap[key] == 'standby'}">
                        <c:set var="cellClass" value="standby" />
                    </c:if>
                    <c:if test="${adminScheduleMap[key] == 'available'}">
                        <c:set var="cellClass" value="selected admin-${adminLockStatus[key]}" />
                    </c:if>
                    <c:if test="${adminScheduleMap[key] == 'standby'}">
                        <c:set var="cellClass" value="standby admin-${adminLockStatus[key]}" />
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
                // 待确认的管理员指派：不能直接修改，需在下方"待确认排班"同意/拒绝
                if (this.classList.contains('admin-pending')) {
                    alert('该时段由管理员指派,请在下方"管理员待确认排班"中选择同意或拒绝');
                    return;
                }
                // 已同意的管理员指派：志愿者可以修改，修改后转为志愿者自己的标记
                if (this.classList.contains('admin-confirmed')) {
                    this.classList.remove('admin-confirmed');
                    // 继续向下执行状态循环
                }
                if (this.classList.contains('selected')) {
                    this.classList.remove('selected');
                    this.classList.add('busy');
                } else if (this.classList.contains('busy')) {
                    this.classList.remove('busy');
                    this.classList.add('standby');
                } else if (this.classList.contains('standby')) {
                    this.classList.remove('standby');
                } else {
                    this.classList.add('selected');
                }
            });
        });

        function saveSchedule() {
            const scheduleData = {};
            document.querySelectorAll('.grid-cell').forEach(cell => {
                // 仅待确认的管理员指派不参与保存（必须先走 confirm/reject 流程）
                if (cell.classList.contains('admin-pending')) {
                    return;
                }
                const day = cell.getAttribute('data-day');
                const slot = cell.getAttribute('data-slot');
                const key = day + '_' + slot;

                if (cell.classList.contains('selected')) {
                    scheduleData[key] = 'available';
                } else if (cell.classList.contains('busy')) {
                    scheduleData[key] = 'busy';
                } else if (cell.classList.contains('standby')) {
                    scheduleData[key] = 'standby';
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
                    location.reload();
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

