<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>社区管理员工作台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { box-sizing: border-box; }
    body {
      background: #FAF5F0;
      margin: 0;
      padding: 0;
      font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    }
    .gov-header {
      background: linear-gradient(135deg, #B71C1C 0%, #D32F2F 100%);
      height: 64px;
      padding: 0 32px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      box-shadow: 0 2px 12px rgba(0,0,0,0.15);
      position: relative;
    }
    .gov-header::before {
      content: '★';
      position: absolute;
      left: 24px;
      color: rgba(255,255,255,0.3);
      font-size: 20px;
    }
    .gov-header h1 {
      color: white;
      font-size: 18px;
      font-weight: 600;
      margin: 0 0 0 40px;
      letter-spacing: 2px;
    }
    .gov-header .nav-right {
      display: flex;
      align-items: center;
      gap: 24px;
      color: rgba(255,255,255,0.9);
      font-size: 13px;
    }
    .gov-header .nav-right a {
      color: rgba(255,255,255,0.9);
      text-decoration: none;
      padding: 6px 12px;
      border-radius: 4px;
      transition: all 0.2s;
    }
    .gov-header .nav-right a:hover {
      background: rgba(255,255,255,0.15);
      color: white;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 28px 24px;
    }
    .role-badge {
      background: white;
      color: #D32F2F;
      padding: 8px 16px;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 600;
      display: inline-block;
      margin-bottom: 24px;
      border: 1px solid #D32F2F;
      box-shadow: 0 2px 8px rgba(211,47,47,0.1);
    }
    .stats {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 20px;
      margin-bottom: 28px;
    }
    .stat-card {
      background: white;
      padding: 24px;
      border-radius: 8px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.06);
      border-left: 4px solid #D32F2F;
      transition: all 0.2s;
    }
    .stat-card:hover {
      box-shadow: 0 4px 20px rgba(0,0,0,0.1);
      transform: translateY(-2px);
    }
    .stat-card h3 {
      font-size: 13px;
      color: #666;
      margin: 0 0 12px 0;
      font-weight: 500;
    }
    .stat-card .number {
      font-size: 36px;
      font-weight: 700;
      color: #D32F2F;
      line-height: 1;
    }
    .modules {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 20px;
    }
    .module-card {
      background: white;
      padding: 24px;
      border-radius: 8px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.06);
      transition: all 0.2s;
      border: 1px solid #eee;
    }
    .module-card:hover {
      box-shadow: 0 4px 20px rgba(0,0,0,0.1);
      transform: translateY(-2px);
      border-color: #D32F2F;
    }
    .module-card h2 {
      color: #333;
      margin: 0 0 10px 0;
      font-size: 15px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .module-card h2 .icon {
      color: #D32F2F;
      font-size: 16px;
    }
    .module-card p {
      color: #666;
      font-size: 13px;
      margin: 0 0 16px 0;
      line-height: 1.6;
      min-height: 42px;
    }
    .action-btn {
      width: 100%;
      padding: 10px 16px;
      border: none;
      border-radius: 6px;
      background: #D32F2F;
      color: white;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      font-size: 13px;
      text-decoration: none;
      display: inline-block;
      text-align: center;
    }
    .action-btn:hover {
      background: #B71C1C;
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(211,47,47,0.3);
    }
    @media (max-width: 1024px) {
      .stats { grid-template-columns: repeat(2, 1fr); }
      .modules { grid-template-columns: repeat(2, 1fr); }
    }
    @media (max-width: 640px) {
      .gov-header { padding: 0 16px; }
      .gov-header h1 { font-size: 16px; margin-left: 32px; }
      .gov-header .nav-right { gap: 12px; font-size: 12px; }
      .container { padding: 20px 16px; }
      .stats { grid-template-columns: 1fr; }
      .modules { grid-template-columns: 1fr; }
      .stat-card .number { font-size: 28px; }
    }
  </style>
</head>
<body>

<header class="gov-header">
  <h1>社区管理员工作台</h1>
  <div class="nav-right">
    <span>首页导航：<a href="#">公告公示</a></span>
    <span>管理员：${currentUser.fullName}</span>
    <a href="${pageContext.request.contextPath}/user/profile">个人资料</a>
    <a href="${pageContext.request.contextPath}/user/admin/profile">管理中心</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <div class="role-badge">ADMIN - 全局管理权限</div>
  
  <div class="stats">
    <div class="stat-card">
      <h3>关爱对象总数</h3>
      <div class="number">328</div>
    </div>
    <div class="stat-card">
      <h3>活跃志愿者</h3>
      <div class="number">145</div>
    </div>
    <div class="stat-card">
      <h3>进行中任务</h3>
      <div class="number">67</div>
    </div>
    <div class="stat-card">
      <h3>待审核志愿者</h3>
      <div class="number">12</div>
    </div>
  </div>

  <div class="modules">
    <div class="module-card">
      <h2><span class="icon"></span>关爱人员审核</h2>
      <p>审核家属提交的关爱人员申请，通过后家属可为其发布服务需求</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/admin/elderly/audit/list'">审核列表</button>
    </div>
    <div class="module-card">
      <h2><span class="icon"></span>关爱对象管理</h2>
      <p>维护关爱档案，录入对象信息，分类管理特殊情况与需求</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/admin/elderly/list'">进入管理</button>
    </div>
    <div class="module-card">
      <h2><span class="icon"></span>志愿者审核</h2>
      <p>审核志愿者注册申请，管理志愿者技能与服务时长统计</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/admin/volunteer/list'">审核列表</button>
    </div>
    <div class="module-card">
      <h2><span class="icon"></span>需求审核</h2>
      <p>审核家属提交的关爱需求，通过后可转换为任务派发给志愿者</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/admin/demand/list'">需求管理</button>
    </div>
    <div class="module-card">
      <h2><span class="icon"></span>通知中心</h2>
      <p>查看系统通知、待办事项提醒、重要消息</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/notification/list'">查看所有通知</button>
    </div>
    <div class="module-card">
      <h2><span class="icon"></span>任务派发</h2>
      <p>创建关爱任务，智能匹配志愿者，跟踪任务进度</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/admin/task/list'">派单中心</button>
    </div>
    <div class="module-card">
      <h2><span class="icon"></span>关爱计划管理</h2>
      <p>创建和管理关爱计划，审核家属发布的计划，跟踪服务进度</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/admin/care-plan/list'">计划管理</button>
    </div>
    <div class="module-card">
      <h2><span class="icon"></span>服务记录审核</h2>
      <p>审核志愿者提交的服务记录，确保服务质量</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/admin/care-plan/records/pending'">审核记录</button>
    </div>
    <div class="module-card">
      <h2><span class="icon"></span>数据统计看板</h2>
      <p>查看综合数据统计，可视化分析关爱效果、志愿者服务情况</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/admin/statistics/dashboard'">查看统计看板</button>
    </div>
    <div class="module-card">
      <h2><span class="icon"></span>反馈管理</h2>
      <p>查看家属提交的反馈、建议和投诉，及时回复处理</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/admin/feedback/list'">反馈管理</button>
    </div>
    <div class="module-card">
      <h2><span class="icon"></span>申诉管理</h2>
      <p>审核和处理用户申诉，包括志愿者和家属的各类申诉事项</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/admin/appeal/list'">申诉管理</button>
    </div>
    <div class="module-card">
      <h2><span class="icon"></span>志愿者排班</h2>
      <p>为志愿者指派服务时段，查看志愿者确认与拒绝情况</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/admin/schedule/manage'">排班管理</button>
    </div>
    <div class="module-card">
      <h2><span class="icon"></span>系统配置</h2>
      <p>权限管理、角色配置、系统参数设置</p>
      <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/admin/config/index'">系统设置</button>
    </div>
  </div>
</div>
</body>
</html>
