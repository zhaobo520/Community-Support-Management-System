<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>数据统计看板</title>
    <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
    <!-- 使用本地ECharts库 -->
    <script src="${pageContext.request.contextPath}/static/js/echarts.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: #FAF5F0;
            min-height: 100vh;
            padding: 20px;
        }

        .dashboard-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            padding: 24px 32px;
            border-radius: 4px;
            margin-bottom: 24px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 28px;
            color: #D32F2F;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header-actions {
            display: flex;
            gap: 12px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-outline {
            background: transparent;
            color: #D32F2F;
            border: 2px solid #D32F2F;
        }

        .btn-outline:hover {
            background: #D32F2F;
            color: white;
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }

        .btn-warning {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: white;
        }

        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.4);
        }

        .date-selector {
            padding: 10px 16px;
            border: 2px solid #D32F2F;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            background: white;
            color: #D32F2F;
            cursor: pointer;
            transition: all 0.3s;
            outline: none;
        }

        .date-selector:hover {
            background: #f0f4ff;
        }

        .date-selector:focus {
            border-color: #B71C1C;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        /* 概览卡片 */
        .overview-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 24px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 4px;
            padding: 24px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--card-color-1), var(--card-color-2));
        }

        .stat-card.card-purple {
            --card-color-1: #D32F2F;
            --card-color-2: #B71C1C;
        }

        .stat-card.card-blue {
            --card-color-1: #4facfe;
            --card-color-2: #00f2fe;
        }

        .stat-card.card-green {
            --card-color-1: #43e97b;
            --card-color-2: #38f9d7;
        }

        .stat-card.card-orange {
            --card-color-1: #fa709a;
            --card-color-2: #fee140;
        }

        .stat-card.card-red {
            --card-color-1: #f093fb;
            --card-color-2: #f5576c;
        }

        .stat-card.card-teal {
            --card-color-1: #4facfe;
            --card-color-2: #00f2fe;
        }

        .stat-label {
            font-size: 14px;
            color: #718096;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 4px;
        }

        .stat-change {
            font-size: 12px;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .stat-change.positive {
            color: #48bb78;
        }

        .stat-change.negative {
            color: #f56565;
        }

        /* 图表区域 */
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 24px;
            margin-bottom: 24px;
        }

        .chart-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 4px;
            padding: 24px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .chart-card.full-width {
            grid-column: 1 / -1;
        }

        .chart-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a202c;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .chart-container {
            width: 100%;
            height: 300px;
        }

        .chart-container.large {
            height: 400px;
        }

        /* 响应式设计 */
        @media (max-width: 1024px) {
            .charts-grid {
                grid-template-columns: 1fr;
            }

            .overview-grid {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 16px;
                align-items: flex-start;
            }

            .overview-grid {
                grid-template-columns: 1fr;
            }

            .stat-value {
                font-size: 24px;
            }
        }

        /* 加载动画 */
        .loading {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 200px;
            color: #D32F2F;
        }

        .loading::after {
            content: "加载中...";
            animation: pulse 1.5s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }

        /* Icon样式 */
        .icon {
            width: 20px;
            height: 20px;
            display: inline-block;
        }

        /* 无数据提示 */
        .no-data {
            text-align: center;
            padding: 40px;
            color: #718096;
        }
    </style>
