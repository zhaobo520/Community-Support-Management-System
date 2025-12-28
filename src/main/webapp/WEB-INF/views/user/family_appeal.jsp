<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>家属申诉 - 社区关爱协同平台</title>
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
      max-width: 800px;
      margin: 40px auto;
      padding: 0 20px;
    }
    .appeal-container {
      background: white;
      border-radius: 4px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      overflow: hidden;
      border-left: 4px solid #D32F2F;
    }
    .appeal-header {
      background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
      padding: 30px;
      text-align: center;
      color: white;
    }
    .appeal-header h1 {
      margin: 0;
      font-size: 24px;
      font-weight: 700;
    }
    .appeal-header p {
      margin: 10px 0 0 0;
      font-size: 14px;
      opacity: 0.9;
    }
    .appeal-body {
      padding: 40px;
    }
    .form-section {
      margin-bottom: 30px;
    }
    .form-section h3 {
      color: #212121;
      font-size: 16px;
      font-weight: 600;
      margin-bottom: 20px;
      padding-bottom: 10px;
      border-bottom: 2px solid #f0f0f0;
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
    .gov-input:disabled {
      background: #f5f5f5;
      color: #999;
    }
    textarea.gov-input {
      resize: vertical;
      min-height: 120px;
      font-family: 'Microsoft YaHei', Arial, sans-serif;
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
    .info-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
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
  <div class="appeal-container">
    <div class="appeal-header">
      <h1>家属申诉与建议</h1>
      <p>如您的账号被误封禁或对服务有任何建议，请在此提交申诉</p>
    </div>

    <div class="appeal-body">
      <div class="tips">
        <strong>温馨提示：</strong>
        <p style="margin: 8px 0 0 0;">
          我们重视每一位家属的反馈。若您的账号被禁用、需求被拒绝或有其他问题，请详细说明情况，我们的管理员会在24小时内回复。
        </p>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/user/family/submit-appeal">
        <div class="form-section">
          <h3>账号信息</h3>

          <c:if test="${not empty sessionScope.CURRENT_USER}">
            <div class="info-row">
              <div class="form-group">
                <label>用户名</label>
                <input type="text" class="gov-input" value="${sessionScope.CURRENT_USER.username}" disabled/>
                <input type="hidden" name="username" value="${sessionScope.CURRENT_USER.username}"/>
              </div>

              <div class="form-group">
                <label>手机号</label>
                <input type="tel" class="gov-input" value="${sessionScope.CURRENT_USER.phone}" disabled/>
                <input type="hidden" name="phone" value="${sessionScope.CURRENT_USER.phone}"/>
              </div>
            </div>
          </c:if>

          <c:if test="${empty sessionScope.CURRENT_USER}">
            <div class="info-row">
              <div class="form-group required">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" class="gov-input" placeholder="请输入您的用户名" required/>
              </div>

              <div class="form-group required">
                <label for="phone">手机号</label>
                <input type="tel" id="phone" name="phone" class="gov-input" placeholder="请输入您的手机号，方便我们联系您" required/>
              </div>
            </div>
          </c:if>
        </div>

        <div class="form-section">
          <h3>申诉内容</h3>

          <div class="form-group required">
            <label for="appealType">申诉类型</label>
            <select id="appealType" name="appealType" class="gov-input" required>
              <option value="">-- 请选择申诉类型 --</option>
              <option value="account_blocked">账号被禁用</option>
              <option value="demand_rejected">需求被驳回</option>
              <option value="volunteer_issue">志愿者服务相关</option>
              <option value="service_quality">服务质量问题</option>
              <option value="system_issue">系统功能问题</option>
              <option value="other">其他问题</option>
            </select>
          </div>

          <div class="form-group required">
            <label for="description">详细描述</label>
            <textarea id="description" name="description" class="gov-input" placeholder="请详细说明您的情况，包括发生时间、具体问题、涉及的关爱对象信息等..." required></textarea>
          </div>

          <div class="form-group">
            <label for="attachment">补充附件（可选）</label>
            <input type="text" id="attachment" name="attachment" class="gov-input" placeholder="您可以上传截图或其他相关证明"/>
          </div>
        </div>

        <div class="btn-group">
          <a href="${pageContext.request.contextPath}/user/family/login" class="btn btn-back">返回登陆</a>
          <button type="submit" class="btn btn-submit">提交申诉</button>
        </div>
      </form>
    </div>
  </div>
</div>

</body>
</html>
