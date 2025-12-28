<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>个人信息维护</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: 'Microsoft YaHei', Arial, sans-serif;
      background: #FAF5F0;
      min-height: 100vh;
      padding: 40px 20px;
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
      margin-bottom: 40px;
      border-radius: 4px;
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
      margin: 0;
    }
    .wrapper {
      max-width: 720px;
      margin: 0 auto;
      background: #fff;
      padding: 40px;
      border-radius: 4px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      border-left: 4px solid #D32F2F;
    }
    h2 {
      margin-top: 0;
      color: #212121;
      font-size: 24px;
      margin-bottom: 30px;
      padding-bottom: 15px;
      border-bottom: 2px solid #f0f0f0;
    }
    label {
      display: block;
      font-weight: 600;
      margin-bottom: 8px;
      color: #666;
      font-size: 14px;
    }
    input {
      width: 100%;
      padding: 12px 16px;
      border-radius: 2px;
      border: 2px solid #e0e0e0;
      margin-bottom: 20px;
      font-size: 15px;
      transition: all 0.3s;
    }
    input:focus {
      outline: none;
      border-color: #D32F2F;
      box-shadow: 0 0 0 3px rgba(211, 47, 47, 0.1);
    }
    button {
      width: 100%;
      padding: 14px;
      border-radius: 2px;
      border: 2px solid #D32F2F;
      background: white;
      color: #D32F2F;
      font-size: 16px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.3s;
    }
    button:hover {
      background: #D32F2F;
      color: white;
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(211, 47, 47, 0.3);
    }
    .msg {
      padding: 12px 20px;
      background: #d1fae5;
      border-radius: 2px;
      color: #065f46;
      margin-bottom: 20px;
      border-left: 4px solid #10b981;
    }
  </style>
</head>
<body>
<div class="gov-header">
  <h1>个人信息维护</h1>
</div>
<div class="wrapper">
  <h2>个人信息维护</h2>
  <c:if test="${not empty msg}">
    <div class="msg">${msg}</div>
  </c:if>
  <form action="${pageContext.request.contextPath}/user/profile" method="post">
    <input type="hidden" name="id" value="${currentUser.id}">
    <label>姓名</label>
    <input type="text" name="fullName" value="${currentUser.fullName}" required>

    <label>手机号</label>
    <input type="text" name="phone" value="${currentUser.phone}" required>

    <label>邮箱</label>
    <input type="email" name="email" value="${currentUser.email}">

    <button type="submit">保存修改</button>
  </form>
</div>
</body>
</html>