</head>
<body>
<div class="dashboard-container">
    <!-- Header -->
    <div class="header">
        <h1>
            数据统计看板
        </h1>
        <div class="header-actions">
            <select id="dateRangeSelector" onchange="changeDataRange(this.value)" class="date-selector">
                <option value="ALL">全部数据</option>
                <option value="TODAY">今日</option>
                <option value="WEEK">本周</option>
                <option value="MONTH">本月</option>
                <option value="YEAR">本年</option>
            </select>
            <button class="btn btn-outline" onclick="refreshData()">刷新数据</button>
            <button class="btn btn-success" onclick="exportExcel()">导出Excel</button>
            <button class="btn btn-warning" onclick="exportPdf()">导出PDF</button>
            <a href="${pageContext.request.contextPath}/user/admin/dashboard" class="btn btn-primary">← 返回首页</a>
        </div>
    </div>

    <!-- 概览统计卡片 -->
    <div class="overview-grid">
        <div class="stat-card card-purple">
            <div class="stat-label">总需求数</div>
            <div class="stat-value">${statistics.totalDemands != null ? statistics.totalDemands : 0}</div>
            <div class="stat-change positive">本月新增</div>
        </div>

        <div class="stat-card card-blue">
            <div class="stat-label">总任务数</div>
            <div class="stat-value">${statistics.totalTasks != null ? statistics.totalTasks : 0}</div>
            <div class="stat-change positive">进行中${statistics.inProgressTasks != null ? statistics.inProgressTasks : 0}个</div>
        </div>

        <div class="stat-card card-green">
            <div class="stat-label">志愿者总数</div>
            <div class="stat-value">${statistics.totalVolunteers != null ? statistics.totalVolunteers : 0}</div>
            <div class="stat-change positive">活跃${statistics.activeVolunteers != null ? statistics.activeVolunteers : 0}人</div>
        </div>

        <div class="stat-card card-orange">
            <div class="stat-label">关爱对象</div>
            <div class="stat-value">${statistics.totalElderly != null ? statistics.totalElderly : 0}</div>
            <div class="stat-change">在册人数</div>
        </div>

        <div class="stat-card card-teal">
            <div class="stat-label">完成服务</div>
            <div class="stat-value">${statistics.approvedTasks != null ? statistics.approvedTasks : 0}</div>
            <div class="stat-change positive">平均评分${statistics.averageRating != null ? String.format("%.1f", statistics.averageRating) : '0.0'}</div>
        </div>

        <div class="stat-card card-red">
            <div class="stat-label">待处理</div>
            <div class="stat-value">${statistics.pendingDemands != null ? statistics.pendingDemands : 0}</div>
            <div class="stat-change">待审核需求</div>
        </div>
    </div>

    <!-- 图表区域 -->
    <div class="charts-grid">
        <!-- 需求状态分布 -->
        <div class="chart-card">
            <h3 class="chart-title">需求状态分布</h3>
            <div id="demandStatusChart" class="chart-container"></div>
        </div>

        <!-- 任务状态分布 -->
        <div class="chart-card">
            <h3 class="chart-title">任务状态分布</h3>
            <div id="taskStatusChart" class="chart-container"></div>
        </div>

        <!-- 需求类型统计 -->
        <div class="chart-card">
            <h3 class="chart-title">需求类型统计</h3>
            <div id="demandTypeChart" class="chart-container"></div>
        </div>

        <!-- 任务类型统计 -->
        <div class="chart-card">
            <h3 class="chart-title">任务类型统计</h3>
            <div id="taskTypeChart" class="chart-container"></div>
        </div>

        <!-- 志愿者状态 -->
        <div class="chart-card">
            <h3 class="chart-title">志愿者状态</h3>
            <div id="volunteerStatusChart" class="chart-container"></div>
        </div>

        <!-- 关爱对象护理等级 -->
        <div class="chart-card">
            <h3 class="chart-title">关爱对象护理等级</h3>
            <div id="elderlyCareLevelChart" class="chart-container"></div>
        </div>
    </div>
</div>

