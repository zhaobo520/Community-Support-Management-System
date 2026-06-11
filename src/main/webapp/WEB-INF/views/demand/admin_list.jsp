<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>需求管理 - 社区关爱协同平台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    .navbar .actions a { color: white; text-decoration: none; margin-left: 20px; font-weight: 600; font-size: 14px; }
    .stats { display: grid; grid-template-columns: repeat(6, 1fr); gap: 16px; margin-bottom: 32px; }
    .stat-card { background: #fff; border-radius: 4px; padding: 20px; text-align: center; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08); cursor: pointer; transition: all 0.3s; border-left: 4px solid #D32F2F; }
    .stat-card:hover { transform: translateY(-4px); box-shadow: 0 4px 12px rgba(211, 47, 47, 0.15); }
    .stat-card h3 { font-size: 28px; color: #D32F2F; margin-bottom: 8px; }
    .stat-card p { font-size: 13px; color: #64748b; }
    .content { background: #fff; border-radius: 4px; padding: 32px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08); border-left: 4px solid #D32F2F; }
    .header h2 { font-size: 22px; color: #333; margin-bottom: 24px; }
    .demand-table { width: 100%; border-collapse: collapse; }
    .demand-table th { background: #FFF5F5; padding: 14px; text-align: left; font-size: 13px; color: #D32F2F; font-weight: 700; border-bottom: 2px solid #D32F2F; }
    .demand-table td { padding: 16px 14px; border-bottom: 1px solid #f0f0f0; font-size: 14px; vertical-align: top; }
    .demand-table tr:hover { background: #FFF5F5; }
    .status-badge { display: inline-block; padding: 4px 12px; border-radius: 2px; font-size: 12px; font-weight: 700; white-space: nowrap; }
    .status-PENDING { background: #fef3c7; color: #d97706; }
    .status-APPROVED { background: #d1fae5; color: #10b981; }
    .status-REJECTED { background: #fee2e2; color: #ef4444; }
    .status-MATCHED { background: #fee2e2; color: #D32F2F; }
    .status-CLOSED { background: #f3f4f6; color: #6b7280; }
    .urgency-badge { display: inline-block; width: 8px; height: 8px; border-radius: 50%; margin-right: 6px; }
    .urgency-LOW { background: #10b981; }
    .urgency-MEDIUM { background: #f59e0b; }
    .urgency-HIGH { background: #f97316; }
    .urgency-URGENT { background: #ef4444; }
    .actions-cell { display: flex; gap: 8px; flex-wrap: wrap; }
    .btn { padding: 6px 14px; border-radius: 2px; font-size: 13px; font-weight: 600; border: 2px solid #D32F2F; cursor: pointer; transition: all 0.3s; text-decoration: none; display: inline-block; background: white; color: #D32F2F; }
    .btn:hover { background: #D32F2F; color: white; }
    .btn-view { border-color: #D32F2F; color: #D32F2F; }
    .btn-edit { border-color: #2563eb; color: #2563eb; }
    .btn-edit:hover { background: #2563eb; color: white; }
    .btn-delete { border-color: #ef4444; color: #ef4444; }
    .btn-delete:hover { background: #ef4444; color: white; }
    .btn-approve { border-color: #10b981; color: #10b981; }
    .btn-approve:hover { background: #10b981; color: white; }
    .btn-reject { border-color: #ef4444; color: #ef4444; }
    .btn-reject:hover { background: #ef4444; color: white; }
    .empty-state { text-align: center; padding: 60px 20px; color: #94a3b8; }
  </style>
</head>
<body>
<div class="navbar" style="background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%); padding: 0 40px; height: 60px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; border-radius: 4px; position: relative;">
  <div style="position: absolute; left: 20px; color: #B71C1C; font-size: 24px;">★</div>
  <h1 style="color: white; font-size: 20px; font-weight: 600; margin-left: 50px; letter-spacing: 1px;">需求管理</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/user/admin/dashboard">返回控制台</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</div>

<div class="container">
  <div class="stats">
    <div class="stat-card" onclick="location.href='${pageContext.request.contextPath}/admin/demand/list'">
      <h3>${statistics.total}</h3><p>总需求数</p>
    </div>
    <div class="stat-card" onclick="location.href='${pageContext.request.contextPath}/admin/demand/list?status=PENDING'">
      <h3>${statistics.pending}</h3><p>待审核</p>
    </div>
    <div class="stat-card" onclick="location.href='${pageContext.request.contextPath}/admin/demand/list?status=APPROVED'">
      <h3>${statistics.approved}</h3><p>已通过</p>
    </div>
    <div class="stat-card" onclick="location.href='${pageContext.request.contextPath}/admin/demand/list?status=MATCHED'">
      <h3>${statistics.matched}</h3><p>已匹配</p>
    </div>
    <div class="stat-card" onclick="location.href='${pageContext.request.contextPath}/admin/demand/list?status=REJECTED'">
      <h3>${statistics.rejected}</h3><p>已拒绝</p>
    </div>
    <div class="stat-card" onclick="location.href='${pageContext.request.contextPath}/admin/demand/list?status=CLOSED'">
      <h3>${statistics.closed}</h3><p>已关闭</p>
    </div>
  </div>

  <div class="content">
    <div class="header">
      <h2>
        <c:choose>
          <c:when test="${not empty filterStatus}">
            <c:choose>
              <c:when test="${filterStatus == 'PENDING'}">待审核需求</c:when>
              <c:when test="${filterStatus == 'APPROVED'}">已通过需求</c:when>
              <c:when test="${filterStatus == 'REJECTED'}">已拒绝需求</c:when>
              <c:when test="${filterStatus == 'MATCHED'}">已匹配需求</c:when>
              <c:when test="${filterStatus == 'CLOSED'}">已关闭需求</c:when>
            </c:choose>
          </c:when>
          <c:otherwise>全部需求</c:otherwise>
        </c:choose>
      </h2>
    </div>

    <c:choose>
      <c:when test="${empty demandList}">
        <div class="empty-state"><h3>暂无需求数据</h3></div>
      </c:when>
      <c:otherwise>
        <table class="demand-table">
          <thead>
          <tr>
            <th>需求标题</th>
            <th>类型</th>
            <th>紧急程度</th>
            <th>发布人</th>
            <th>意向志愿者</th>
            <th>发布时间</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${demandList}" var="demand">
            <tr>
              <td>
                <strong>${demand.title}</strong>
                <c:if test="${not empty demand.description}">
                  <div style="color:#94a3b8;font-size:12px;margin-top:4px;">
                    ${demand.description.length() > 50 ? demand.description.substring(0,50).concat('...') : demand.description}
                  </div>
                </c:if>
              </td>
              <td>${demand.demandType}</td>
              <td>
                <span class="urgency-badge urgency-${demand.urgency}"></span>
                <c:choose>
                  <c:when test="${demand.urgency == 'LOW'}">不急</c:when>
                  <c:when test="${demand.urgency == 'MEDIUM'}">一般</c:when>
                  <c:when test="${demand.urgency == 'HIGH'}">紧急</c:when>
                  <c:when test="${demand.urgency == 'URGENT'}">非常紧急</c:when>
                </c:choose>
              </td>
              <td>
                ${demand.familyUser.fullName}<br/>
                <span style="color:#94a3b8;font-size:12px;">${demand.familyUser.phone}</span>
              </td>
              <td>
                <c:choose>
                  <c:when test="${not empty demand.intendedVolunteer}">
                    <strong style="color:#D32F2F;">${demand.intendedVolunteer.fullName}</strong>
                    <c:if test="${not empty demand.intendedVolunteer.phone}">
                      <br/><span style="color:#94a3b8;font-size:12px;">${demand.intendedVolunteer.phone}</span>
                    </c:if>
                  </c:when>
                  <c:otherwise>
                    <span style="color:#94a3b8;font-size:12px;">未指定</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td><fmt:formatDate value="${demand.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
              <td>
                <span class="status-badge status-${demand.status}">
                  <c:choose>
                    <c:when test="${demand.status == 'PENDING'}">待审核</c:when>
                    <c:when test="${demand.status == 'APPROVED'}">已通过</c:when>
                    <c:when test="${demand.status == 'REJECTED'}">已拒绝</c:when>
                    <c:when test="${demand.status == 'MATCHED'}">已匹配</c:when>
                    <c:when test="${demand.status == 'CLOSED'}">已关闭</c:when>
                  </c:choose>
                </span>
              </td>
              <td>
                <div class="actions-cell">
                  <a href="${pageContext.request.contextPath}/admin/demand/detail/${demand.id}" class="btn btn-view">查看</a>
                  <a href="${pageContext.request.contextPath}/admin/demand/edit/${demand.id}" class="btn btn-edit">修改</a>
                  <button type="button" class="btn btn-delete" onclick="deleteDemand(${demand.id}, ${demand.taskId != null || demand.status == 'MATCHED'})">删除</button>
                  <c:if test="${demand.status == 'PENDING'}">
                    <button type="button" class="btn btn-approve" onclick="approveDemand(${demand.id})">通过</button>
                    <button type="button" class="btn btn-reject" onclick="rejectDemand(${demand.id})">拒绝</button>
                  </c:if>
                </div>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<script>
function approveDemand(id) {
  const comment = prompt('审核意见（可选）：');
  if (comment === null) return;
  fetch('${pageContext.request.contextPath}/admin/demand/approve/' + id, {
    method: 'POST',
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: 'reviewComment=' + encodeURIComponent(comment || '')
  }).then(res => res.json()).then(data => {
    if (data.success) { alert('审核通过！'); location.reload(); }
    else { alert('操作失败：' + data.message); }
  }).catch(() => alert('系统错误'));
}

function rejectDemand(id) {
  const comment = prompt('请输入拒绝原因：');
  if (!comment) { alert('请输入拒绝原因'); return; }
  fetch('${pageContext.request.contextPath}/admin/demand/reject/' + id, {
    method: 'POST',
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: 'reviewComment=' + encodeURIComponent(comment)
  }).then(res => res.json()).then(data => {
    if (data.success) { alert('已拒绝'); location.reload(); }
    else { alert('操作失败：' + data.message); }
  }).catch(() => alert('系统错误'));
}

function deleteDemand(id, linked) {
  if (linked) {
    alert('该需求已关联任务，不能直接删除');
    return;
  }
  if (!confirm('确定要删除这条需求吗？此操作不可恢复。')) return;
  fetch('${pageContext.request.contextPath}/admin/demand/delete/' + id, {
    method: 'POST'
  }).then(res => res.json()).then(data => {
    if (data.success) { alert('删除成功'); location.reload(); }
    else { alert('删除失败：' + data.message); }
  }).catch(() => alert('系统错误'));
}
</script>
</body>
</html>
