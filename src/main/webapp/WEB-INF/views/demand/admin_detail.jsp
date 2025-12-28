<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>需求详情 - 管理员控制台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
      padding: 40px 20px;
    }
    .navbar {
      background: rgba(255,255,255,0.95);
      backdrop-filter: blur(10px);
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      padding: 20px 60px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 40px;
      border-radius: 4px;
    }
    .navbar h1 {
      font-size: 24px;
      color: #1e293b;
    }
    .navbar .actions a {
      color: #D32F2F;
      text-decoration: none;
      margin-left: 20px;
      font-weight: 600;
    }
    .container {
      max-width: 1000px;
      margin: 0 auto;
    }
    .content {
      background: #fff;
      border-radius: 4px;
      padding: 40px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.15);
    }
    .header {
      display: flex;
      justify-content: space-between;
      align-items: start;
      margin-bottom: 32px;
      padding-bottom: 24px;
      border-bottom: 2px solid #e2e8f0;
    }
    .title {
      font-size: 28px;
      color: #1e293b;
      font-weight: 700;
      margin-bottom: 12px;
    }
    .meta-tags {
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
    }
    .tag {
      padding: 6px 14px;
      border-radius: 999px;
      font-size: 13px;
      font-weight: 700;
    }
    .tag-type {
      background: rgba(211,47,47,0.15);
      color: #D32F2F;
    }
    .tag-urgency {
      padding: 6px 14px;
      border-radius: 999px;
      font-size: 13px;
      font-weight: 700;
    }
    .urgency-LOW { background: rgba(16,185,129,0.15); color: #10b981; }
    .urgency-MEDIUM { background: rgba(251,191,36,0.15); color: #f59e0b; }
    .urgency-HIGH { background: rgba(249,115,22,0.15); color: #f97316; }
    .urgency-URGENT { background: rgba(239,68,68,0.15); color: #ef4444; }
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
      margin-bottom: 32px;
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
      gap: 20px;
    }
    .info-item {
      background: #f8fafc;
      padding: 16px;
      border-radius: 4px;
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
    }
    .description {
      background: #f8fafc;
      padding: 20px;
      border-radius: 4px;
      line-height: 1.8;
      color: #475569;
    }
    .actions {
      display: flex;
      gap: 12px;
      margin-top: 32px;
      padding-top: 24px;
      border-top: 2px solid #e2e8f0;
    }
    .btn {
      padding: 12px 28px;
      border-radius: 4px;
      font-size: 15px;
      font-weight: 700;
      border: none;
      cursor: pointer;
      transition: all 0.3s;
    }
    .btn-approve {
      background: linear-gradient(135deg, #10b981, #059669);
      color: #fff;
    }
    .btn-approve:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(16,185,129,0.3);
    }
    .btn-reject {
      background: linear-gradient(135deg, #ef4444, #dc2626);
      color: #fff;
    }
    .btn-reject:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(239,68,68,0.3);
    }
    .btn-convert {
      background: white;
      border: 2px solid #D32F2F;
      color: #D32F2F;
    }
    .btn-convert:hover {
      background: #D32F2F;
      color: white;
    }
    .btn-back {
      background: #e2e8f0;
      color: #64748b;
    }
    .btn-back:hover {
      background: #cbd5e1;
    }
    .review-box {
      background: rgba(251,191,36,0.1);
      border-left: 4px solid #f59e0b;
      padding: 16px;
      border-radius: 2px;
      margin-bottom: 20px;
    }
    .review-box.approved {
      background: rgba(16,185,129,0.1);
      border-left-color: #10b981;
    }
    .review-box.rejected {
      background: rgba(239,68,68,0.1);
      border-left-color: #ef4444;
    }
  </style>
</head>
<body>
<div class="navbar">
  <h1>需求详情</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/admin/demand/list">← 返回列表</a>
    <a href="${pageContext.request.contextPath}/user/admin/dashboard">控制台</a>
  </div>
</div>

<div class="container">
  <div class="content">
    <!-- 标题和状态 -->
    <div class="header">
      <div style="flex:1;">
        <h1 class="title">${demand.title}</h1>
        <div class="meta-tags">
          <span class="tag tag-type">${demand.demandType}</span>
          <span class="tag-urgency urgency-${demand.urgency}">
            <c:choose>
              <c:when test="${demand.urgency == 'LOW'}">低 不急</c:when>
              <c:when test="${demand.urgency == 'MEDIUM'}">中 一般</c:when>
              <c:when test="${demand.urgency == 'HIGH'}">高 紧急</c:when>
              <c:when test="${demand.urgency == 'URGENT'}">紧急 非常紧急</c:when>
            </c:choose>
          </span>
          <c:if test="${not empty demand.requiredSkill}">
            <span class="tag tag-type">${demand.requiredSkill}</span>
          </c:if>
        </div>
      </div>
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

    <!-- 审核信息 -->
    <c:if test="${demand.status == 'APPROVED' || demand.status == 'REJECTED'}">
      <div class="review-box ${demand.status == 'APPROVED' ? 'approved' : 'rejected'}">
        <div style="font-weight:700;margin-bottom:8px;">
          ${demand.status == 'APPROVED' ? '审核通过' : '审核拒绝'}
        </div>
        <div style="font-size:14px;color:#64748b;margin-bottom:4px;">
          审核人：${demand.reviewer.fullName} | 
          审核时间：<fmt:formatDate value="${demand.reviewTime}" pattern="yyyy-MM-dd HH:mm"/>
        </div>
        <c:if test="${not empty demand.reviewComment}">
          <div style="margin-top:8px;padding:8px;background:rgba(255,255,255,0.5);border-radius:6px;">
            ${demand.reviewComment}
          </div>
        </c:if>
      </div>
    </c:if>

    <!-- 需求描述 -->
    <div class="section">
      <div class="section-title">需求描述</div>
      <div class="description">${demand.description}</div>
    </div>

    <!-- 情景图片 -->
    <c:if test="${not empty demand.attachmentUrl}">
      <div class="section">
        <div class="section-title">情景图片</div>
        <div style="background:#f8fafc;padding:20px;border-radius:12px;text-align:center;">
          <img src="${pageContext.request.contextPath}${demand.attachmentUrl}" 
               alt="需求情景图片" 
               style="max-width:100%;max-height:500px;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.1);"
               onclick="window.open('${pageContext.request.contextPath}${demand.attachmentUrl}', '_blank')"/>
          <div style="color:#666;font-size:13px;margin-top:10px;">点击图片查看大图</div>
        </div>
      </div>
    </c:if>

    <!-- 基本信息 -->
    <div class="section">
      <div class="section-title">基本信息</div>
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">发布人</div>
          <div class="info-value">${demand.familyUser.fullName}</div>
        </div>
        <div class="info-item">
          <div class="info-label">联系电话</div>
          <div class="info-value">${demand.familyUser.phone}</div>
        </div>
        <div class="info-item">
          <div class="info-label">发布时间</div>
          <div class="info-value">
            <fmt:formatDate value="${demand.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
          </div>
        </div>
        <div class="info-item">
          <div class="info-label">需求类型</div>
          <div class="info-value">${demand.demandType}</div>
        </div>
      </div>
    </div>

    <!-- 服务信息 -->
    <div class="section">
      <div class="section-title">服务信息</div>
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">服务地址</div>
          <div class="info-value">${demand.serviceAddress}</div>
        </div>
        <div class="info-item">
          <div class="info-label">现场联系人</div>
          <div class="info-value">${demand.contactPerson}</div>
        </div>
        <div class="info-item">
          <div class="info-label">现场联系电话</div>
          <div class="info-value">${demand.contactPhone}</div>
        </div>
        <div class="info-item">
          <div class="info-label">时间要求</div>
          <div class="info-value">
            ${not empty demand.timeRequirement ? demand.timeRequirement : '无特殊要求'}
          </div>
        </div>
        <c:if test="${not empty demand.expectedStartTime}">
          <div class="info-item">
            <div class="info-label">期望开始时间</div>
            <div class="info-value">
              <fmt:formatDate value="${demand.expectedStartTime}" pattern="yyyy-MM-dd HH:mm"/>
            </div>
          </div>
        </c:if>
        <c:if test="${not empty demand.expectedEndTime}">
          <div class="info-item">
            <div class="info-label">期望结束时间</div>
            <div class="info-value">
              <fmt:formatDate value="${demand.expectedEndTime}" pattern="yyyy-MM-dd HH:mm"/>
            </div>
          </div>
        </c:if>
      </div>
    </div>

    <!-- 操作按钮 -->
    <div class="actions">
      <c:if test="${demand.status == 'PENDING'}">
        <button class="btn btn-approve" onclick="approveDemand()">审核通过</button>
        <button class="btn btn-reject" onclick="rejectDemand()">审核拒绝</button>
      </c:if>
      <c:if test="${demand.status == 'APPROVED'}">
        <button class="btn btn-convert" onclick="convertToTask()">转换为任务</button>
      </c:if>
      <button class="btn btn-back" onclick="history.back()">← 返回</button>
    </div>
  </div>
</div>

<script>
function approveDemand() {
  const comment = prompt('审核意见（可选）：');
  if (comment === null) return;

  fetch('${pageContext.request.contextPath}/admin/demand/approve/${demand.id}', {
    method: 'POST',
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: 'reviewComment=' + encodeURIComponent(comment || '')
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      alert('审核通过！');
      location.reload();
    } else {
      alert('操作失败：' + data.message);
    }
  })
  .catch(err => {
    console.error(err);
    alert('系统错误');
  });
}

function rejectDemand() {
  const comment = prompt('请输入拒绝原因：');
  if (!comment) {
    alert('请输入拒绝原因');
    return;
  }

  fetch('${pageContext.request.contextPath}/admin/demand/reject/${demand.id}', {
    method: 'POST',
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: 'reviewComment=' + encodeURIComponent(comment)
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      alert('已拒绝');
      location.reload();
    } else {
      alert('操作失败：' + data.message);
    }
  })
  .catch(err => {
    console.error(err);
    alert('系统错误');
  });
}

function convertToTask() {
  if (confirm('确定要将此需求转换为任务吗？')) {
    location.href = '${pageContext.request.contextPath}/admin/demand/convert-to-task/${demand.id}';
  }
}
</script>
</body>
</html>
