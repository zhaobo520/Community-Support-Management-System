<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统配置</title>
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

        .gov-header {
            background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
            height: 60px;
            padding: 0 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            position: relative;
            margin-bottom: 40px;
            border-radius: 4px;
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
            margin: 0;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
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

        .btn-success {
            background: white;
            color: #10b981;
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

        .category-section {
            background: white;
            border-radius: 4px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #D32F2F;
        }

        .category-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #D32F2F;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .config-table {
            width: 100%;
            border-collapse: collapse;
        }

        .config-table th {
            background: #FFF5F5;
            padding: 12px;
            text-align: left;
            font-weight: bold;
            color: #D32F2F;
            border-bottom: 2px solid #D32F2F;
        }

        .config-table td {
            padding: 12px;
            border-bottom: 1px solid #f0f0f0;
        }

        .config-table tr:hover {
            background: #FFF5F5;
        }

        .config-input {
            width: 100%;
            padding: 8px 12px;
            border: 2px solid #e0e0e0;
            border-radius: 2px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .config-input:focus {
            outline: none;
            border-color: #D32F2F;
            box-shadow: 0 0 0 3px rgba(211, 47, 47, 0.1);
        }

        .config-description {
            font-size: 12px;
            color: #999;
            margin-top: 4px;
        }

        .save-btn {
            background: #10b981;
            color: white;
            border: none;
            padding: 6px 16px;
            border-radius: 2px;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.3s;
        }

        .save-btn:hover {
            background: #059669;
        }

        .badge {
            padding: 4px 12px;
            border-radius: 2px;
            font-size: 12px;
            font-weight: bold;
        }

        .badge-public {
            background: #d1fae5;
            color: #10b981;
        }

        .badge-private {
            background: #fee2e2;
            color: #ef4444;
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
<header class="gov-header">
    <h1>系统配置</h1>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/admin/logs/index" class="btn btn-primary">查看日志</a>
        <button class="btn btn-warning" onclick="refreshCache()">刷新缓存</button>
        <button class="btn btn-success" onclick="saveAllConfigs()">保存全部</button>
        <a href="${pageContext.request.contextPath}/user/admin/dashboard" class="btn btn-primary">返回首页</a>
    </div>
</header>

<div class="container">

    <!-- 统计卡片 -->
    <div class="stats-cards">
        <div class="stats-card">
            <div class="number">${configsMap.size()}</div>
            <div class="label">配置分类数</div>
        </div>
        <div class="stats-card">
            <div class="number" id="totalConfigs">0</div>
            <div class="label">配置项总数</div>
        </div>
        <div class="stats-card">
            <div class="number" id="publicConfigs">0</div>
            <div class="label">公开配置</div>
        </div>
    </div>

    <!-- 系统基础配置 -->
    <c:if test="${not empty configsMap['SYSTEM']}">
    <div class="category-section">
        <div class="category-title">
            <span>系统基础配置</span>
        </div>
        <table class="config-table">
            <thead>
                <tr>
                    <th style="width: 25%;">配置名称</th>
                    <th style="width: 35%;">配置值</th>
                    <th style="width: 25%;">说明</th>
                    <th style="width: 10%;">可见性</th>
                    <th style="width: 5%;">操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${configsMap['SYSTEM']}" var="config">
                <tr data-key="${config.configKey}">
                    <td><strong>${config.displayName}</strong></td>
                    <td>
                        <c:choose>
                            <c:when test="${config.configType == 'BOOLEAN'}">
                                <label class="toggle-switch">
                                    <input type="checkbox" ${config.configValue == 'true' ? 'checked' : ''} 
                                           onchange="updateConfigValue('${config.configKey}', this.checked ? 'true' : 'false')">
                                    <span class="toggle-slider"></span>
                                </label>
                            </c:when>
                            <c:otherwise>
                                <input type="text" class="config-input" 
                                       value="${config.configValue}" 
                                       data-key="${config.configKey}">
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div style="font-size: 13px;">${config.description}</div>
                        <div class="config-description">键：${config.configKey}</div>
                    </td>
                    <td>
                        <span class="badge ${config.isPublic == 1 ? 'badge-public' : 'badge-private'}">
                            ${config.isPublic == 1 ? '公开' : '私有'}
                        </span>
                    </td>
                    <td>
                        <button class="save-btn" onclick="saveConfig('${config.configKey}')">保存</button>
                    </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    </c:if>

    <!-- 积分系统配置 -->
    <c:if test="${not empty configsMap['POINTS']}">
    <div class="category-section">
        <div class="category-title">
            <span>积分系统配置</span>
        </div>
        <table class="config-table">
            <thead>
                <tr>
                    <th style="width: 25%;">配置名称</th>
                    <th style="width: 35%;">配置值</th>
                    <th style="width: 25%;">说明</th>
                    <th style="width: 10%;">可见性</th>
                    <th style="width: 5%;">操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${configsMap['POINTS']}" var="config">
                <tr data-key="${config.configKey}">
                    <td><strong>${config.displayName}</strong></td>
                    <td>
                        <c:choose>
                            <c:when test="${config.configType == 'BOOLEAN'}">
                                <label class="toggle-switch">
                                    <input type="checkbox" ${config.configValue == 'true' ? 'checked' : ''} 
                                           onchange="updateConfigValue('${config.configKey}', this.checked ? 'true' : 'false')">
                                    <span class="toggle-slider"></span>
                                </label>
                            </c:when>
                            <c:otherwise>
                                <input type="text" class="config-input" 
                                       value="${config.configValue}" 
                                       data-key="${config.configKey}">
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div style="font-size: 13px;">${config.description}</div>
                        <div class="config-description">键：${config.configKey}</div>
                    </td>
                    <td>
                        <span class="badge ${config.isPublic == 1 ? 'badge-public' : 'badge-private'}">
                            ${config.isPublic == 1 ? '公开' : '私有'}
                        </span>
                    </td>
                    <td>
                        <button class="save-btn" onclick="saveConfig('${config.configKey}')">保存</button>
                    </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    </c:if>

    <!-- 任务系统配置 -->
    <c:if test="${not empty configsMap['TASK']}">
    <div class="category-section">
        <div class="category-title">
            <span>任务系统配置</span>
        </div>
        <table class="config-table">
            <thead>
                <tr>
                    <th style="width: 25%;">配置名称</th>
                    <th style="width: 35%;">配置值</th>
                    <th style="width: 25%;">说明</th>
                    <th style="width: 10%;">可见性</th>
                    <th style="width: 5%;">操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${configsMap['TASK']}" var="config">
                <tr data-key="${config.configKey}">
                    <td><strong>${config.displayName}</strong></td>
                    <td>
                        <c:choose>
                            <c:when test="${config.configType == 'BOOLEAN'}">
                                <label class="toggle-switch">
                                    <input type="checkbox" ${config.configValue == 'true' ? 'checked' : ''} 
                                           onchange="updateConfigValue('${config.configKey}', this.checked ? 'true' : 'false')">
                                    <span class="toggle-slider"></span>
                                </label>
                            </c:when>
                            <c:otherwise>
                                <input type="text" class="config-input" 
                                       value="${config.configValue}" 
                                       data-key="${config.configKey}">
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div style="font-size: 13px;">${config.description}</div>
                        <div class="config-description">键：${config.configKey}</div>
                    </td>
                    <td>
                        <span class="badge ${config.isPublic == 1 ? 'badge-public' : 'badge-private'}">
                            ${config.isPublic == 1 ? '公开' : '私有'}
                        </span>
                    </td>
                    <td>
                        <button class="save-btn" onclick="saveConfig('${config.configKey}')">保存</button>
                    </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    </c:if>

    <!-- 其他分类配置 -->
    <c:forEach items="${configsMap}" var="entry">
        <c:if test="${entry.key != 'SYSTEM' && entry.key != 'POINTS' && entry.key != 'TASK'}">
        <div class="category-section">
            <div class="category-title">
                <span>${entry.key} 配置</span>
            </div>
            <table class="config-table">
                <thead>
                    <tr>
                        <th style="width: 25%;">配置名称</th>
                        <th style="width: 35%;">配置值</th>
                        <th style="width: 25%;">说明</th>
                        <th style="width: 10%;">可见性</th>
                        <th style="width: 5%;">操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${entry.value}" var="config">
                    <tr data-key="${config.configKey}">
                        <td><strong>${config.displayName}</strong></td>
                        <td>
                            <c:choose>
                                <c:when test="${config.configType == 'BOOLEAN'}">
                                    <label class="toggle-switch">
                                        <input type="checkbox" ${config.configValue == 'true' ? 'checked' : ''} 
                                               onchange="updateConfigValue('${config.configKey}', this.checked ? 'true' : 'false')">
                                        <span class="toggle-slider"></span>
                                    </label>
                                </c:when>
                                <c:otherwise>
                                    <input type="text" class="config-input" 
                                           value="${config.configValue}" 
                                           data-key="${config.configKey}">
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div style="font-size: 13px;">${config.description}</div>
                            <div class="config-description">键：${config.configKey}</div>
                        </td>
                        <td>
                            <span class="badge ${config.isPublic == 1 ? 'badge-public' : 'badge-private'}">
                                ${config.isPublic == 1 ? '公开' : '私有'}
                            </span>
                        </td>
                        <td>
                            <button class="save-btn" onclick="saveConfig('${config.configKey}')">保存</button>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        </c:if>
    </c:forEach>
</div>

<script>
    // 计算统计数据
    window.onload = function() {
        let totalCount = 0;
        let publicCount = 0;
        
        document.querySelectorAll('.config-table tbody tr').forEach(row => {
            totalCount++;
            if (row.querySelector('.badge-public')) {
                publicCount++;
            }
        });
        
        document.getElementById('totalConfigs').innerText = totalCount;
        document.getElementById('publicConfigs').innerText = publicCount;
    };

    // 保存单个配置
    function saveConfig(configKey) {
        const input = document.querySelector(`input[data-key="${configKey}"]`);
        if (!input) {
            alert('配置项不存在');
            return;
        }
        
        const configValue = input.value;
        
        fetch('${pageContext.request.contextPath}/admin/config/update', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'configKey=' + encodeURIComponent(configKey) + '&configValue=' + encodeURIComponent(configValue)
        })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                alert('配置保存成功！');
            } else {
                alert('保存失败：' + result.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('请求失败，请稍后重试');
        });
    }

    // 更新布尔配置值（开关）
    function updateConfigValue(configKey, configValue) {
        fetch('${pageContext.request.contextPath}/admin/config/update', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'configKey=' + encodeURIComponent(configKey) + '&configValue=' + encodeURIComponent(configValue)
        })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                console.log('配置已更新：' + configKey + ' = ' + configValue);
            } else {
                alert('保存失败：' + result.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('请求失败，请稍后重试');
        });
    }

    // 保存全部配置
    function saveAllConfigs() {
        if (!confirm('确定要保存所有配置吗？')) {
            return;
        }
        
        const allInputs = document.querySelectorAll('.config-input[data-key]');
        let savedCount = 0;
        let totalCount = allInputs.length;
        
        allInputs.forEach(input => {
            const configKey = input.getAttribute('data-key');
            const configValue = input.value;
            
            fetch('${pageContext.request.contextPath}/admin/config/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'configKey=' + encodeURIComponent(configKey) + '&configValue=' + encodeURIComponent(configValue)
            })
            .then(response => response.json())
            .then(result => {
                savedCount++;
                if (savedCount === totalCount) {
                    alert('所有配置保存成功！');
                }
            });
        });
    }

    // 刷新缓存
    function refreshCache() {
        if (!confirm('确定要刷新配置缓存吗？')) {
            return;
        }
        
        fetch('${pageContext.request.contextPath}/admin/config/refresh-cache', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            }
        })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                alert('缓存刷新成功！');
            } else {
                alert('刷新失败：' + result.message);
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
