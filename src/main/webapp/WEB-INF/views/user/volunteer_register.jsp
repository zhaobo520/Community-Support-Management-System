<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>志愿者注册</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: 'Microsoft YaHei', Arial, sans-serif;
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
      max-width: 800px;
      width: 100%;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      border-left: 4px solid #D32F2F;
    }
    .header {
      text-align: center;
      margin-bottom: 40px;
      padding-bottom: 20px;
      border-bottom: 2px solid #f0f0f0;
    }
    .header h1 {
      font-size: 32px;
      color: #212121;
      margin-bottom: 10px;
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
      color: #666;
      margin-bottom: 8px;
      font-weight: 600;
    }
    .required::after {
      content: '*';
      color: #D32F2F;
      margin-left: 4px;
    }
    input, textarea, select {
      width: 100%;
      padding: 12px 16px;
      border: 2px solid #e0e0e0;
      border-radius: 2px;
      font-size: 14px;
      transition: all 0.3s;
    }
    input:focus, textarea:focus, select:focus {
      outline: none;
      border-color: #D32F2F;
      box-shadow: 0 0 0 3px rgba(211, 47, 47, 0.1);
    }
    textarea {
      resize: vertical;
      min-height: 100px;
    }
    .radio-group {
      display: flex;
      gap: 20px;
      margin-top: 8px;
    }
    .radio-item {
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .radio-item input[type="radio"] {
      width: auto;
      accent-color: #D32F2F;
    }
    .skill-tags {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      margin-top: 10px;
    }
    .skill-tag {
      padding: 8px 16px;
      background: white;
      color: #D32F2F;
      border-radius: 2px;
      font-size: 13px;
      cursor: pointer;
      border: 2px solid #D32F2F;
      transition: all 0.3s;
      font-weight: 600;
    }
    .skill-tag:hover {
      background: rgba(211, 47, 47, 0.1);
    }
    .skill-tag.active {
      background: #D32F2F;
      color: #fff;
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
      border-radius: 2px;
      font-size: 16px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.3s;
    }
    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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
      border: 2px solid #e0e0e0;
    }
    .btn-secondary:hover {
      background: #e0e0e0;
    }
    h3 {
      color: #212121;
      margin: 32px 0 20px;
      font-size: 18px;
      padding-bottom: 10px;
      border-bottom: 2px solid #f0f0f0;
    }
    h3:first-of-type {
      margin-top: 0;
    }
    .upload-area {
      background: #FFF5F5;
      padding: 20px;
      border-radius: 2px;
      margin-bottom: 24px;
      border-left: 4px solid #D32F2F;
    }
  </style>
</head>
<body>
<div class="register-container">
  <div class="header">
    <h1>志愿者注册</h1>
    <p>加入我们，为社区关爱对象提供温暖服务</p>
  </div>

  <form action="${pageContext.request.contextPath}/user/volunteer/register" method="post" onsubmit="return validateForm()">
    <!-- 账号信息 -->
    <h3>账号信息</h3>

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

    <!-- 个人信息 -->
    <h3>个人信息</h3>

    <div class="form-row">
      <div class="form-group">
        <label>身份证号</label>
        <input type="text" name="idCard" placeholder="请输入身份证号" maxlength="18"/>
      </div>
      <div class="form-group">
        <label>性别</label>
        <div class="radio-group">
          <div class="radio-item">
            <input type="radio" name="gender" value="MALE" id="male" checked/>
            <label for="male" style="margin:0;">男</label>
          </div>
          <div class="radio-item">
            <input type="radio" name="gender" value="FEMALE" id="female"/>
            <label for="female" style="margin:0;">女</label>
          </div>
        </div>
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label>出生日期</label>
        <input type="date" name="birthDate"/>
      </div>
      <div class="form-group">
        <label>年龄</label>
        <input type="number" name="age" placeholder="请输入年龄" min="16" max="100"/>
      </div>
    </div>

    <div class="form-group">
      <label>居住地址</label>
      <input type="text" name="address" placeholder="请输入详细地址"/>
    </div>

    <!-- 头像上传 -->
    <h3>个人头像</h3>
    <div class="upload-area">
      <%@ include file="/WEB-INF/views/common/file_upload_component.jsp" %>
      <input type="hidden" id="uploadType" value="avatar">
      <input type="hidden" name="avatar" id="avatarUrl">
    </div>

    <!-- 紧急联系人 -->
    <h3>紧急联系人</h3>

    <div class="form-row">
      <div class="form-group">
        <label>联系人姓名</label>
        <input type="text" name="emergencyContact" placeholder="请输入紧急联系人姓名"/>
      </div>
      <div class="form-group">
        <label>联系人电话</label>
        <input type="tel" name="emergencyPhone" placeholder="请输入紧急联系人电话"/>
      </div>
    </div>

    <!-- 服务信息 -->
    <h3>服务信息</h3>

    <div class="form-group">
      <label>擅长技能（多选）</label>
      <div class="skill-tags">
        <span class="skill-tag" data-skill="护理技能">护理技能</span>
        <span class="skill-tag" data-skill="心理辅导">心理辅导</span>
        <span class="skill-tag" data-skill="送餐服务">送餐服务</span>
        <span class="skill-tag" data-skill="陪伴聊天">陪伴聊天</span>
        <span class="skill-tag" data-skill="代购">代购</span>
        <span class="skill-tag" data-skill="家政清洁">家政清洁</span>
        <span class="skill-tag" data-skill="维修">维修</span>
        <span class="skill-tag" data-skill="陪同就医">陪同就医</span>
        <span class="skill-tag" data-skill="文艺活动">文艺活动</span>
      </div>
      <input type="hidden" name="skills" id="skillsInput"/>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label>服务区域</label>
        <input type="text" name="serviceArea" placeholder="如：朝阳区,东城区"/>
      </div>
      <div class="form-group">
        <label>可服务时间</label>
        <input type="text" name="availableTime" placeholder="如：周末全天"/>
      </div>
    </div>

    <div class="form-group">
      <label>个人简介</label>
      <textarea name="introduction" placeholder="请简单介绍自己，说明您的优势和服务意愿..."></textarea>
    </div>

    <div class="btn-group">
      <button type="button" class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/user/volunteer/login'">返回登陆</button>
      <button type="button" class="btn btn-secondary" onclick="history.back()">取消</button>
      <button type="submit" class="btn btn-primary">提交注册</button>
    </div>
  </form>
</div>

<script>
const skillTags = document.querySelectorAll('.skill-tag');
const selectedSkills = new Set();

skillTags.forEach(tag => {
  tag.addEventListener('click', function() {
    const skill = this.dataset.skill;
    if (this.classList.contains('active')) {
      this.classList.remove('active');
      selectedSkills.delete(skill);
    } else {
      this.classList.add('active');
      selectedSkills.add(skill);
    }
    document.getElementById('skillsInput').value = Array.from(selectedSkills).join(',');
  });
});

function validateForm() {
  const password = document.getElementById('password').value;
  const confirmPassword = document.getElementById('confirmPassword').value;

  if (password !== confirmPassword) {
    alert('两次输入的密码不一致，请重新输入！');
    return false;
  }

  // Get uploaded avatar URL
  var avatarUrls = getUploadedFileUrls();
  if (avatarUrls) {
    document.getElementById('avatarUrl').value = avatarUrls;
  }

  if (password.length < 6) {
    alert('密码长度不能少于6位！');
    return false;
  }

  return true;
}
</script>
</body>
</html>
