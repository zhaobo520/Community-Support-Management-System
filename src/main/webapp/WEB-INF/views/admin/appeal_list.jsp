<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>申诉管理 - 社区关爱协同平台</title>
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
      position: relative;
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
      transition: opacity 0.3s;
    }
    .gov-header .nav-right a:hover {
      opacity: 0.8;
    }
    .container {
      max-width: 1200px;
      margin: 30px auto;
      padding: 0 20px;
    }
    .page-title {
      font-size: 24px;
      font-weight: 600;
      color: #212121;
      margin-bottom: 20px;
    }
    .filter-bar {
      background: white;
      padding: 20px;
      border-radius: 4px;
      margin-bottom: 20px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      display: flex;
      gap: 15px;
      align-items: center;
    }
    .filter-bar select, .filter-bar input {
      padding: 8px 12px;
      border: 1px solid #E0E0E0;
      border-radius: 2px;
      font-size: 14px;
    }
    .filter-bar button {
      padding: 8px 20px;
      background: #D32F2F;
      color: white;
      border: none;
      border-radius: 2px;
      cursor: pointer;
      font-weight: 600;
    }
    .filter-bar button:hover {
      background: #B71C1C;
    }
    .table-container {
      background: white;
      border-radius: 4px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      overflow: hidden;
    }
    table {
      width: 100%;
      border-collapse: collapse;
    }
    th {
      background: #F5F5F5;
      padding: 16px;
      text-align: left;
      font-weight: 600;
      color: #212121;
      border-bottom: 2px solid #E0E0E0;
      font-size: 14px;
    }
    td {
      padding: 16px;
      border-bottom: 1px solid #E0E0E0;
      font-size: 14px;
      color: #666;
    }
    tr:hover {
      background: #FAFAFA;
    }
    .status-badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 2px;
      font-size: 12px;
      font-weight: 600;
    }
    .status-pending {
      background: #FFF3E0;
      color: #E65100;
    }
    .status-processing {
      background: #E3F2FD;
      color: #1565C0;
    }
    .status-resolved {
      background: #E8F5E9;
      color: #2E7D32;
    }
    .status-rejected {
      background: #FFEBEE;
      color: #C62828;
    }
    .role-badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 2px;
      font-size: 12px;
      font-weight: 600;
      background: #F3E5F5;
      color: #6A1B9A;
    }
    .action-btn {
      padding: 6px 12px;
      background: #D32F2F;
      color: white;
      border: none;
      border-radius: 2px;
      cursor: pointer;
      font-size: 12px;
      text-decoration: none;
      display: inline-block;
    }
    .action-btn:hover {
      background: #B71C1C;
    }
    .empty-state {
      text-align: center;
      padding: 60px 20px;
      color: #999;
    }
    .stats {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 20px;
      margin-bottom: 20px;
    }
    .stat-card {
      background: white;
      padding: 20px;
      border-radius: 4px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      border-left: 4px solid #D32F2F;
      text-align: center;
    }
    .stat-card h3 {
      margin: 0 0 10px 0;
      font-size: 14px;
      color: #666;
    }
    .stat-card .number {
      font-size: 32px;
      font-weight: 700;
      color: #D32F2F;
    }
  </style>
</head>
<body>

<header class="gov-header">
  <h1>社区管理员工作台</h1>
  <div class="nav-right">
    <span>管理员：${currentUser.fullName}</span>
    <a href="${pageContext.request.contextPath}/user/admin/dashboard">返回工作台</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <div class="page-title">申诉管理</div>

  <div class="stats">
    <div class="stat-card">
      <h3>待审核</h3>
      <div class="number">${pendingCount}</div>
    </div>
    <div class="stat-card">
      <h3>处理中</h3>
      <div class="number">${processingCount}</div>
    </div>
    <div class="stat-card">
      <h3>已解决</h3>
      <div class="number">${resolvedCount}</div>
    </div>
    <div class="stat-card">
      <h3>已驳回</h3>
      <div class="number">${rejectedCount}</div>
    </div>
  </div>

  <div class="filter-bar">
    <form method="get" action="${pageContext.request.contextPath}/admin/appeal/list" style="display: flex; gap: 15px; align-items: center;">
      <select name="status">
        <option value="">-- 全部状态 --</option>
        <option value="PENDING" <c:if test="${param.status == 'PENDING'}">selected</c:if>>待审核</option>
        <option value="PROCESSING" <c:if test="${param.status == 'PROCESSING'}">selected</c:if>>处理中</option>
        <option value="RESOLVED" <c:if test="${param.status == 'RESOLVED'}">selected</c:if>>已解决</option>
        <option value="REJECTED" <c:if test="${param.status == 'REJECTED'}">selected</c:if>>已驳回</option>
      </select>
      <select name="userRole">
        <option value="">-- 全部角色 --</option>
        <option value="VOLUNTEER" <c:if test="${param.userRole == 'VOLUNTEER'}">selected</c:if>>志愿者</option>
        <option value="FAMILY" <c:if test="${param.userRole == 'FAMILY'}">selected</c:if>>家属</option>
      </select>
      <input type="text" name="username" placeholder="搜索用户名" value="${param.username}">
      <button type="submit">搜索</button>
    </form>
  </div>

  <div class="table-container">
    <c:if test="${empty appeals}">
      <div class="empty-state">
        <p>暂无申诉记录</p>
      </div>
    </c:if>
    <c:if test="${not empty appeals}">
      <table>
        <thead>
          <tr>
            <th>用户名</th>
            <th>角色</th>
            <th>申诉类型</th>
            <th>状态</th>
            <th>提交时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach items="${appeals}" var="appeal">
            <tr>
              <td>${appeal.username}</td>
              <td>
                <span class="role-badge">
                  <c:if test="${appeal.userRole == 'VOLUNTEER'}">志愿者</c:if>
                  <c:if test="${appeal.userRole == 'FAMILY'}">家属</c:if>
                </span>
              </td>
              <td>${appeal.appealType}</td>
              <td>
                <span class="status-badge status-${fn:toLowerCase(appeal.status)}">
                  <c:if test="${appeal.status == 'PENDING'}">待审核</c:if>
                  <c:if test="${appeal.status == 'PROCESSING'}">处理中</c:if>
                  <c:if test="${appeal.status == 'RESOLVED'}">已解决</c:if>
                  <c:if test="${appeal.status == 'REJECTED'}">已驳回</c:if>
                </span>
              </td>
              <td><fmt:formatDate value="${appeal.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
              <td>
                <a href="${pageContext.request.contextPath}/admin/appeal/detail/${appeal.id}" class="action-btn">查看详情</a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>
  </div>
</div>

</body>
</html>
