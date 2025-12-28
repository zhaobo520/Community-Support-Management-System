<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>关爱人员审核 - 管理后台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: #FAF5F0; min-height: 100vh; }
    .gov-header {
      background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
      height: 60px;
      padding: 0 40px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }
    .gov-header h1 {
      color: white;
      font-size: 20px;
      font-weight: 600;
    }
    .gov-header .actions {
      display: flex;
      gap: 20px;
    }
    .gov-header .actions a {
      color: white;
      text-decoration: none;
      font-size: 14px;
      padding: 6px 16px;
      border-radius: 4px;
      transition: background 0.3s;
    }
    .gov-header .actions a:hover {
      background: rgba(255,255,255,0.2);
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 30px 20px;
    }
    .page-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24px;
    }
    .page-title {
      font-size: 24px;
      color: #1e293b;
      font-weight: 700;
    }
    .pending-badge {
      background: #D32F2F;
      color: white;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 14px;
      font-weight: 600;
      margin-left: 12px;
    }
    .alert {
      padding: 12px 16px;
      border-radius: 6px;
      margin-bottom: 20px;
      font-size: 14px;
    }
    .alert-success {
      background: rgba(16,185,129,0.1);
      border-left: 4px solid #10b981;
      color: #059669;
    }
    .alert-error {
      background: rgba(239,68,68,0.1);
      border-left: 4px solid #ef4444;
      color: #dc2626;
    }
    .audit-table {
      width: 100%;
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
      overflow: hidden;
    }
    .audit-table table {
      width: 100%;
      border-collapse: collapse;
    }
    .audit-table th,
    .audit-table td {
      padding: 16px;
      text-align: left;
      border-bottom: 1px solid #f1f5f9;
    }
    .audit-table th {
      background: #f8fafc;
      font-weight: 600;
      color: #475569;
      font-size: 14px;
    }
    .audit-table td {
      font-size: 14px;
      color: #1e293b;
    }
    .audit-table tr:hover {
      background: #fef9f3;
    }
    .avatar {
      width: 48px;
      height: 48px;
      border-radius: 8px;
      background: linear-gradient(135deg, #B71C1C, #D32F2F);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 18px;
      font-weight: 700;
      overflow: hidden;
    }
    .avatar img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .info-cell {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .info-text h4 {
      font-size: 15px;
      color: #1e293b;
      margin-bottom: 2px;
    }
    .info-text p {
      font-size: 13px;
      color: #64748b;
    }
    .care-level {
      display: inline-block;
      padding: 4px 10px;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 600;
    }
    .care-urgent { background: rgba(239,68,68,0.15); color: #dc2626; }
    .care-high { background: rgba(249,115,22,0.15); color: #ea580c; }
    .care-medium { background: rgba(234,179,8,0.15); color: #ca8a04; }
    .care-low { background: rgba(16,185,129,0.15); color: #059669; }
    .btn-group {
      display: flex;
      gap: 8px;
    }
    .btn {
      padding: 8px 16px;
      border: none;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
    }
    .btn-approve {
      background: #10b981;
      color: white;
    }
    .btn-approve:hover {
      background: #059669;
    }
    .btn-reject {
      background: #ef4444;
      color: white;
    }
    .btn-reject:hover {
      background: #dc2626;
    }
    .btn-detail {
      background: #f1f5f9;
      color: #475569;
    }
    .btn-detail:hover {
      background: #e2e8f0;
    }
    .empty-state {
      text-align: center;
      padding: 60px 20px;
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    }
    .empty-icon {
      font-size: 64px;
      margin-bottom: 16px;
    }
    .empty-title {
      font-size: 20px;
      color: #1e293b;
      margin-bottom: 8px;
    }
    .empty-desc {
      color: #64748b;
    }
    /* 弹窗样式 */
    .modal-overlay {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0,0,0,0.5);
      z-index: 1000;
      align-items: center;
      justify-content: center;
    }
    .modal-overlay.active {
      display: flex;
    }
    .modal-content {
      background: white;
      border-radius: 12px;
      padding: 32px;
      max-width: 500px;
      width: 90%;
      box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    }
    .modal-title {
      font-size: 20px;
      color: #1e293b;
      margin-bottom: 16px;
      font-weight: 700;
    }
    .modal-body {
      margin-bottom: 24px;
    }
    .modal-body textarea {
      width: 100%;
      padding: 12px;
      border: 1px solid #e2e8f0;
      border-radius: 6px;
      font-size: 14px;
      min-height: 100px;
      resize: vertical;
    }
    .modal-body textarea:focus {
      outline: none;
      border-color: #D32F2F;
    }
    .modal-actions {
      display: flex;
      gap: 12px;
      justify-content: flex-end;
    }
    .modal-btn {
      padding: 10px 24px;
      border: none;
      border-radius: 6px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
    }
    .modal-btn-cancel {
      background: #f1f5f9;
      color: #475569;
    }
    .modal-btn-confirm {
      background: #ef4444;
      color: white;
    }
    @media (max-width: 768px) {
      .gov-header { padding: 0 16px; }
      .container { padding: 20px 16px; }
      .audit-table { overflow-x: auto; }
      .btn-group { flex-direction: column; }
    }
  </style>
</head>
<body>
<header class="gov-header">
  <h1>关爱人员审核</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/admin/elderly/list">关爱对象管理</a>
    <a href="${pageContext.request.contextPath}/user/admin/dashboard">返回控制台</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-error">${error}</div>
  </c:if>

  <div class="page-header">
    <h1 class="page-title">
      待审核关爱人员
      <c:if test="${pendingCount > 0}">
        <span class="pending-badge">${pendingCount}</span>
      </c:if>
    </h1>
  </div>

  <c:choose>
    <c:when test="${not empty pendingList}">
      <div class="audit-table">
        <table>
          <thead>
            <tr>
              <th>关爱人员</th>
              <th>联系电话</th>
              <th>居住地址</th>
              <th>关爱等级</th>
              <th>提交人</th>
              <th>提交时间</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${pendingList}" var="elderly">
              <tr>
                <td>
                  <div class="info-cell">
                    <div class="avatar">
                      <c:choose>
                        <c:when test="${not empty elderly.photoUrl}">
                          <img src="${pageContext.request.contextPath}${elderly.photoUrl}" alt="${elderly.name}">
                        </c:when>
                        <c:otherwise>
                          ${elderly.name.substring(0,1)}
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <div class="info-text">
                      <h4>${elderly.name}</h4>
                      <p>${elderly.age}岁 · ${elderly.gender == 'MALE' ? '男' : '女'} · ${elderly.livingAlone == 1 ? '独居' : '非独居'}</p>
                    </div>
                  </div>
                </td>
                <td>${elderly.phone}</td>
                <td>${elderly.address}</td>
                <td>
                  <span class="care-level ${elderly.careLevel == 'URGENT' ? 'care-urgent' : elderly.careLevel == 'HIGH' ? 'care-high' : elderly.careLevel == 'MEDIUM' ? 'care-medium' : 'care-low'}">
                    <c:choose>
                      <c:when test="${elderly.careLevel == 'URGENT'}">紧急</c:when>
                      <c:when test="${elderly.careLevel == 'HIGH'}">高等级</c:when>
                      <c:when test="${elderly.careLevel == 'MEDIUM'}">中等级</c:when>
                      <c:otherwise>低等级</c:otherwise>
                    </c:choose>
                  </span>
                </td>
                <td>${elderly.familyContact}</td>
                <td><fmt:formatDate value="${elderly.createdTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td>
                  <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/admin/elderly/audit/detail/${elderly.id}" class="btn btn-detail">详情</a>
                    <button class="btn btn-approve" onclick="doApprove(${elderly.id})">通过</button>
                    <button class="btn btn-reject" onclick="showRejectModal(${elderly.id})">拒绝</button>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:when>
    <c:otherwise>
      <div class="empty-state">
        <div class="empty-icon">&#9989;</div>
        <div class="empty-title">暂无待审核申请</div>
        <div class="empty-desc">所有关爱人员申请都已处理完毕</div>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<!-- 拒绝原因弹窗 -->
<div class="modal-overlay" id="rejectModal">
  <div class="modal-content">
    <h3 class="modal-title">拒绝原因</h3>
    <div class="modal-body">
      <textarea id="rejectRemark" placeholder="请输入拒绝原因，以便家属了解并修改..."></textarea>
    </div>
    <div class="modal-actions">
      <button class="modal-btn modal-btn-cancel" onclick="closeRejectModal()">取消</button>
      <button class="modal-btn modal-btn-confirm" onclick="doReject()">确认拒绝</button>
    </div>
  </div>
</div>

<script>
var currentRejectId = null;

function doApprove(id) {
  if (!confirm('确定要通过该关爱人员的审核吗？')) return;

  fetch('${pageContext.request.contextPath}/admin/elderly/audit/do', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: 'id=' + id + '&action=approve'
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      alert('审核通过');
      location.reload();
    } else {
      alert(data.message || '操作失败');
    }
  })
  .catch(error => {
    console.error('Error:', error);
    alert('操作失败');
  });
}

function showRejectModal(id) {
  currentRejectId = id;
  document.getElementById('rejectRemark').value = '';
  document.getElementById('rejectModal').classList.add('active');
}

function closeRejectModal() {
  currentRejectId = null;
  document.getElementById('rejectModal').classList.remove('active');
}

function doReject() {
  var remark = document.getElementById('rejectRemark').value.trim();
  if (!remark) {
    alert('请输入拒绝原因');
    return;
  }

  fetch('${pageContext.request.contextPath}/admin/elderly/audit/do', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: 'id=' + currentRejectId + '&action=reject&remark=' + encodeURIComponent(remark)
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      alert('已拒绝该申请');
      location.reload();
    } else {
      alert(data.message || '操作失败');
    }
  })
  .catch(error => {
    console.error('Error:', error);
    alert('操作失败');
  });

  closeRejectModal();
}
</script>
</body>
</html>
