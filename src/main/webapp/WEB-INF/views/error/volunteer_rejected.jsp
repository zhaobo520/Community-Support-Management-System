<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>无法访问</title>
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
      padding: 14px 32px;
      background: white;
      color: #D32F2F;
      text-decoration: none;
      border-radius: 2px;
      border: 2px solid #D32F2F;
      font-weight: 700;
      transition: all 0.3s;
    }
    .btn:hover {
      background: #D32F2F;
      color: white;
      transform: translateY(-2px);
    }
  </style>
</head>
<body>
<div class="error-container">
  <div class="error-icon">❌</div>
  <h1>申请已被拒绝</h1>
  <div class="error-msg">
    ${not empty errorMsg ? errorMsg : '您的志愿者申请已被拒绝，暂时无法接单。如有疑问，请联系管理员。'}
  </div>
  <a href="${pageContext.request.contextPath}/user/logout" class="btn">退出登录</a>
</div>
</body>
</html>
