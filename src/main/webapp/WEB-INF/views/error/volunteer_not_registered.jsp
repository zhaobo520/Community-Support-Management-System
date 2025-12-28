<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>未注册志愿者</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: 'Microsoft YaHei', sans-serif;
      background: #FAF5F0;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }
    .error-container {
      background: #fff;
      border-radius: 4px;
      padding: 60px 40px;
      max-width: 500px;
      text-align: center;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      border-left: 4px solid #D32F2F;
    }
    .error-icon {
      font-size: 100px;
      margin-bottom: 30px;
      display: none;
    }
    h1 {
      font-size: 28px;
      color: #D32F2F;
      margin-bottom: 20px;
    }
    .error-msg {
      font-size: 16px;
      color: #64748b;
      line-height: 1.8;
      margin-bottom: 40px;
    }
    .btn {
      display: inline-block;
      padding: 12px 32px;
      background: white;
      color: #D32F2F;
      border: 2px solid #D32F2F;
      text-decoration: none;
      border-radius: 2px;
      font-weight: 600;
      transition: all 0.3s;
    }
    .btn:hover {
      background: #D32F2F;
      color: white;
    }
  </style>
</head>
<body>
<div class="error-container">
  <h1>未注册志愿者</h1>
  <div class="error-msg">
    ${not empty errorMsg ? errorMsg : '您还未注册成为志愿者，请先完善志愿者信息并等待审核通过。'}
  </div>
  <a href="${pageContext.request.contextPath}/user/logout" class="btn">退出登录</a>
</div>
</body>
</html>
