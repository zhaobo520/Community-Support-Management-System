<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>申诉详情 - 社区关爱协同平台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    body {
      background: #FAF5F0;
      margin: 0;
      padding: 0;
    }
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
      margin: 0;
      margin-left: 50px;
      letter-spacing: 1px;
    }
    .gov-header .nav-right {
      display: flex;
      align-items: center;
      gap: 30px;
      color: white;
      font-size: 14px;
    }
    .gov-header .nav-right a {
      color: white;
      text-decoration: none;
    }
    .container {
      max-width: 1000px;
      margin: 30px auto;
      padding: 0 20px;
    }
    .breadcrumb {
      font-size: 14px;
      color: #666;
      margin-bottom: 20px;
    }
    .breadcrumb a {
      color: #D32F2F;
      text-decoration: none;
    }
    .detail-card {
      background: white;
      border-radius: 4px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      overflow: hidden;
      border-left: 4px solid #D32F2F;
    }
    .card-header {
      background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
      padding: 20px;
      color: white;
    }
    .card-header h1 {
      margin: 0;
      font-size: 20px;
    }
    .status-badges {
      display: flex;
      gap: 15px;
      margin-top: 10px;
    }
    .status-badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 2px;
      font-size: 12px;
      font-weight: 600;
      background: rgba(255,255,255,0.2);
      color: white;
    }
    .card-body {
      padding: 30px;
    }
    .info-section {
      margin-bottom: 30px;
    }
    .info-section h2 {
      font-size: 16px;
      font-weight: 600;
      color: #212121;
      margin-top: 0;
      margin-bottom: 15px;
      padding-bottom: 10px;
      border-bottom: 2px solid #f0f0f0;
    }
    .info-row {
      display: grid;
      grid-template-columns: 200px 1fr;
      gap: 20px;
      margin-bottom: 15px;
      padding-bottom: 15px;
      border-bottom: 1px solid #F5F5F5;
    }
    .info-row:last-child {
      border-bottom: none;
      margin-bottom: 0;
      padding-bottom: 0;
    }
    .info-label {
      font-weight: 600;
      color: #333;
      font-size: 14px;
    }
    .info-value {
      color: #666;
      font-size: 14px;
      word-wrap: break-word;
    }
    .description-box {
      background: #F9F9F9;
      padding: 15px;
      border-radius: 2px;
      border-left: 3px solid #D32F2F;
      line-height: 1.6;
      color: #555;
      white-space: pre-wrap;
      word-wrap: break-word;
    }
    .review-section {
      background: #FFF8F8;
      padding: 20px;
      border-radius: 4px;
      border: 1px solid #FFE0E0;
      margin-top: 20px;
    }
    .review-section h3 {
      margin-top: 0;
      color: #D32F2F;
      font-size: 16px;
    }
    .form-group {
      margin-bottom: 15px;
    }
    .form-group label {
      display: block;
      font-weight: 600;
      color: #333;
      margin-bottom: 8px;
      font-size: 14px;
    }
    .form-group select, .form-group textarea {
      width: 100%;
      padding: 10px 12px;
      border: 1px solid #E0E0E0;
      border-radius: 2px;
      font-size: 14px;
      font-family: 'Microsoft YaHei', Arial, sans-serif;
      box-sizing: border-box;
    }
    .form-group textarea {
      resize: vertical;
      min-height: 120px;
    }
    .form-group select:focus, .form-group textarea:focus {
      outline: none;
      border-color: #D32F2F;
      box-shadow: 0 0 0 2px rgba(211, 47, 47, 0.1);
    }
    .btn-group {
      display: flex;
      gap: 15px;
      margin-top: 20px;
      justify-content: flex-end;
    }
    .btn {
      padding: 10px 24px;
      border: none;
      border-radius: 2px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
      text-decoration: none;
      display: inline-block;
    }
    .btn-primary {
      background: #D32F2F;
      color: white;
    }
    .btn-primary:hover {
      background: #B71C1C;
    }
    .btn-default {
      background: #f5f5f5;
      color: #666;
      border: 1px solid #e0e0e0;
    }
    .btn-default:hover {
      background: #e0e0e0;
    }
    .response-box {
      background: #E8F5E9;
      padding: 15px;
      border-radius: 2px;
      border-left: 3px solid #2E7D32;
      margin-top: 10px;
    }
    .response-box h4 {
      margin-top: 0;
      color: #2E7D32;
    }
  </style>
</head>
<body>

