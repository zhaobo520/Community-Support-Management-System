<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>我的需求 - 家属服务中心</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
      font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    }
    .family-header {
      background: linear-gradient(135deg, #B71C1C 0%, #D32F2F 100%);
      box-shadow: 0 2px 12px rgba(0,0,0,0.15);
      padding: 0 32px;
      height: 64px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: white;
    }
    .family-header h1 {
      font-size: 18px;
      color: white;
      font-weight: 600;
      letter-spacing: 2px;
    }
    .family-header .actions {
      display: flex;
      gap: 16px;
    }
    .family-header .actions a {
      color: rgba(255,255,255,0.9);
      text-decoration: none;
      font-size: 13px;
      padding: 8px 14px;
      border-radius: 6px;
      transition: all 0.2s;
    }
    .family-header .actions a:hover {
      background: rgba(255,255,255,0.15);
      color: white;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 28px 24px;
    }
    .stats {
      display: grid;
      grid-template-columns: repeat(5, 1fr);
      gap: 16px;
      margin-bottom: 24px;
    }
    .stat-card {
      background: #fff;
      border-radius: 8px;
      padding: 20px;
      text-align: center;
      box-shadow: 0 2px 12px rgba(0,0,0,0.06);
      border: 1px solid #eee;
      transition: all 0.2s;
    }
    .stat-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 16px rgba(0,0,0,0.1);
    }
    .stat-card h3 {
      font-size: 28px;
      color: #D32F2F;
      margin-bottom: 6px;
      font-weight: 700;
    }
    .stat-card p {
      font-size: 13px;
      color: #666;
    }
    .content {
      background: #fff;
      border-radius: 8px;
      padding: 28px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.06);
      border: 1px solid #eee;
    }
    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24px;
      padding-bottom: 16px;
      border-bottom: 2px solid #f0f0f0;
    }
    .header h2 {
      font-size: 18px;
      color: #333;
      font-weight: 600;
    }
    .btn-create {
      display: inline-block;
      padding: 10px 20px;
      background: #D32F2F;
      color: white;
      text-decoration: none;
      border-radius: 6px;
      font-weight: 600;
      font-size: 13px;
      transition: all 0.2s;
    }
    .btn-create:hover {
      background: #B71C1C;
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(211,47,47,0.3);
    }
    .demand-grid {
      display: grid;
      gap: 16px;
    }
    .demand-card {
      background: #FAF5F0;
      border-radius: 8px;
      padding: 20px 24px;
      border-left: 4px solid #D32F2F;
      transition: all 0.2s;
      cursor: pointer;
      border: 1px solid #eee;
    }
    .demand-card:hover {
      box-shadow: 0 4px 16px rgba(211,47,47,0.15);
      transform: translateX(4px);
      border-color: #D32F2F;
    }
    .demand-header {
      display: flex;
      justify-content: space-between;
      align-items: start;
      margin-bottom: 12px;
    }
    .demand-title {
      font-size: 16px;
      color: #333;
      font-weight: 600;
      flex: 1;
    }
    .demand-meta {
      display: flex;
      gap: 10px;
      margin-bottom: 12px;
      flex-wrap: wrap;
    }
    .meta-tag {
      padding: 4px 10px;
      background: rgba(211,47,47,0.08);
      color: #D32F2F;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 600;
    }
    .demand-desc {
      color: #666;
      font-size: 13px;
      line-height: 1.6;
      margin-bottom: 14px;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
    .demand-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding-top: 14px;
      border-top: 1px solid #eee;
    }
    .demand-time {
      font-size: 12px;
      color: #999;
    }
    .status-badge {
      padding: 5px 12px;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 600;
    }
    .status-PENDING { background: #FFF8E1; color: #F57C00; }
    .status-APPROVED { background: #FBE9E7; color: #B71C1C; }
    .status-REJECTED { background: #FFEBEE; color: #C62828; }
    .status-MATCHED { background: #FFF5F5; color: #D32F2F; }
    .status-CLOSED { background: #FAF5F0; color: #666; }
    .empty-state {
      text-align: center;
      padding: 60px 20px;
    }
    .empty-state h3 {
      font-size: 18px;
      color: #666;
      margin-bottom: 12px;
    }
    .empty-state p {
      color: #999;
      margin-bottom: 20px;
      font-size: 14px;
    }
    .urgency-badge {
      display: inline-block;
      padding: 4px 10px;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 600;
    }
    .urgency-LOW { background: #FBE9E7; color: #B71C1C; }
    .urgency-MEDIUM { background: #FFF8E1; color: #F57C00; }
    .urgency-HIGH { background: #FFF3E0; color: #E65100; }
    .urgency-URGENT { background: #FFEBEE; color: #C62828; }
    .msg-success {
      background: #FBE9E7;
      border-left: 4px solid #D32F2F;
      padding: 14px 16px;
      border-radius: 6px;
      margin-bottom: 20px;
      color: #B71C1C;
      font-size: 13px;
    }
    .msg-error {
      background: #FFEBEE;
      border-left: 4px solid #D32F2F;
      padding: 14px 16px;
      border-radius: 6px;
      margin-bottom: 20px;
      color: #C62828;
      font-size: 13px;
    }
    @media (max-width: 768px) {
      .stats { grid-template-columns: repeat(2, 1fr); }
      .family-header { padding: 0 16px; }
      .container { padding: 20px 16px; }
    }
  </style>
</head>
<body>
<div class="family-header">
  <h1>我的需求</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/user/family/dashboard">← 返回控制台</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</div>

<div class="container">
  <!-- 统计卡片 -->
  <div class="stats">
    <div class="stat-card">
      <h3>${statistics.total}</h3>
      <p>总需求数</p>
    </div>
    <div class="stat-card">
      <h3>${statistics.pending}</h3>
      <p>待审核</p>
    </div>
    <div class="stat-card">
      <h3>${statistics.approved}</h3>
      <p>已通过</p>
    </div>
    <div class="stat-card">
      <h3>${statistics.matched}</h3>
      <p>已匹配</p>
    </div>
    <div class="stat-card">
      <h3>${statistics.rejected}</h3>
      <p>已拒绝</p>
    </div>
  </div>

  <!-- 需求列表 -->
  <div class="content">
    <c:if test="${not empty msg}">
      <div class="msg-success">${msg}</div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="msg-error">${error}</div>
    </c:if>

    <div class="header">
      <h2>需求列表</h2>
      <a href="${pageContext.request.contextPath}/demand/family/create" class="btn-create">发布新需求</a>
    </div>

    <c:choose>
      <c:when test="${empty demandList}">
        <div class="empty-state">
          <h3>还没有需求</h3>
          <p>点击上方按钮发布您的第一个关爱需求</p>
          <a href="${pageContext.request.contextPath}/demand/family/create" class="btn-create">立即发布</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="demand-grid">
          <c:forEach items="${demandList}" var="demand">
            <div class="demand-card" onclick="location.href='${pageContext.request.contextPath}/demand/family/detail/${demand.id}'">
              <div class="demand-header">
                <div class="demand-title">${demand.title}</div>
                <span class="status-badge status-${demand.status}">
                  <c:choose>
                    <c:when test="${demand.status == 'PENDING'}">待审核</c:when>
                    <c:when test="${demand.status == 'APPROVED'}">已通过</c:when>
                    <c:when test="${demand.status == 'REJECTED'}">已拒绝</c:when>
                    <c:when test="${demand.status == 'MATCHED'}">已匹配</c:when>
                    <c:when test="${demand.status == 'CLOSED'}">已关闭</c:when>
                  </c:choose>
                </span>
              </div>

              <div class="demand-meta">
                <span class="meta-tag">${demand.demandType}</span>
                <span class="urgency-badge urgency-${demand.urgency}">
                  <c:choose>
                    <c:when test="${demand.urgency == 'LOW'}">低 不急</c:when>
                    <c:when test="${demand.urgency == 'MEDIUM'}">中 一般</c:when>
                    <c:when test="${demand.urgency == 'HIGH'}">高 紧急</c:when>
                    <c:when test="${demand.urgency == 'URGENT'}">紧急 非常紧急</c:when>
                  </c:choose>
                </span>
                <c:if test="${not empty demand.requiredSkill}">
                  <span class="meta-tag">${demand.requiredSkill}</span>
                </c:if>
                <c:if test="${not empty demand.intendedVolunteer}">
                  <span class="meta-tag" style="background:rgba(16,185,129,0.1);color:#10b981;">意向：${demand.intendedVolunteer.fullName}</span>
                </c:if>
              </div>

              <div class="demand-desc">${demand.description}</div>

              <div class="demand-footer">
                <div class="demand-time">
                  发布于 <fmt:formatDate value="${demand.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                </div>
                <c:if test="${not empty demand.reviewComment && demand.status == 'REJECTED'}">
                  <div style="color:#ef4444;font-size:13px;">${demand.reviewComment}</div>
                </c:if>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>
</body>
</html>

