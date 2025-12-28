<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>家属注册</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
      padding: 40px 20px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .register-container {
      background: #fff;
      border-radius: 4px;
      padding: 40px 50px;
      max-width: 700px;
      width: 100%;
      box-shadow: 0 4px 16px rgba(0,0,0,0.1);
      border-top: 4px solid #D32F2F;
    }
    .header {
      text-align: center;
      margin-bottom: 40px;
    }
    .header h1 {
      font-size: 28px;
      color: #212121;
      margin-bottom: 10px;
      font-weight: 600;
    }
    .header p {
      color: #666;
      font-size: 14px;
    }
    .form-group {
      margin-bottom: 24px;
    }
    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }
    label {
      display: block;
      font-size: 14px;
      color: #333;
      margin-bottom: 8px;
      font-weight: 600;
    }
    .required::after {
      content: '*';
      color: #D32F2F;
      margin-left: 4px;
    }
    input, textarea {
      width: 100%;
      padding: 12px 16px;
      border: 1px solid #E0E0E0;
      border-radius: 4px;
      font-size: 14px;
      transition: all 0.3s;
    }
    input:focus, textarea:focus {
      outline: none;
      border-color: #D32F2F;
      box-shadow: 0 0 0 3px rgba(211, 47, 47, 0.1);
    }
    textarea {
      resize: vertical;
      min-height: 80px;
    }
    .btn-group {
      display: flex;
      gap: 12px;
      margin-top: 32px;
    }
    .btn {
      flex: 1;
      padding: 14px;
      border: none;
      border-radius: 4px;
      font-size: 16px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.3s;
    }
    .btn:hover {
      transform: translateY(-2px);
    }
    .btn-primary {
      background: white;
      color: #D32F2F;
      border: 2px solid #D32F2F;
    }
    .btn-primary:hover {
      background: #D32F2F;
      color: white;
    }
    .btn-secondary {
      background: #f5f5f5;
      color: #666;
      border: 1px solid #E0E0E0;
    }
    .info-box {
      background: #FFF8F8;
      border-left: 4px solid #D32F2F;
      padding: 16px;
      border-radius: 4px;
      margin-bottom: 24px;
    }
    .info-box p {
      color: #666;
      font-size: 13px;
      line-height: 1.6;
    }
  </style>
</head>
<body>
<div class="register-container">
  <div class="header">
    <h1>家属注册</h1>
    <p>为您的家人申请社区关爱服务</p>
  </div>

  <div class="info-box">
    <p>📢 注册后，您可以为家中需要关爱的关爱对象申请各类服务，并实时查看服务进度和志愿者反馈。</p>
  </div>

  <form action="${pageContext.request.contextPath}/user/family/register" method="post" onsubmit="return validateForm()">
    <!-- 账号信息 -->
    <h3 style="color:#212121;margin-bottom:20px;font-size:18px;font-weight:600;">账号信息</h3>
    
    <div class="form-row">
      <div class="form-group">
        <label class="required">用户名</label>
        <input type="text" name="username" placeholder="请输入用户名" required/>
      </div>
      <div class="form-group">
        <label class="required">姓名</label>
        <input type="text" name="fullName" placeholder="请输入真实姓名" required/>
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label class="required">密码</label>
        <input type="password" name="password" id="password" placeholder="请输入密码" required/>
      </div>
      <div class="form-group">
        <label class="required">确认密码</label>
        <input type="password" id="confirmPassword" placeholder="请再次输入密码" required/>
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label class="required">手机号</label>
        <input type="tel" name="phone" placeholder="请输入手机号" required/>
      </div>
      <div class="form-group">
        <label>邮箱</label>
        <input type="email" name="email" placeholder="请输入邮箱"/>
      </div>
    </div>

    <!-- 头像上传 -->
    <h3 style="color:#212121;margin:32px 0 20px;font-size:18px;font-weight:600;">个人头像</h3>
    <div style="background:#f8f9fa;padding:20px;border-radius:4px;margin-bottom:24px;">
      <%@ include file="/WEB-INF/views/common/file_upload_component.jsp" %>
      <input type="hidden" id="uploadType" value="avatar">
      <input type="hidden" name="avatar" id="avatarUrl">
    </div>

    <!-- 家属信息 -->
    <h3 style="color:#212121;margin:32px 0 20px;font-size:18px;font-weight:600;">家属信息</h3>

    <div class="form-group">
      <label>与关爱对象关系</label>
      <input type="text" name="relationship" placeholder="如：子女、孙子女、侄子等"/>
    </div>

    <div class="form-group">
      <label>居住地址</label>
      <input type="text" name="address" placeholder="请输入详细地址"/>
    </div>

    <div class="form-group">
      <label>备注说明</label>
      <textarea name="notes" placeholder="如有其他需要说明的情况，请在此填写..."></textarea>
    </div>

    <div class="btn-group">
      <button type="button" class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/user/family/login'">返回登陆</button>
      <button type="button" class="btn btn-secondary" onclick="history.back()">取消</button>
      <button type="submit" class="btn btn-primary">提交注册</button>
    </div>
  </form>
</div>

<script>
function validateForm() {
  const password = document.getElementById('password').value;
  const confirmPassword = document.getElementById('confirmPassword').value;
  
  if (password !== confirmPassword) {
    alert('两次输入的密码不一致，请重新输入！');
    return false;
  }
  
  if (password.length < 6) {
    alert('密码长度不能少于6位！');
    return false;
  }
  
  // Get uploaded avatar URL
  var avatarUrls = getUploadedFileUrls();
  if (avatarUrls) {
    document.getElementById('avatarUrl').value = avatarUrls;
  }
  
  return true;
}
</script>
</body>
</html>
