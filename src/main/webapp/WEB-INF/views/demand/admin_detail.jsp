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
    .navbar .actions a { color: white; text-decoration: none; margin-left: 20px; font-weight: 600; font-size: 14px; }
    .content { background: #fff; border-radius: 4px; padding: 32px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 4px solid #D32F2F; margin-bottom: 24px; }
    .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
    .demand-title { font-size: 20px; color: #1e293b; font-weight: 700; margin-bottom: 14px; }
    .meta-tags { display: flex; gap: 10px; flex-wrap: wrap; align-items: center; }
    .tag { padding: 4px 12px; border-radius: 2px; font-size: 13px; font-weight: 600; background: rgba(211,47,47,0.1); color: #D32F2F; border: 1px solid rgba(211,47,47,0.2); }
    .tag-urgency { padding: 4px 12px; border-radius: 2px; font-size: 13px; font-weight: 600; }
    .urgency-LOW { background: rgba(16,185,129,0.1); color: #10b981; border: 1px solid rgba(16,185,129,0.2); }
    .urgency-MEDIUM { background: rgba(251,191,36,0.1); color: #f59e0b; border: 1px solid rgba(251,191,36,0.2); }
    .urgency-HIGH { background: rgba(249,115,22,0.1); color: #f97316; border: 1px solid rgba(249,115,22,0.2); }
    .urgency-URGENT { background: rgba(239,68,68,0.1); color: #ef4444; border: 1px solid rgba(239,68,68,0.2); }
    .status-badge { padding: 4px 14px; border-radius: 2px; font-size: 13px; font-weight: 700; }
    .status-PENDING { background: rgba(251,191,36,0.1); color: #f59e0b; border: 1px solid rgba(251,191,36,0.3); }
    .status-APPROVED { background: rgba(16,185,129,0.1); color: #10b981; border: 1px solid rgba(16,185,129,0.3); }
    .status-REJECTED { background: rgba(239,68,68,0.1); color: #ef4444; border: 1px solid rgba(239,68,68,0.3); }
    .status-MATCHED { background: rgba(211,47,47,0.1); color: #D32F2F; border: 1px solid rgba(211,47,47,0.3); }
    .status-CLOSED { background: rgba(100,116,139,0.1); color: #64748b; border: 1px solid rgba(100,116,139,0.3); }
    .section-title { font-size: 16px; color: #1e293b; font-weight: 700; margin-bottom: 16px; padding-left: 10px; border-left: 3px solid #D32F2F; }
    .info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
    .info-item { background: #f8fafc; padding: 14px 16px; border-radius: 4px; border-left: 3px solid #e2e8f0; }
    .info-label { font-size: 12px; color: #64748b; margin-bottom: 4px; text-transform: uppercase; letter-spacing: 0.5px; }
    .info-value { font-size: 15px; color: #1e293b; font-weight: 600; }
    .description-box { background: #f8fafc; padding: 18px; border-radius: 4px; line-height: 1.8; color: #475569; font-size: 14px; }
    .review-box { padding: 14px 16px; border-radius: 4px; margin-bottom: 24px; border-left: 4px solid #f59e0b; background: rgba(251,191,36,0.08); }
    .review-box.approved { background: rgba(16,185,129,0.08); border-left-color: #10b981; }
    .review-box.rejected { background: rgba(239,68,68,0.08); border-left-color: #ef4444; }
    .review-box-title { font-weight: 700; color: #1e293b; margin-bottom: 6px; font-size: 14px; }
    .review-box-meta { font-size: 13px; color: #64748b; }
    .review-box-comment { margin-top: 8px; padding: 8px 12px; background: rgba(255,255,255,0.7); border-radius: 4px; font-size: 13px; color: #475569; }
    .action-bar { display: flex; gap: 12px; margin-top: 8px; flex-wrap: wrap; }
    .btn { padding: 9px 22px; border-radius: 2px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; border: 2px solid transparent; text-decoration: none; display: inline-block; }
    .btn-approve { background: #10b981; color: white; border-color: #10b981; }
    .btn-approve:hover { background: #059669; border-color: #059669; }
    .btn-reject { background: white; color: #ef4444; border-color: #ef4444; }
    .btn-reject:hover { background: #ef4444; color: white; }
    .btn-convert { background: white; color: #D32F2F; border-color: #D32F2F; }
    .btn-convert:hover { background: #D32F2F; color: white; }
    .btn-edit { background: white; color: #2563eb; border-color: #2563eb; }
    .btn-edit:hover { background: #2563eb; color: white; }
    .btn-delete { background: white; color: #ef4444; border-color: #ef4444; }
    .btn-delete:hover { background: #ef4444; color: white; }
    .btn-back { background: white; color: #64748b; border-color: #e2e8f0; }
    .btn-back:hover { background: #f1f5f9; }
  </style>
</head>
<body>
<div class="navbar" style="background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%); padding: 0 40px; height: 60px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; border-radius: 4px; position: relative;">
  <div style="position: absolute; left: 20px; color: #B71C1C; font-size: 24px;">★</div>
  <h1 style="color: white; font-size: 20px; font-weight: 600; margin-left: 50px; letter-spacing: 1px;">需求详情</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/admin/demand/list">← 返回列表</a>
    <a href="${pageContext.request.contextPath}/user/admin/dashboard">控制台</a>
  </div>
</div>

<div class="container">
  <div class="content">
    <div class="page-header">
      <div>
        <div class="demand-title">${demand.title}</div>
        <div class="meta-tags">
          <span class="tag">${demand.demandType}</span>
          <span class="tag-urgency urgency-${demand.urgency}">
            <c:choose>
              <c:when test="${demand.urgency == 'LOW'}">低优先级</c:when>
              <c:when test="${demand.urgency == 'MEDIUM'}">中优先级</c:when>
              <c:when test="${demand.urgency == 'HIGH'}">高优先级</c:when>
              <c:when test="${demand.urgency == 'URGENT'}">非常紧急</c:when>
            </c:choose>
          </span>
          <c:if test="${not empty demand.requiredSkill}">
            <span class="tag">${demand.requiredSkill}</span>
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

    <c:if test="${demand.status == 'APPROVED' || demand.status == 'REJECTED'}">
      <div class="review-box ${demand.status == 'APPROVED' ? 'approved' : 'rejected'}">
        <div class="review-box-title">${demand.status == 'APPROVED' ? '✓ 审核已通过' : '✗ 审核已拒绝'}</div>
        <div class="review-box-meta">
          审核人：${demand.reviewer.fullName} &nbsp;|&nbsp;
          审核时间：<fmt:formatDate value="${demand.reviewTime}" pattern="yyyy-MM-dd HH:mm"/>
        </div>
        <c:if test="${not empty demand.reviewComment}">
          <div class="review-box-comment">${demand.reviewComment}</div>
        </c:if>
      </div>
    </c:if>

    <div style="margin-bottom: 24px;">
      <div class="section-title">需求描述</div>
      <div class="description-box">${demand.description}</div>
    </div>

    <c:if test="${not empty demand.attachmentUrl}">
      <div style="margin-bottom: 24px;">
        <div class="section-title">情景图片</div>
        <div style="background:#f8fafc;padding:16px;border-radius:4px;text-align:center;">
          <img src="${pageContext.request.contextPath}${demand.attachmentUrl}" alt="需求情景图片" style="max-width:100%;max-height:400px;border-radius:4px;box-shadow:0 2px 8px rgba(0,0,0,0.1);cursor:pointer;" onclick="window.open('${pageContext.request.contextPath}${demand.attachmentUrl}', '_blank')"/>
          <div style="color:#94a3b8;font-size:12px;margin-top:8px;">点击图片查看大图</div>
        </div>
      </div>
    </c:if>

    <div class="action-bar">
      <a href="${pageContext.request.contextPath}/admin/demand/edit/${demand.id}" class="btn btn-edit">修改需求</a>
      <button type="button" class="btn btn-delete" onclick="deleteDemand(${demand.id}, ${demand.taskId != null || demand.status == 'MATCHED'})">删除需求</button>
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

  <div class="content">
    <div class="section-title">发布人信息</div>
    <div class="info-grid">
      <div class="info-item"><div class="info-label">发布人</div><div class="info-value">${demand.familyUser.fullName}</div></div>
      <div class="info-item"><div class="info-label">联系电话</div><div class="info-value">${demand.familyUser.phone}</div></div>
      <div class="info-item"><div class="info-label">需求类型</div><div class="info-value">${demand.demandType}</div></div>
      <div class="info-item"><div class="info-label">发布时间</div><div class="info-value"><fmt:formatDate value="${demand.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></div></div>
    </div>
  </div>

  <div class="content">
    <div class="section-title">服务信息</div>
    <div class="info-grid">
      <div class="info-item"><div class="info-label">服务地址</div><div class="info-value">${demand.serviceAddress}</div></div>
      <div class="info-item"><div class="info-label">现场联系人</div><div class="info-value">${demand.contactPerson}</div></div>
      <div class="info-item"><div class="info-label">现场联系电话</div><div class="info-value">${demand.contactPhone}</div></div>
      <div class="info-item"><div class="info-label">时间要求</div><div class="info-value">${not empty demand.timeRequirement ? demand.timeRequirement : '无特殊要求'}</div></div>
      <c:if test="${not empty demand.expectedStartTime}">
        <div class="info-item"><div class="info-label">期望开始时间</div><div class="info-value"><fmt:formatDate value="${demand.expectedStartTime}" pattern="yyyy-MM-dd HH:mm"/></div></div>
      </c:if>
      <c:if test="${not empty demand.expectedEndTime}">
        <div class="info-item"><div class="info-label">期望结束时间</div><div class="info-value"><fmt:formatDate value="${demand.expectedEndTime}" pattern="yyyy-MM-dd HH:mm"/></div></div>
      </c:if>
      <div class="info-item" style="grid-column: 1 / -1;">
        <div class="info-label">意向志愿者</div>
        <div class="info-value">
          <c:choose>
            <c:when test="${not empty demand.intendedVolunteer}">
              ${demand.intendedVolunteer.fullName}
              <c:if test="${not empty demand.intendedVolunteer.phone}">
                <span style="color:#64748b;font-size:13px;"> · ${demand.intendedVolunteer.phone}</span>
              </c:if>
              <c:if test="${not empty demand.intendedVolunteer.skills}">
                <span style="color:#64748b;font-size:13px;"> · 技能：${demand.intendedVolunteer.skills}</span>
              </c:if>
            </c:when>
            <c:otherwise>
              <span style="color:#94a3b8;font-style:italic;">未指定（开放认领）</span>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
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
  }).then(res => res.json()).then(data => {
    if (data.success) { alert('审核通过！'); location.reload(); }
    else { alert('操作失败：' + data.message); }
  }).catch(() => alert('系统错误'));
}

function rejectDemand() {
  const comment = prompt('请输入拒绝原因：');
  if (!comment) { alert('请输入拒绝原因'); return; }
  fetch('${pageContext.request.contextPath}/admin/demand/reject/${demand.id}', {
    method: 'POST',
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: 'reviewComment=' + encodeURIComponent(comment)
  }).then(res => res.json()).then(data => {
    if (data.success) { alert('已拒绝'); location.reload(); }
    else { alert('操作失败：' + data.message); }
  }).catch(() => alert('系统错误'));
}

function convertToTask() {
  if (confirm('确定要将此需求转换为任务吗？')) {
    location.href = '${pageContext.request.contextPath}/admin/demand/convert-to-task/${demand.id}';
  }
}

function deleteDemand(id, linked) {
  if (linked) {
    alert('该需求已关联任务，不能直接删除');
    return;
  }
  if (!confirm('确定要删除这条需求吗？此操作不可恢复。')) return;
  fetch('${pageContext.request.contextPath}/admin/demand/delete/' + id, { method: 'POST' })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        alert('删除成功');
        location.href = '${pageContext.request.contextPath}/admin/demand/list';
      } else {
        alert('删除失败：' + data.message);
      }
    }).catch(() => alert('系统错误'));
}
</script>
</body>
</html>
