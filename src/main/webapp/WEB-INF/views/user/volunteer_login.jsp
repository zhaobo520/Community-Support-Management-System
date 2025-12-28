<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>志愿者登录 - 社区关爱协同平台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { box-sizing: border-box; }
    body {
      margin: 0;
      padding: 0;
      background: #FAF5F0;
      font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      min-height: 100vh;
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
    .gov-header .nav-right a {
      color: rgba(255,255,255,0.9);
      text-decoration: none;
      font-size: 14px;
      padding: 8px 16px;
      border-radius: 4px;
      transition: all 0.3s;
    }
    .gov-header .nav-right a:hover {
      background: rgba(255,255,255,0.15);
      color: white;
    }
    .login-wrapper {
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: calc(100vh - 64px);
      padding: 48px 24px;
    }
    .login-container {
      width: 100%;
      max-width: 400px;
      background: white;
      border-radius: 8px;
      box-shadow: 0 4px 24px rgba(0,0,0,0.08);
      overflow: hidden;
    }
    .login-header {
      background: linear-gradient(135deg, #B71C1C 0%, #D32F2F 100%);
      padding: 28px 32px;
      text-align: center;
      color: white;
    }
    .login-header h2 {
      margin: 0;
      font-size: 20px;
      font-weight: 600;
      letter-spacing: 3px;
      color: #fff;
    }
    .login-body {
      padding: 36px 32px 32px;
    }
    .form-title {
      color: #333;
      font-size: 15px;
      font-weight: 500;
      margin-bottom: 28px;
      text-align: center;
      color: #666;
    }
    .form-group {
      margin-bottom: 20px;
    }
    .form-group label {
      display: block;
      font-size: 13px;
      color: #333;
      margin-bottom: 8px;
      font-weight: 600;
    }
    .gov-input {
      width: 100%;
      padding: 12px 14px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 14px;
      transition: all 0.2s ease;
      background: #fafafa;
    }
    .gov-input:focus {
      outline: none;
      border-color: #D32F2F;
      background: #fff;
      box-shadow: 0 0 0 3px rgba(211, 47, 47, 0.1);
    }
    .gov-input::placeholder {
      color: #aaa;
    }
    .login-btn {
      width: 100%;
      padding: 14px;
      background: #D32F2F;
      color: white;
      border: none;
      border-radius: 6px;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      margin-top: 8px;
      letter-spacing: 4px;
    }
    .login-btn:hover {
      background: #B71C1C;
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(211, 47, 47, 0.3);
    }
    .login-btn:active {
      transform: translateY(0);
    }
    .error-msg {
      background: #FFF5F5;
      border-left: 4px solid #D32F2F;
      padding: 12px 14px;
      border-radius: 4px;
      margin-bottom: 20px;
      color: #C62828;
      font-size: 13px;
      line-height: 1.5;
    }
    .success-msg {
      background: #F0FFF4;
      border-left: 4px solid #4CAF50;
      padding: 12px 14px;
      border-radius: 4px;
      margin-bottom: 20px;
      color: #2E7D32;
      font-size: 13px;
      line-height: 1.5;
    }
    .links {
      text-align: center;
      margin-top: 24px;
      padding-top: 20px;
      border-top: 1px solid #f0f0f0;
      font-size: 13px;
      color: #888;
      line-height: 2;
    }
    .links p {
      margin: 0 0 12px 0;
    }
    .links a {
      color: #D32F2F;
      text-decoration: none;
      transition: color 0.2s;
    }
    .links a:hover {
      color: #B71C1C;
      text-decoration: underline;
    }
    .links .divider {
      color: #ddd;
      margin: 0 8px;
    }
    @media (max-width: 480px) {
      .gov-header { padding: 0 16px; }
      .gov-header h1 { font-size: 16px; margin-left: 32px; }
      .login-wrapper { padding: 24px 16px; }
      .login-body { padding: 28px 24px 24px; }
    }
  </style>
</head>
<body>

<div class="gov-header">
  <h1>社区关爱协同平台</h1>
  <div class="nav-right">
    <a href="${pageContext.request.contextPath}/">返回首页</a>
  </div>
</div>

<div class="login-wrapper">
  <div class="login-container">
    <div class="login-header">
      <h2>志愿者登录</h2>
    </div>
    
    <div class="login-body">
      <div class="form-title">请输入您的账号信息</div>
    
      <c:if test="${not empty error}">
        <div class="error-msg">${error}</div>
      </c:if>
      
      <c:if test="${not empty msg}">
        <div class="success-msg">${msg}</div>
      </c:if>
    
      <form action="${pageContext.request.contextPath}/user/doLogin" method="post">
        <input type="hidden" name="roleHint" value="volunteer"/>
        
        <div class="form-group">
          <label for="username">用户名</label>
          <input type="text" name="username" id="username" class="gov-input" placeholder="请输入用户名" value="${username}" required>
        </div>
        
        <div class="form-group">
          <label for="password">密码</label>
          <input type="password" name="password" id="password" class="gov-input" placeholder="请输入密码" required>
        </div>
        
        <button type="submit" class="login-btn">登 录</button>
      </form>
      
      <div class="links">
        <p>还没有账号？<a href="${pageContext.request.contextPath}/user/volunteer/register">立即注册</a></p>
        <a href="${pageContext.request.contextPath}/user/volunteer/appeal">申诉渠道</a> |
        <a href="${pageContext.request.contextPath}/user/volunteer/reset-password">修改密码</a>
        <br/>
        <a href="${pageContext.request.contextPath}/user/admin/login">管理员登录</a> |
        <a href="${pageContext.request.contextPath}/user/family/login">家属登录</a>
      </div>
    </div>
  </div>
</div>
</body>
</html>