<header class="gov-header">
  <h1>社区管理员工作台</h1>
  <div class="nav-right">
    <span>管理员：${currentUser.fullName}</span>
    <a href="${pageContext.request.contextPath}/admin/appeal/list">申诉列表</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/user/admin/dashboard">工作台</a> &gt;
    <a href="${pageContext.request.contextPath}/admin/appeal/list">申诉管理</a> &gt;
    申诉详情
  </div>

  <div class="detail-card">
    <div class="card-header">
      <h1>申诉详情</h1>
      <div class="status-badges">
        <span class="status-badge">
          <c:if test="${appeal.userRole == 'VOLUNTEER'}">志愿者</c:if>
          <c:if test="${appeal.userRole == 'FAMILY'}">家属</c:if>
        </span>
        <span class="status-badge">
          <c:if test="${appeal.status == 'PENDING'}">待审核</c:if>
          <c:if test="${appeal.status == 'PROCESSING'}">处理中</c:if>
          <c:if test="${appeal.status == 'RESOLVED'}">已解决</c:if>
          <c:if test="${appeal.status == 'REJECTED'}">已驳回</c:if>
        </span>
      </div>
    </div>

    <div class="card-body">
      <div class="info-section">
        <h2>申诉人信息</h2>
        <div class="info-row">
          <div class="info-label">用户名</div>
          <div class="info-value">${appeal.username}</div>
        </div>
        <div class="info-row">
          <div class="info-label">手机号</div>
          <div class="info-value">${appeal.phone}</div>
        </div>
        <div class="info-row">
          <div class="info-label">用户角色</div>
          <div class="info-value">
            <c:if test="${appeal.userRole == 'VOLUNTEER'}">志愿者</c:if>
            <c:if test="${appeal.userRole == 'FAMILY'}">家属</c:if>
          </div>
        </div>
      </div>

      <div class="info-section">
        <h2>申诉内容</h2>
        <div class="info-row">
          <div class="info-label">申诉类型</div>
          <div class="info-value">${appeal.appealType}</div>
        </div>
        <div class="info-row">
          <div class="info-label">申诉描述</div>
          <div class="info-value">
            <div class="description-box">${appeal.description}</div>
          </div>
        </div>
        <c:if test="${not empty appeal.attachment}">
          <div class="info-row">
            <div class="info-label">补充附件</div>
            <div class="info-value">${appeal.attachment}</div>
          </div>
        </c:if>
      </div>

      <div class="info-section">
        <h2>提交信息</h2>
        <div class="info-row">
          <div class="info-label">提交时间</div>
          <div class="info-value"><fmt:formatDate value="${appeal.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
        </div>
      </div>

      <c:if test="${not empty appeal.response}">
        <div class="info-section">
          <h2>审核回复</h2>
          <div class="info-row">
            <div class="info-label">处理状态</div>
            <div class="info-value">
              <c:if test="${appeal.status == 'PENDING'}">待审核</c:if>
              <c:if test="${appeal.status == 'PROCESSING'}">处理中</c:if>
              <c:if test="${appeal.status == 'RESOLVED'}">已解决</c:if>
              <c:if test="${appeal.status == 'REJECTED'}">已驳回</c:if>
            </div>
          </div>
          <div class="info-row">
            <div class="info-label">回复内容</div>
            <div class="info-value">
              <div class="response-box">
                <h4>管理员回复</h4>
                <div style="white-space: pre-wrap; word-wrap: break-word;">${appeal.response}</div>
              </div>
            </div>
          </div>
          <c:if test="${not empty appeal.respondedByName}">
            <div class="info-row">
              <div class="info-label">处理人</div>
              <div class="info-value">${appeal.respondedByName}</div>
            </div>
          </c:if>
          <c:if test="${not empty appeal.respondedAt}">
            <div class="info-row">
              <div class="info-label">处理时间</div>
              <div class="info-value"><fmt:formatDate value="${appeal.respondedAt}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
            </div>
          </c:if>
        </div>
      </c:if>

      <c:if test="${appeal.status == 'PENDING' || appeal.status == 'PROCESSING'}">
        <div class="review-section">
          <h3>审核处理</h3>
          <form method="post" action="${pageContext.request.contextPath}/admin/appeal/review">
            <input type="hidden" name="id" value="${appeal.id}">

            <div class="form-group">
              <label for="status">处理状态 <span style="color: #D32F2F;">*</span></label>
              <select id="status" name="status" required>
                <option value="">-- 请选择处理状态 --</option>
                <option value="PROCESSING" <c:if test="${appeal.status == 'PROCESSING'}">selected</c:if>>处理中</option>
                <option value="RESOLVED" <c:if test="${appeal.status == 'RESOLVED'}">selected</c:if>>已解决</option>
                <option value="REJECTED" <c:if test="${appeal.status == 'REJECTED'}">selected</c:if>>已驳回</option>
              </select>
            </div>

            <div class="form-group">
              <label for="response">回复内容 <span style="color: #D32F2F;">*</span></label>
              <textarea id="response" name="response" placeholder="请输入您的处理意见或回复内容..." required>${appeal.response}</textarea>
            </div>

            <div class="btn-group">
              <a href="${pageContext.request.contextPath}/admin/appeal/list" class="btn btn-default">返回列表</a>
              <button type="submit" class="btn btn-primary">提交审核</button>
            </div>
          </form>
        </div>
      </c:if>

      <c:if test="${appeal.status == 'RESOLVED' || appeal.status == 'REJECTED'}">
        <div class="btn-group">
          <a href="${pageContext.request.contextPath}/admin/appeal/list" class="btn btn-default">返回列表</a>
        </div>
      </c:if>
    </div>
  </div>
</div>

</body>
</html>
