<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统日志</title>
    <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #FAF5F0;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1600px;
            margin: 0 auto;
        }

        .header {
            background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
            border-radius: 4px;
            padding: 0 40px;
            height: 60px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
        }

        .header::before {
            content: '★';
            position: absolute;
            left: 20px;
            color: #B71C1C;
            font-size: 24px;
        }

        .header h1 {
            font-size: 20px;
            color: white;
            font-weight: 600;
            margin-left: 50px;
            letter-spacing: 1px;
        }

        .actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 16px;
            border: 2px solid white;
            border-radius: 2px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
        }

        .btn-primary {
            background: white;
            color: #D32F2F;
        }

        .btn-danger {
            background: white;
            color: #ef4444;
            border-color: white;
        }

        .btn-warning {
            background: white;
            color: #f59e0b;
            border-color: white;
        }

        .btn:hover {
            background: rgba(255,255,255,0.9);
        }

        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .stats-card {
            background: white;
            border-radius: 4px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            text-align: center;
            border-left: 4px solid #D32F2F;
        }

        .stats-card .number {
            font-size: 36px;
            font-weight: bold;
            color: #D32F2F;
            margin-bottom: 8px;
        }

        .stats-card .label {
            font-size: 14px;
            color: #666;
        }

        .filter-section {
            background: white;
            border-radius: 4px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #D32F2F;
        }

        .filter-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 16px;
            color: #D32F2F;
        }

        .filter-group {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 16px;
        }

        .filter-item label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #666;
        }

        .filter-item select,
        .filter-item input {
            width: 100%;
            padding: 10px;
            border: 2px solid #e0e0e0;
            border-radius: 2px;
            font-size: 14px;
        }

        .filter-item select:focus,
        .filter-item input:focus {
            outline: none;
            border-color: #D32F2F;
            box-shadow: 0 0 0 3px rgba(211, 47, 47, 0.1);
        }

        .logs-section {
            background: white;
            border-radius: 4px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #D32F2F;
        }

        .logs-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .logs-table thead th {
            background: #FFF5F5;
            padding: 12px;
            text-align: left;
            font-weight: bold;
            color: #D32F2F;
            border-bottom: 2px solid #D32F2F;
        }

        .logs-table tbody td {
            padding: 12px;
            border-bottom: 1px solid #f0f0f0;
        }

        .logs-table tbody tr:hover {
            background: #FFF5F5;
        }

        .log-type-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }

        .log-type-config {
            background: #dbeafe;
            color: #1e40af;
        }

        .log-type-login {
            background: #d1fae5;
            color: #065f46;
        }

        .log-type-operation {
            background: #fef3c7;
            color: #92400e;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state .icon {
            font-size: 64px;
            margin-bottom: 16px;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 20px;
        }

        .pagination button {
            padding: 8px 16px;
            border: 2px solid #D32F2F;
            background: white;
            color: #D32F2F;
            border-radius: 2px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }

        .pagination button:hover {
            background: #D32F2F;
            color: white;
        }

        .pagination button:disabled {
            background: #f5f5f5;
            color: #999;
            border-color: #e0e0e0;
            cursor: not-allowed;
        }

        .pagination span {
            color: #666;
        }

        .auto-refresh {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 24px;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: 0.4s;
            border-radius: 24px;
        }

        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: 0.4s;
            border-radius: 50%;
        }

        input:checked + .toggle-slider {
            background-color: #10b981;
        }

        input:checked + .toggle-slider:before {
            transform: translateX(26px);
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>系统日志</h1>
        <div class="actions">
            <div class="auto-refresh">
                <label class="toggle-switch">
                    <input type="checkbox" id="autoRefresh" onchange="toggleAutoRefresh()">
                    <span class="toggle-slider"></span>
                </label>
                <span>自动刷新</span>
            </div>
            <button class="btn btn-warning" onclick="cleanOldLogs()">清理旧日志</button>
            <button class="btn btn-danger" onclick="clearAllLogs()">清空所有日志</button>
            <a href="${pageContext.request.contextPath}/admin/config/index" class="btn btn-primary">← 返回配置</a>
        </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-cards">
        <div class="stats-card">
            <div class="number">${statistics.totalLogs != null ? statistics.totalLogs : 0}</div>
            <div class="label">日志总数</div>
        </div>
        <div class="stats-card">
            <div class="number">${statistics.configChangeLogs != null ? statistics.configChangeLogs : 0}</div>
            <div class="label">配置变更</div>
        </div>
        <div class="stats-card">
            <div class="number">${statistics.loginLogs != null ? statistics.loginLogs : 0}</div>
            <div class="label">登录记录</div>
        </div>
        <div class="stats-card">
            <div class="number">${statistics.operationLogs != null ? statistics.operationLogs : 0}</div>
            <div class="label">操作记录</div>
        </div>
    </div>

    <!-- 筛选区域 -->
    <div class="filter-section">
        <div class="filter-title">日志筛选</div>
        <div class="filter-group">
            <div class="filter-item">
                <label>日志类型</label>
                <select id="logTypeFilter" onchange="filterLogs()">
                    <option value="">全部类型</option>
                    <option value="CONFIG_CHANGE">配置变更</option>
                    <option value="LOGIN">登录记录</option>
                    <option value="OPERATION">操作记录</option>
                </select>
            </div>
            <div class="filter-item">
                <label>开始日期</label>
                <input type="date" id="startDate">
            </div>
            <div class="filter-item">
                <label>结束日期</label>
                <input type="date" id="endDate">
            </div>
            <div class="filter-item">
                <label style="visibility: hidden;">操作</label>
                <button class="btn btn-primary" onclick="filterByDateRange()">按时间筛选</button>
            </div>
        </div>
    </div>

    <!-- 日志列表 -->
    <div class="logs-section">
        <h2 style="margin-bottom: 16px;">日志记录</h2>
        
        <table class="logs-table">
            <thead>
                <tr>
                    <th style="width: 8%;">ID</th>
                    <th style="width: 12%;">日志类型</th>
                    <th style="width: 15%;">操作</th>
                    <th style="width: 12%;">操作人</th>
                    <th style="width: 30%;">详细内容</th>
                    <th style="width: 12%;">IP地址</th>
                    <th style="width: 11%;">时间</th>
                </tr>
            </thead>
            <tbody id="logsTableBody">
                <tr>
                    <td colspan="7">
                        <div class="empty-state">
                            <div class="icon"></div>
                            <div>加载中...</div>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>

        <div class="pagination" id="pagination">
            <button onclick="previousPage()" id="prevBtn">上一页</button>
            <span>第 <span id="currentPage">1</span> 页</span>
            <button onclick="nextPage()" id="nextBtn">下一页</button>
        </div>
    </div>
</div>

<script>
    let currentPage = 1;
    let pageSize = 20;
    let autoRefreshInterval = null;

    // 页面加载时获取日志
    window.onload = function() {
        loadLogs();
    };

    // 加载日志
    function loadLogs() {
        fetch('${pageContext.request.contextPath}/admin/logs/list?page=' + currentPage + '&pageSize=' + pageSize)
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    displayLogs(result.data);
                } else {
                    alert('加载失败：' + result.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showEmptyState('加载失败，请稍后重试');
            });
    }

    // 显示日志
    function displayLogs(logs) {
        const tbody = document.getElementById('logsTableBody');
        
        if (!logs || logs.length === 0) {
            showEmptyState('暂无日志记录');
            return;
        }

        let html = '';
        logs.forEach(log => {
            const typeClass = 'log-type-' + log.logType.toLowerCase().replace('_', '-');
            const typeName = getTypeName(log.logType);
            const time = formatDate(log.createdAt);
            
            html += '<tr>';
            html += '<td>' + log.id + '</td>';
            html += '<td><span class="log-type-badge ' + typeClass + '">' + typeName + '</span></td>';
            html += '<td>' + (log.operation || '-') + '</td>';
            html += '<td>' + (log.operatorName || '-') + '</td>';
            html += '<td>' + (log.content || '-') + '</td>';
            html += '<td>' + (log.ipAddress || '-') + '</td>';
            html += '<td>' + time + '</td>';
            html += '</tr>';
        });
        
        tbody.innerHTML = html;
        document.getElementById('currentPage').textContent = currentPage;
    }

    // 显示空状态
    function showEmptyState(message) {
        const tbody = document.getElementById('logsTableBody');
        tbody.innerHTML = `
            <tr>
                <td colspan="7">
                    <div class="empty-state">
                        <div class="icon"></div>
                        <div>${message}</div>
                    </div>
                </td>
            </tr>
        `;
    }

    // 获取类型名称
    function getTypeName(logType) {
        const typeMap = {
            'CONFIG_CHANGE': '配置变更',
            'LOGIN': '登录记录',
            'OPERATION': '操作记录'
        };
        return typeMap[logType] || logType;
    }

    // 格式化日期
    function formatDate(dateString) {
        const date = new Date(dateString);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        const seconds = String(date.getSeconds()).padStart(2, '0');
        return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
    }

    // 按类型筛选
    function filterLogs() {
        const logType = document.getElementById('logTypeFilter').value;
        
        if (!logType) {
            loadLogs();
            return;
        }

        fetch('${pageContext.request.contextPath}/admin/logs/filter?logType=' + logType)
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    displayLogs(result.data);
                } else {
                    alert('筛选失败：' + result.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('请求失败，请稍后重试');
            });
    }

    // 按时间范围筛选
    function filterByDateRange() {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;

        if (!startDate || !endDate) {
            alert('请选择开始日期和结束日期');
            return;
        }

        fetch('${pageContext.request.contextPath}/admin/logs/date-range?startDate=' + startDate + '&endDate=' + endDate)
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    displayLogs(result.data);
                } else {
                    alert('筛选失败：' + result.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('请求失败，请稍后重试');
            });
    }

    // 上一页
    function previousPage() {
        if (currentPage > 1) {
            currentPage--;
            loadLogs();
        }
    }

    // 下一页
    function nextPage() {
        currentPage++;
        loadLogs();
    }

    // 切换自动刷新
    function toggleAutoRefresh() {
        const checkbox = document.getElementById('autoRefresh');
        
        if (checkbox.checked) {
            autoRefreshInterval = setInterval(loadLogs, 10000); // 每10秒刷新
            console.log('开启自动刷新');
        } else {
            if (autoRefreshInterval) {
                clearInterval(autoRefreshInterval);
                autoRefreshInterval = null;
            }
            console.log('关闭自动刷新');
        }
    }

    // 清理旧日志
    function cleanOldLogs() {
        const days = prompt('请输入要清理多少天前的日志：', '30');
        
        if (!days || isNaN(days)) {
            return;
        }

        if (!confirm('确定要清理' + days + '天前的日志吗？')) {
            return;
        }

        fetch('${pageContext.request.contextPath}/admin/logs/clean', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'days=' + days
        })
        .then(response => response.json())
        .then(result => {
            alert(result.message);
            if (result.success) {
                loadLogs();
                location.reload();
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('请求失败，请稍后重试');
        });
    }

    // 清空所有日志
    function clearAllLogs() {
        if (!confirm('警告：确定要清空所有日志吗？此操作不可恢复！')) {
            return;
        }

        if (!confirm('最后确认：真的要清空所有日志吗？')) {
            return;
        }

        fetch('${pageContext.request.contextPath}/admin/logs/clear-all', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            }
        })
        .then(response => response.json())
        .then(result => {
            alert(result.message);
            if (result.success) {
                loadLogs();
                location.reload();
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('请求失败，请稍后重试');
        });
    }
</script>
</body>
</html>