<script>
    // 统计数据（从后端传入）
    const statistics = <c:out value="${statisticsJson}" escapeXml="false"/>;
    
    // 刷新数据
    function refreshData() {
        location.reload();
    }
    
    // 导出Excel
    function exportExcel() {
        window.location.href = '${pageContext.request.contextPath}/admin/statistics/export/excel';
    }
    
    // 导出PDF
    function exportPdf() {
        window.location.href = '${pageContext.request.contextPath}/admin/statistics/export/pdf';
    }
    
    // 切换时间范围
    function changeDataRange(rangeType) {
        console.log('切换时间范围:', rangeType);
        
        // 发送AJAX请求获取新数据
        fetch('${pageContext.request.contextPath}/admin/statistics/data/overall?rangeType=' + rangeType)
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    // 更新全局statistics对象
                    Object.assign(statistics, result.data);
                    console.log('更新后的数据:', statistics);
                    
                    // 重新渲染所有图表
                    initDemandStatusChart();
                    initTaskStatusChart();
                    initDemandTypeChart();
                    initTaskTypeChart();
                    initVolunteerStatusChart();
                    initElderlyCareLevelChart();
                    
                    // 刷新页面显示新数据
                    location.reload();
                } else {
                    alert('获取数据失败：' + result.message);
                }
            })
            .catch(error => {
                console.error('请求失败:', error);
                alert('获取数据失败，请稍后重试');
            });
    }
    
    // 调试输出
    console.log('Statistics data:', statistics);

    // 需求状态分布饼图
    function initDemandStatusChart() {
        const chart = echarts.init(document.getElementById('demandStatusChart'));
        const option = {
            tooltip: {
                trigger: 'item',
                formatter: '{b}: {c} ({d}%)'
            },
            legend: {
                orient: 'vertical',
                right: '10%',
                top: 'center',
                textStyle: {
                    fontSize: 12
                }
            },
            series: [{
                name: '需求状态',
                type: 'pie',
                radius: ['40%', '70%'],
                avoidLabelOverlap: false,
                itemStyle: {
                    borderRadius: 10,
                    borderColor: '#fff',
                    borderWidth: 2
                },
                label: {
                    show: false
                },
                emphasis: {
                    label: {
                        show: true,
                        fontSize: 14,
                        fontWeight: 'bold'
                    }
                },
                labelLine: {
                    show: false
                },
                data: [
                    { value: statistics.pendingDemands || 0, name: '待审核', itemStyle: { color: '#fbbf24' } },
                    { value: statistics.approvedDemands || 0, name: '已通过', itemStyle: { color: '#10b981' } },
                    { value: statistics.rejectedDemands || 0, name: '已拒绝', itemStyle: { color: '#ef4444' } },
                    { value: statistics.matchedDemands || 0, name: '已匹配', itemStyle: { color: '#3b82f6' } },
                    { value: statistics.closedDemands || 0, name: '已关闭', itemStyle: { color: '#9ca3af' } }
                ]
            }]
        };
        chart.setOption(option);
        window.addEventListener('resize', () => chart.resize());
    }

    // 任务状态分布饼图
    function initTaskStatusChart() {
        const chart = echarts.init(document.getElementById('taskStatusChart'));
        const option = {
            tooltip: {
                trigger: 'item',
                formatter: '{b}: {c} ({d}%)'
            },
            legend: {
                orient: 'vertical',
                right: '10%',
                top: 'center',
                textStyle: {
                    fontSize: 12
                }
            },
            series: [{
                name: '任务状态',
                type: 'pie',
                radius: ['40%', '70%'],
                itemStyle: {
                    borderRadius: 10,
                    borderColor: '#fff',
                    borderWidth: 2
                },
                label: {
                    show: false
                },
                emphasis: {
                    label: {
                        show: true,
                        fontSize: 14,
                        fontWeight: 'bold'
                    }
                },
                data: [
                    { value: statistics.pendingTasks || 0, name: '待认领', itemStyle: { color: '#fbbf24' } },
                    { value: statistics.claimedTasks || 0, name: '已认领', itemStyle: { color: '#06b6d4' } },
                    { value: statistics.inProgressTasks || 0, name: '进行中', itemStyle: { color: '#3b82f6' } },
                    { value: statistics.completedTasks || 0, name: '已完成', itemStyle: { color: '#8b5cf6' } },
                    { value: statistics.approvedTasks || 0, name: '已审核', itemStyle: { color: '#10b981' } },
                    { value: statistics.cancelledTasks || 0, name: '已取消', itemStyle: { color: '#ef4444' } }
                ]
            }]
        };
        chart.setOption(option);
        window.addEventListener('resize', () => chart.resize());
    }

    // 需求类型柱状图
    function initDemandTypeChart() {
        const chart = echarts.init(document.getElementById('demandTypeChart'));
        const demandTypes = statistics.demandsByType || {};
        
        const types = Object.keys(demandTypes);
        const counts = Object.values(demandTypes);
        
        const option = {
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'shadow'
                }
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                data: types,
                axisTick: {
                    alignWithLabel: true
                }
            },
            yAxis: {
                type: 'value'
            },
            series: [{
                name: '数量',
                type: 'bar',
                barWidth: '60%',
                itemStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: '#D32F2F' },
                        { offset: 1, color: '#B71C1C' }
                    ]),
                    borderRadius: [8, 8, 0, 0]
                },
                data: counts
            }]
        };
        chart.setOption(option);
        window.addEventListener('resize', () => chart.resize());
    }

    // 任务类型柱状图
    function initTaskTypeChart() {
        const chart = echarts.init(document.getElementById('taskTypeChart'));
        const taskTypes = statistics.tasksByType || {};
        
        const types = Object.keys(taskTypes);
        const counts = Object.values(taskTypes);
        
        const option = {
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'shadow'
                }
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                data: types,
                axisTick: {
                    alignWithLabel: true
                }
            },
            yAxis: {
                type: 'value'
            },
            series: [{
                name: '数量',
                type: 'bar',
                barWidth: '60%',
                itemStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: '#4facfe' },
                        { offset: 1, color: '#00f2fe' }
                    ]),
                    borderRadius: [8, 8, 0, 0]
                },
                data: counts
            }]
        };
        chart.setOption(option);
        window.addEventListener('resize', () => chart.resize());
    }

    // 志愿者状态饼图
    function initVolunteerStatusChart() {
        const chart = echarts.init(document.getElementById('volunteerStatusChart'));
        const option = {
            tooltip: {
                trigger: 'item',
                formatter: '{b}: {c} ({d}%)'
            },
            legend: {
                bottom: '5%',
                left: 'center'
            },
            series: [{
                name: '志愿者状态',
                type: 'pie',
                radius: '60%',
                itemStyle: {
                    borderRadius: 8,
                    borderColor: '#fff',
                    borderWidth: 2
                },
                data: [
                    { value: statistics.pendingVolunteers || 0, name: '待审核', itemStyle: { color: '#fbbf24' } },
                    { value: statistics.approvedVolunteers || 0, name: '已通过', itemStyle: { color: '#10b981' } },
                    { value: statistics.rejectedVolunteers || 0, name: '已拒绝', itemStyle: { color: '#ef4444' } }
                ],
                emphasis: {
                    itemStyle: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                }
            }]
        };
        chart.setOption(option);
        window.addEventListener('resize', () => chart.resize());
    }

    // 关爱对象护理等级饼图
    function initElderlyCareLevelChart() {
        const chart = echarts.init(document.getElementById('elderlyCareLevelChart'));
        const careLevels = statistics.elderlyByCareLevel || {};
        
        const data = Object.keys(careLevels).map(key => ({
            name: key,
            value: careLevels[key]
        }));
        
        const option = {
            tooltip: {
                trigger: 'item',
                formatter: '{b}: {c} ({d}%)'
            },
            legend: {
                bottom: '5%',
                left: 'center'
            },
            series: [{
                name: '护理等级',
                type: 'pie',
                radius: '60%',
                itemStyle: {
                    borderRadius: 8,
                    borderColor: '#fff',
                    borderWidth: 2
                },
                data: data,
                emphasis: {
                    itemStyle: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                }
            }]
        };
        chart.setOption(option);
        window.addEventListener('resize', () => chart.resize());
    }

    // 页面加载完成后初始化所有图表
    window.onload = function() {
        initDemandStatusChart();
        initTaskStatusChart();
        initDemandTypeChart();
        initTaskTypeChart();
        initVolunteerStatusChart();
        initElderlyCareLevelChart();
    };
</script>
</body>
</html>
