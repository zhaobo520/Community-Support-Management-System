<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>需求详情 - 家属服务中心</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
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
      color: white;
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
      flex-wrap: wrap;
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
    .page-wrap {
      padding: 28px 20px 40px;
    }
    .container {
      max-width: 980px;
      margin: 0 auto;
    }
    .content {
      background: #fff;
      border-radius: 8px;
      padding: 36px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.06);
      border: 1px solid #eee;
    }
    .header {
      margin-bottom: 32px;
      padding-bottom: 24px;
      border-bottom: 2px solid #e2e8f0;
    }
    .title {
      font-size: 28px;
      color: #1e293b;
      font-weight: 700;
      margin-bottom: 16px;
    }
    .meta-tags {
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
      align-items: center;
    }
    .tag {
      padding: 6px 14px;
      border-radius: 999px;
      font-size: 13px;
      font-weight: 700;
      background: rgba(211,47,47,0.15);
      color: #D32F2F;
    }
    .status-badge {
      padding: 8px 20px;
      border-radius: 999px;
      font-size: 14px;
      font-weight: 700;
    }
    .status-PENDING { background: rgba(251,191,36,0.15); color: #f59e0b; }
    .status-APPROVED { background: rgba(16,185,129,0.15); color: #10b981; }
    .status-REJECTED { background: rgba(239,68,68,0.15); color: #ef4444; }
    .status-MATCHED { background: rgba(211,47,47,0.15); color: #D32F2F; }
    .status-CLOSED { background: rgba(100,116,139,0.15); color: #64748b; }
    .section {
      margin-bottom: 28px;
    }
    .section-title {
      font-size: 18px;
      color: #1e293b;
      font-weight: 700;
      margin-bottom: 16px;
      padding-left: 12px;
      border-left: 4px solid #D32F2F;
    }
    .info-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 16px;
    }
    .info-item {
      background: #f8fafc;
      padding: 14px;
      border-radius: 6px;
      border: 1px solid #edf2f7;
    }
    .info-label {
      font-size: 13px;
      color: #64748b;
      margin-bottom: 6px;
    }
    .info-value {
      font-size: 15px;
      color: #1e293b;
      font-weight: 600;
      line-height: 1.6;
    }
    .description {
      background: #f8fafc;
      padding: 20px;
      border-radius: 6px;
      line-height: 1.8;
      color: #475569;
      border: 1px solid #edf2f7;
      white-space: pre-wrap;
    }
    .review-box {
      padding: 16px;
      border-radius: 6px;
      margin-bottom: 24px;
    }
    .review-box.approved {
      background: rgba(16,185,129,0.1);
      border-left: 4px solid #10b981;
    }
    .review-box.rejected {
      background: rgba(239,68,68,0.1);
      border-left: 4px solid #ef4444;
    }
    .actions {
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
      margin-top: 32px;
      padding-top: 24px;
      border-top: 2px solid #e2e8f0;
    }
    .btn {
      padding: 12px 24px;
      border-radius: 6px;
      font-size: 15px;
      font-weight: 700;
      border: none;
      cursor: pointer;
      transition: all 0.3s;
      text-decoration: none;
      display: inline-block;
    }
    .btn:hover {
      transform: translateY(-1px);
    }
    .btn-edit {
      background: white;
      border: 2px solid #D32F2F;
      color: #D32F2F;
    }
    .btn-edit:hover {
      background: #D32F2F;
      color: white;
      box-shadow: 0 4px 12px rgba(211,47,47,0.3);
    }
    .btn-delete {
      background: #ef4444;
      color: #fff;
    }
    .btn-delete:hover {
      background: #dc2626;
    }
    .btn-back {
      background: #e2e8f0;
      color: #64748b;
    }
    .btn-back:hover {
      background: #cbd5e1;
    }
    @media (max-width: 768px) {
      .gov-header {
        padding: 10px 16px;
        height: auto;
        min-height: 64px;
        flex-direction: column;
        align-items: flex-start;
        justify-content: center;
        gap: 8px;
      }
      .gov-header h1 {
        margin-left: 32px;
      }
      .page-wrap {
        padding: 20px 16px 32px;
      }
      .content {
        padding: 24px;
      }
      .info-grid {
        grid-template-columns: 1fr;
      }
      .title {
        font-size: 22px;
      }
    }
  </style>
</head>
<body>
<header class="gov-header">
  <h1>家属服务中心</h1>
  <div class="nav-right">
    <span>当前页面：需求详情</span>
    <a href="${pageContext.request.contextPath}/user/family/dashboard">控制台</a>
    <a href="${pageContext.request.contextPath}/demand/family/list">返回列表</a>
  </div>
</header>

<div class="page-wrap">
<div class="container">
  <div class="content">
    <div class="header">
      <h1 class="title">${demand.title}</h1>
      <div class="meta-tags">
        <span class="tag">${demand.demandType}</span>
        <span class="tag">
          <c:choose>
            <c:when test="${demand.urgency == 'LOW'}">低 不急</c:when>
            <c:when test="${demand.urgency == 'MEDIUM'}">中 一般</c:when>
            <c:when test="${demand.urgency == 'HIGH'}">高 紧急</c:when>
            <c:when test="${demand.urgency == 'URGENT'}">紧急 非常紧急</c:when>
          </c:choose>
        </span>
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
    </div>

    <c:if test="${demand.status == 'APPROVED'}">
      <div class="review-box approved">
        <div style="font-weight:700;margin-bottom:8px;">您的需求已通过审核</div>
        <div style="font-size:14px;color:#64748b;">
          审核时间：<fmt:formatDate value="${demand.reviewTime}" pattern="yyyy-MM-dd HH:mm"/>
        </div>
        <c:if test="${not empty demand.reviewComment}">
          <div style="margin-top:8px;">${demand.reviewComment}</div>
        </c:if>
      </div>
    </c:if>

    <c:if test="${demand.status == 'REJECTED'}">
      <div class="review-box rejected">
        <div style="font-weight:700;margin-bottom:8px;color:#ef4444;">您的需求未通过审核</div>
        <div style="font-size:14px;color:#64748b;">
          审核时间：<fmt:formatDate value="${demand.reviewTime}" pattern="yyyy-MM-dd HH:mm"/>
        </div>
        <c:if test="${not empty demand.reviewComment}">
          <div style="margin-top:8px;color:#dc2626;">拒绝原因：${demand.reviewComment}</div>
        </c:if>
      </div>
    </c:if>

    <div class="section">
      <div class="section-title">需求描述</div>
      <div class="description">${demand.description}</div>
    </div>

    <c:if test="${not empty demand.attachmentUrl}">
      <div class="section">
        <div class="section-title">情景图片</div>
        <div style="background:#f8fafc;padding:20px;border-radius:6px;text-align:center;border:1px solid #edf2f7;">
          <img src="${pageContext.request.contextPath}${demand.attachmentUrl}" 
               alt="需求情景图片" 
               style="max-width:100%;max-height:400px;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.1);cursor:pointer;"
               onclick="window.open('${pageContext.request.contextPath}${demand.attachmentUrl}', '_blank')"/>
          <div style="color:#666;font-size:13px;margin-top:10px;">点击图片查看大图</div>
        </div>
      </div>
    </c:if>

    <div class="section">
      <div class="section-title">基本信息</div>
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">需求类型</div>
          <div class="info-value">${demand.demandType}</div>
        </div>
        <div class="info-item">
          <div class="info-label">紧急程度</div>
          <div class="info-value">
            <c:choose>
              <c:when test="${demand.urgency == 'LOW'}">不急</c:when>
              <c:when test="${demand.urgency == 'MEDIUM'}">一般</c:when>
              <c:when test="${demand.urgency == 'HIGH'}">紧急</c:when>
              <c:when test="${demand.urgency == 'URGENT'}">非常紧急</c:when>
            </c:choose>
          </div>
        </div>
        <div class="info-item">
          <div class="info-label">发布时间</div>
          <div class="info-value"><fmt:formatDate value="${demand.createdAt}" pattern="yyyy-MM-dd HH:mm"/></div>
        </div>
        <c:if test="${not empty demand.requiredSkill}">
          <div class="info-item">
            <div class="info-label">所需技能</div>
            <div class="info-value">${demand.requiredSkill}</div>
          </div>
        </c:if>
        <c:if test="${not empty demand.intendedVolunteer}">
          <div class="info-item">
            <div class="info-label">意向志愿者</div>
            <div class="info-value">
              ${demand.intendedVolunteer.fullName}
              <c:if test="${not empty demand.intendedVolunteer.phone}">
                <span style="color:#64748b;font-size:13px;"> · ${demand.intendedVolunteer.phone}</span>
              </c:if>
              <c:if test="${not empty demand.intendedVolunteer.skills}">
                <div style="color:#64748b;font-size:12px;margin-top:4px;">技能：${demand.intendedVolunteer.skills}</div>
              </c:if>
            </div>
          </div>
        </c:if>
      </div>
    </div>

    <div class="section">
      <div class="section-title">服务信息</div>
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">服务地址</div>
          <div class="info-value">${demand.serviceAddress}</div>
        </div>
        <div class="info-item">
          <div class="info-label">联系人</div>
          <div class="info-value">${demand.contactPerson}</div>
        </div>
        <div class="info-item">
          <div class="info-label">联系电话</div>
          <div class="info-value">${demand.contactPhone}</div>
        </div>
        <c:if test="${not empty demand.timeRequirement}">
          <div class="info-item">
            <div class="info-label">时间要求</div>
            <div class="info-value">${demand.timeRequirement}</div>
          </div>
        </c:if>
        <c:if test="${not empty demand.expectedStartTime}">
          <div class="info-item">
            <div class="info-label">期望开始时间</div>
            <div class="info-value"><fmt:formatDate value="${demand.expectedStartTime}" pattern="yyyy-MM-dd HH:mm"/></div>
          </div>
        </c:if>
        <c:if test="${not empty demand.expectedEndTime}">
          <div class="info-item">
            <div class="info-label">期望结束时间</div>
            <div class="info-value"><fmt:formatDate value="${demand.expectedEndTime}" pattern="yyyy-MM-dd HH:mm"/></div>
          </div>
        </c:if>
      </div>
    </div>

    <div class="actions">
      <c:if test="${demand.status == 'PENDING'}">
        <a href="${pageContext.request.contextPath}/demand/family/edit/${demand.id}" class="btn btn-edit">编辑需求</a>
        <button class="btn btn-delete" onclick="deleteDemand()">删除需求</button>
      </c:if>
      <c:if test="${demand.status == 'REJECTED'}">
        <button class="btn btn-delete" onclick="deleteDemand()">删除需求</button>
      </c:if>
      <button class="btn btn-back" onclick="history.back()">← 返回</button>
    </div>
  </div>
</div>
</div>

<script>
function deleteDemand() {
  if (!confirm('确定要删除这个需求吗？此操作不可恢复！')) {
    return;
  }

  fetch('${pageContext.request.contextPath}/demand/family/delete/${demand.id}', {
    method: 'POST'
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      alert('删除成功');
      location.href = '${pageContext.request.contextPath}/demand/family/list';
    } else {
      alert('删除失败：' + data.message);
    }
  })
  .catch(err => {
    console.error(err);
    alert('系统错误');
  });
}
</script>
</body>
</html>
