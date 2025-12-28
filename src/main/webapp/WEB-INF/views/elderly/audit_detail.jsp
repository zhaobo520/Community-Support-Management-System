<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>审核关爱人员 - 管理后台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: #FAF5F0; min-height: 100vh; padding-bottom: 40px; }
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
      max-width: 900px;
      margin: 40px auto;
      background: #fff;
      border-radius: 8px;
      padding: 40px 50px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }
    .page-title {
      font-size: 24px;
      color: #1e293b;
      margin-bottom: 24px;
      padding-bottom: 16px;
      border-bottom: 3px solid #D32F2F;
      font-weight: 700;
    }
    .section {
      margin-bottom: 32px;
    }
    .section-title {
      font-size: 18px;
      color: #1e293b;
      margin-bottom: 16px;
      padding-bottom: 8px;
      border-bottom: 2px solid #e2e8f0;
      font-weight: 600;
    }
    .photo-display {
      text-align: center;
      padding: 20px;
      background: #f8fafc;
      border-radius: 8px;
      margin-bottom: 24px;
    }
    .photo-display img {
      max-width: 300px;
      max-height: 300px;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      object-fit: cover;
    }
    .photo-display .no-photo {
      width: 200px;
      height: 200px;
      margin: 0 auto;
      background: linear-gradient(135deg, #B71C1C, #D32F2F);
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 72px;
      font-weight: 700;
    }
    .photo-display p {
      margin-top: 12px;
      color: #64748b;
      font-size: 14px;
    }
    .info-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 16px;
    }
    .info-item {
      padding: 12px 16px;
      background: #f8fafc;
      border-radius: 6px;
    }
    .info-item.full {
      grid-column: 1 / -1;
    }
    .info-label {
      font-size: 13px;
      color: #64748b;
      margin-bottom: 4px;
    }
    .info-value {
      font-size: 15px;
      color: #1e293b;
      font-weight: 500;
    }
    .care-level {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 4px;
      font-size: 13px;
      font-weight: 600;
    }
    .care-urgent { background: rgba(239,68,68,0.15); color: #dc2626; }
    .care-high { background: rgba(249,115,22,0.15); color: #ea580c; }
    .care-medium { background: rgba(234,179,8,0.15); color: #ca8a04; }
    .care-low { background: rgba(16,185,129,0.15); color: #059669; }
    .submitter-info {
      background: rgba(59,130,246,0.1);
      border-left: 4px solid #3b82f6;
      padding: 16px;
      border-radius: 4px;
      margin-bottom: 24px;
    }
    .submitter-info h4 {
      font-size: 15px;
      color: #1e40af;
      margin-bottom: 8px;
    }
    .submitter-info p {
      font-size: 14px;
      color: #475569;
      margin-bottom: 4px;
    }
    .audit-form {
      background: #f8fafc;
      padding: 24px;
      border-radius: 8px;
      margin-top: 24px;
    }
    .audit-form h3 {
      font-size: 16px;
      color: #1e293b;
      margin-bottom: 16px;
    }
    .audit-form textarea {
      width: 100%;
      padding: 12px;
      border: 1px solid #e2e8f0;
      border-radius: 6px;
      font-size: 14px;
      min-height: 100px;
      resize: vertical;
      margin-bottom: 16px;
    }
    .audit-form textarea:focus {
      outline: none;
      border-color: #D32F2F;
    }
    .audit-actions {
      display: flex;
      gap: 12px;
      justify-content: center;
    }
    .btn {
      padding: 12px 32px;
      border: none;
      border-radius: 6px;
      font-size: 15px;
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
    .btn-back {
      background: #f1f5f9;
      color: #475569;
    }
    .btn-back:hover {
      background: #e2e8f0;
    }
    @media (max-width: 768px) {
      .gov-header { padding: 0 16px; }
      .container { margin: 20px 16px; padding: 24px 20px; }
      .info-grid { grid-template-columns: 1fr; }
      .audit-actions { flex-direction: column; }
    }
  </style>
</head>
<body>
<header class="gov-header">
  <h1>审核关爱人员</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/admin/elderly/audit/list">返回审核列表</a>
    <a href="${pageContext.request.contextPath}/user/admin/dashboard">控制台</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <h1 class="page-title">审核关爱人员信息</h1>

  <!-- 提交人信息 -->
  <c:if test="${not empty familyUser}">
    <div class="submitter-info">
      <h4>提交人信息</h4>
      <p><strong>姓名：</strong>${familyUser.fullName}</p>
      <p><strong>联系电话：</strong>${familyUser.phone}</p>
      <p><strong>与关爱对象关系：</strong>${elderlyInfo.familyContact}</p>
    </div>
  </c:if>

  <!-- 照片展示 -->
  <div class="section">
    <div class="section-title">关爱对象照片</div>
    <div class="photo-display">
      <c:choose>
        <c:when test="${not empty elderlyInfo.photoUrl}">
          <c:choose>
            <c:when test="${fn:startsWith(elderlyInfo.photoUrl, pageContext.request.contextPath)}">
              <img src="${elderlyInfo.photoUrl}" alt="${elderlyInfo.name}的照片">
            </c:when>
            <c:otherwise>
              <img src="${pageContext.request.contextPath}${elderlyInfo.photoUrl}" alt="${elderlyInfo.name}的照片">
            </c:otherwise>
          </c:choose>
          <p>照片已上传</p>
        </c:when>
        <c:otherwise>
          <div class="no-photo">${elderlyInfo.name.substring(0,1)}</div>
          <p>暂未上传照片</p>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <!-- 基本信息 -->
  <div class="section">
    <div class="section-title">基本信息</div>
    <div class="info-grid">
      <div class="info-item">
        <div class="info-label">姓名</div>
        <div class="info-value">${elderlyInfo.name}</div>
      </div>
      <div class="info-item">
        <div class="info-label">身份证号</div>
        <div class="info-value">${not empty elderlyInfo.idCard ? elderlyInfo.idCard : '未填写'}</div>
      </div>
      <div class="info-item">
        <div class="info-label">性别</div>
        <div class="info-value">${elderlyInfo.gender == 'MALE' ? '男' : '女'}</div>
      </div>
      <div class="info-item">
        <div class="info-label">年龄</div>
        <div class="info-value">${elderlyInfo.age}岁</div>
      </div>
      <div class="info-item">
        <div class="info-label">出生日期</div>
        <div class="info-value">
          <c:choose>
            <c:when test="${not empty elderlyInfo.birthDate}">
              <fmt:formatDate value="${elderlyInfo.birthDate}" pattern="yyyy-MM-dd"/>
            </c:when>
            <c:otherwise>未填写</c:otherwise>
          </c:choose>
        </div>
      </div>
      <div class="info-item">
        <div class="info-label">联系电话</div>
        <div class="info-value">${not empty elderlyInfo.phone ? elderlyInfo.phone : '未填写'}</div>
      </div>
      <div class="info-item full">
        <div class="info-label">居住地址</div>
        <div class="info-value">${not empty elderlyInfo.address ? elderlyInfo.address : '未填写'}</div>
      </div>
    </div>
  </div>

  <!-- 健康状况 -->
  <div class="section">
    <div class="section-title">健康状况</div>
    <div class="info-grid">
      <div class="info-item">
        <div class="info-label">健康状况</div>
        <div class="info-value">${not empty elderlyInfo.healthStatus ? elderlyInfo.healthStatus : '未填写'}</div>
      </div>
      <div class="info-item">
        <div class="info-label">残疾等级</div>
        <div class="info-value">${not empty elderlyInfo.disabilityLevel ? elderlyInfo.disabilityLevel : '无'}</div>
      </div>
      <div class="info-item">
        <div class="info-label">是否独居</div>
        <div class="info-value">${elderlyInfo.livingAlone == 1 ? '是' : '否'}</div>
      </div>
      <div class="info-item">
        <div class="info-label">关爱等级</div>
        <div class="info-value">
          <span class="care-level ${elderlyInfo.careLevel == 'URGENT' ? 'care-urgent' : elderlyInfo.careLevel == 'HIGH' ? 'care-high' : elderlyInfo.careLevel == 'MEDIUM' ? 'care-medium' : 'care-low'}">
            <c:choose>
              <c:when test="${elderlyInfo.careLevel == 'URGENT'}">紧急</c:when>
              <c:when test="${elderlyInfo.careLevel == 'HIGH'}">高等级</c:when>
              <c:when test="${elderlyInfo.careLevel == 'MEDIUM'}">中等级</c:when>
              <c:otherwise>低等级</c:otherwise>
            </c:choose>
          </span>
        </div>
      </div>
    </div>
  </div>

  <!-- 特殊需求 -->
  <c:if test="${not empty elderlyInfo.specialNeeds}">
    <div class="section">
      <div class="section-title">特殊需求</div>
      <div class="info-item full">
        <div class="info-value">${elderlyInfo.specialNeeds}</div>
      </div>
    </div>
  </c:if>

  <!-- 审核操作 -->
  <div class="audit-form">
    <h3>审核操作</h3>
    <form id="auditForm">
      <input type="hidden" name="id" value="${elderlyInfo.id}"/>
      <textarea name="remark" id="auditRemark" placeholder="请输入审核备注（拒绝时必填）..."></textarea>
      <div class="audit-actions">
        <a href="${pageContext.request.contextPath}/admin/elderly/audit/list" class="btn btn-back">返回列表</a>
        <button type="button" class="btn btn-reject" onclick="doReject()">拒绝</button>
        <button type="button" class="btn btn-approve" onclick="doApprove()">通过</button>
      </div>
    </form>
  </div>
</div>

<script>
function doApprove() {
  if (!confirm('确定要通过该关爱人员的审核吗？')) return;

  var remark = document.getElementById('auditRemark').value;

  fetch('${pageContext.request.contextPath}/admin/elderly/audit/do', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: 'id=${elderlyInfo.id}&action=approve&remark=' + encodeURIComponent(remark)
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      alert('审核通过');
      window.location.href = '${pageContext.request.contextPath}/admin/elderly/audit/list';
    } else {
      alert(data.message || '操作失败');
    }
  })
  .catch(error => {
    console.error('Error:', error);
    alert('操作失败');
  });
}

function doReject() {
  var remark = document.getElementById('auditRemark').value.trim();
  if (!remark) {
    alert('请输入拒绝原因');
    document.getElementById('auditRemark').focus();
    return;
  }

  if (!confirm('确定要拒绝该关爱人员的申请吗？')) return;

  fetch('${pageContext.request.contextPath}/admin/elderly/audit/do', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: 'id=${elderlyInfo.id}&action=reject&remark=' + encodeURIComponent(remark)
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      alert('已拒绝该申请');
      window.location.href = '${pageContext.request.contextPath}/admin/elderly/audit/list';
    } else {
      alert(data.message || '操作失败');
    }
  })
  .catch(error => {
    console.error('Error:', error);
    alert('操作失败');
  });
}
</script>
</body>
</html>
