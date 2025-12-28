<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>积分管理</title>
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

        .btn-primary:hover {
            background: rgba(255,255,255,0.9);
        }

        .btn-success {
            background: white;
            color: #10b981;
            border-color: white;
        }

        .btn-danger {
            background: #ef4444;
            color: white;
            border-color: #ef4444;
        }

        .section {
            background: white;
            border-radius: 4px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #D32F2F;
        }

        .section-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #212121;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }

        .form-input {
            width: 100%;
            padding: 10px;
            border: 2px solid #e0e0e0;
            border-radius: 2px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .form-input:focus {
            outline: none;
            border-color: #D32F2F;
            box-shadow: 0 0 0 3px rgba(211, 47, 47, 0.1);
        }

        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        @media (max-width: 900px) {
            .grid-2 {
                grid-template-columns: 1fr;
            }
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }

        th {
            background: #FFF5F5;
            font-weight: bold;
            color: #D32F2F;
        }

        tr:hover {
            background: #FFF5F5;
        }

        .badge {
            padding: 4px 12px;
            border-radius: 2px;
            font-size: 12px;
            font-weight: bold;
        }

        .badge-positive {
            background: #d1fae5;
            color: #10b981;
        }

        .badge-negative {
            background: #fee2e2;
            color: #ef4444;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
        }

        .modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            border-radius: 4px;
            padding: 30px;
            max-width: 500px;
            width: 90%;
            border-left: 4px solid #D32F2F;
        }

        .modal-header {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #212121;
        }

        .modal-close {
            float: right;
            font-size: 24px;
            cursor: pointer;
            color: #999;
        }

        .modal-close:hover {
            color: #D32F2F;
        }

        .stat-box {
            padding: 20px;
            text-align: center;
        }

        .stat-label {
            color: #999;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .stat-number {
            font-size: 48px;
            color: #D32F2F;
            font-weight: bold;
        }

        .stat-desc {
            color: #999;
            margin-top: 10px;
            font-size: 14px;
        }
    </style>
</head>
<body>
<header class="gov-header">
    <h1>积分管理</h1>
    <div class="actions">
        <button class="btn btn-success" onclick="showAdjustModal()">调整积分</button>
        <a href="${pageContext.request.contextPath}/points/ranking" class="btn btn-primary">查看排行榜</a>
        <a href="${pageContext.request.contextPath}/user/admin/dashboard" class="btn btn-primary">返回首页</a>
    </div>
</header>

<div class="container">
    <div class="grid-2">
        <!-- 快速统计 -->
        <div class="section">
            <div class="section-title">快速统计</div>
            <div class="stat-box">
                <p class="stat-label">总积分发放量</p>
                <h2 class="stat-number">--</h2>
                <p class="stat-desc">累计发放积分数</p>
            </div>
        </div>

        <!-- 最近操作 -->
        <div class="section">
            <div class="section-title">最近操作</div>
            <div class="stat-box">
                <p class="stat-label">今日调整次数</p>
                <h2 class="stat-number" style="color:#10b981;">--</h2>
                <p class="stat-desc">管理员手动调整</p>
            </div>
        </div>
    </div>

    <!-- 积分规则说明 -->
    <div class="section">
        <div class="section-title">积分规则</div>
        <table>
            <thead>
                <tr>
                    <th>规则名称</th>
                    <th>积分数</th>
                    <th>说明</th>
                    <th>状态</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>完成任务</td>
                    <td><span class="badge badge-positive">+10</span></td>
                    <td>志愿者完成一个任务</td>
                    <td>启用</td>
                </tr>
                <tr>
                    <td>任务审核通过</td>
                    <td><span class="badge badge-positive">+5</span></td>
                    <td>任务审核通过后额外奖励</td>
                    <td>启用</td>
                </tr>
                <tr>
                    <td>高分评价</td>
                    <td><span class="badge badge-positive">+15</span></td>
                    <td>获得5分好评额外奖励</td>
                    <td>启用</td>
                </tr>
                <tr>
                    <td>首次任务</td>
                    <td><span class="badge badge-positive">+50</span></td>
                    <td>完成第一个任务</td>
                    <td>启用</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 积分调整记录 -->
    <div class="section">
        <div class="section-title">最近调整记录</div>
        <div id="recordsTable">
            <p style="text-align: center; color: #999; padding: 40px;">加载中...</p>
        </div>
    </div>
</div>

<!-- 调整积分弹窗 -->
<div id="adjustModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeAdjustModal()">&times;</span>
        <div class="modal-header">调整志愿者积分</div>

        <form id="adjustForm" onsubmit="submitAdjust(event)">
            <div class="form-group">
                <label class="form-label">志愿者ID *</label>
                <input type="number" class="form-input" id="userId" required placeholder="请输入志愿者用户ID">
            </div>

            <div class="form-group">
                <label class="form-label">积分数 *</label>
                <input type="number" class="form-input" id="points" required placeholder="正数为增加，负数为扣减">
                <small style="color: #999;">例如：+50 为增加50分，-20 为扣减20分</small>
            </div>

            <div class="form-group">
                <label class="form-label">调整原因 *</label>
                <textarea class="form-input" id="reason" required rows="3" placeholder="请输入调整原因..."></textarea>
            </div>

            <div style="display: flex; gap: 10px; margin-top: 20px;">
                <button type="submit" class="btn btn-success" style="flex: 1;">确认调整</button>
                <button type="button" class="btn btn-danger" style="flex: 1;" onclick="closeAdjustModal()">取消</button>
            </div>
        </form>
    </div>
</div>

<script>
    // 显示调整积分弹窗
    function showAdjustModal() {
        document.getElementById('adjustModal').style.display = 'block';
    }

    // 关闭弹窗
    function closeAdjustModal() {
        document.getElementById('adjustModal').style.display = 'none';
        document.getElementById('adjustForm').reset();
    }

    // 提交积分调整
    function submitAdjust(event) {
        event.preventDefault();

        const userId = document.getElementById('userId').value;
        const points = document.getElementById('points').value;
        const reason = document.getElementById('reason').value;

        if (!userId || !points || !reason) {
            alert('请填写所有必填项');
            return;
        }

        fetch('${pageContext.request.contextPath}/admin/points/adjust', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'userId=' + userId + '&points=' + points + '&reason=' + encodeURIComponent(reason)
        })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                alert('积分调整成功！\n用户新积分：' + result.newTotal);
                closeAdjustModal();
                loadRecentRecords(); // 重新加载记录
            } else {
                alert('调整失败：' + result.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('请求失败，请稍后重试');
        });
    }

    // 加载最近的调整记录
    function loadRecentRecords() {
        // TODO: 实现加载记录的功能
        console.log('加载最近记录');
    }

    // 页面加载时初始化
    window.onload = function() {
        loadRecentRecords();
    };
</script>
</body>
</html>
