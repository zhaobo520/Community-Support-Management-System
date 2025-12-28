<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>修改密码 - 社区关爱协同平台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    body {
      margin: 0;
      padding: 0;
      background: #FAF5F0;
      min-height: 100vh;
      font-family: 'Microsoft YaHei', Arial, sans-serif;
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
    .gov-header .nav-right a {
      color: white;
      text-decoration: none;
      font-size: 14px;
      transition: opacity 0.3s;
    }
    .gov-header .nav-right a:hover {
      opacity: 0.8;
    }
    .container {
      max-width: 600px;
      margin: 40px auto;
      padding: 0 20px;
    }
    .reset-container {
      background: white;
      border-radius: 4px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      overflow: hidden;
      border-left: 4px solid #D32F2F;
    }
    .reset-header {
      background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
      padding: 30px;
      text-align: center;
      color: white;
    }
    .reset-header h1 {
      margin: 0;
      font-size: 24px;
      font-weight: 700;
    }
    .reset-header p {
      margin: 10px 0 0 0;
      font-size: 14px;
      opacity: 0.9;
    }
    .reset-body {
      padding: 40px;
    }
    .form-group {
      margin-bottom: 20px;
    }
    .form-group label {
      display: block;
      font-size: 14px;
      color: #333;
      margin-bottom: 8px;
      font-weight: 600;
    }
    .form-group.required label::after {
      content: '*';
      color: #D32F2F;
      margin-left: 4px;
    }
    .gov-input {
      width: 100%;
      padding: 10px 12px;
      border: 1px solid #E0E0E0;
      border-radius: 2px;
      font-size: 14px;
      transition: all 0.3s ease;
      box-sizing: border-box;
    }
    .gov-input:focus {
      outline: none;
      border-color: #D32F2F;
      box-shadow: 0 0 0 2px rgba(211, 47, 47, 0.1);
    }
    .btn-group {
      display: flex;
      gap: 12px;
      margin-top: 30px;
      justify-content: center;
    }
    .btn {
      padding: 12px 30px;
      border: none;
      border-radius: 2px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
      text-decoration: none;
      display: inline-block;
    }
    .btn-submit {
      background: white;
      color: #D32F2F;
      border: 2px solid #D32F2F;
    }
    .btn-submit:hover {
      background: #D32F2F;
      color: white;
    }
    .btn-back {
      background: #f5f5f5;
      color: #666;
      border: 2px solid #e0e0e0;
    }
    .btn-back:hover {
      background: #e0e0e0;
    }
    .tips {
      background: #FFF8F8;
      border-left: 4px solid #D32F2F;
      padding: 15px;
      border-radius: 2px;
      margin-bottom: 20px;
      font-size: 13px;
      color: #666;
    }
    .tips strong {
      color: #D32F2F;
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

<div class="container">
  <div class="reset-container">
    <div class="reset-header">
      <h1>修改密码</h1>
      <p>为了您的账号安全，请定期修改密码</p>
    </div>

    <div class="reset-body">
      <div class="tips">
        <strong>密码要求：</strong>
        <p style="margin: 8px 0 0 0;">
          密码长度至少6位，建议包含字母、数字和特殊字符，以提高账号安全性。
        </p>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/user/family/update-password" onsubmit="return validatePassword()">
        <div class="form-group required">
          <label for="username">用户名</label>
          <input type="text" id="username" name="username" class="gov-input" placeholder="请输入您的用户名" required/>
        </div>

        <div class="form-group required">
          <label for="phone">手机号</label>
          <input type="tel" id="phone" name="phone" class="gov-input" placeholder="请输入您的手机号进行验证" required/>
        </div>

        <div class="form-group required">
          <label for="oldPassword">原密码</label>
          <input type="password" id="oldPassword" name="oldPassword" class="gov-input" placeholder="请输入您的原密码" required/>
        </div>

        <div class="form-group required">
          <label for="newPassword">新密码</label>
          <input type="password" id="newPassword" name="newPassword" class="gov-input" placeholder="请输入新密码（至少6位）" required/>
        </div>

        <div class="form-group required">
          <label for="confirmPassword">确认新密码</label>
          <input type="password" id="confirmPassword" name="confirmPassword" class="gov-input" placeholder="请再次输入新密码" required/>
        </div>

        <div class="btn-group">
          <a href="${pageContext.request.contextPath}/user/family/login" class="btn btn-back">返回登陆</a>
          <button type="submit" class="btn btn-submit">修改密码</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
function validatePassword() {
  const newPassword = document.getElementById('newPassword').value;
  const confirmPassword = document.getElementById('confirmPassword').value;

  if (newPassword.length < 6) {
    alert('新密码长度不能少于6位！');
    return false;
  }

  if (newPassword !== confirmPassword) {
    alert('两次输入的密码不一致，请重新输入！');
    return false;
  }

  return true;
}
</script>

</body>
</html>
