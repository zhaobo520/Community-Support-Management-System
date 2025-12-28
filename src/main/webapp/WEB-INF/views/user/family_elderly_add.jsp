<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>添加关爱人员 - 家属服务中心</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: #FAF5F0; min-height: 100vh; padding-bottom: 40px; }
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
    }
    .gov-header .actions {
      display: flex;
      gap: 20px;
    }
    .gov-header .actions a {
      color: white;
      text-decoration: none;
      font-size: 14px;
      padding: 6px 16px;
      border-radius: 4px;
      transition: background 0.3s;
    }
    .gov-header .actions a:hover {
      background: rgba(255,255,255,0.2);
    }
    .container {
      max-width: 800px;
      margin: 40px auto;
      background: #fff;
      border-radius: 8px;
      padding: 40px 50px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }
    .header {
      text-align: center;
      margin-bottom: 32px;
      padding-bottom: 20px;
      border-bottom: 3px solid #D32F2F;
    }
    .header h1 {
      font-size: 28px;
      color: #1e293b;
      margin-bottom: 8px;
    }
    .header p {
      color: #64748b;
      font-size: 14px;
    }
    .notice {
      background: rgba(59,130,246,0.1);
      border-left: 4px solid #3b82f6;
      padding: 16px;
      border-radius: 4px;
      margin-bottom: 24px;
      font-size: 14px;
      color: #1e40af;
    }
    .form-section {
      margin-bottom: 32px;
    }
    .section-title {
      font-size: 18px;
      color: #1e293b;
      margin-bottom: 16px;
      padding-bottom: 8px;
      border-bottom: 2px solid #e2e8f0;
      font-weight: 600;
    }
    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
      margin-bottom: 20px;
    }
    .form-group {
      margin-bottom: 20px;
    }
    .form-group.full {
      grid-column: 1 / -1;
    }
    .form-group label {
      display: block;
      font-size: 14px;
      color: #475569;
      margin-bottom: 8px;
      font-weight: 600;
    }
    .form-group label .required {
      color: #D32F2F;
      margin-left: 4px;
    }
    .form-group input,
    .form-group select,
    .form-group textarea {
      width: 100%;
      padding: 12px 14px;
      border: 1px solid #e2e8f0;
      border-radius: 6px;
      font-size: 14px;
      transition: all 0.3s;
    }
    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
      outline: none;
      border-color: #D32F2F;
      box-shadow: 0 0 0 3px rgba(211, 47, 47, 0.1);
    }
    .form-group textarea {
      resize: vertical;
      min-height: 100px;
    }
    .radio-group {
      display: flex;
      gap: 20px;
    }
    .radio-group label {
      display: flex;
      align-items: center;
      font-weight: normal;
      cursor: pointer;
    }
    .radio-group input[type="radio"] {
      width: auto;
      margin-right: 8px;
    }
    .error {
      background: rgba(239,68,68,0.1);
      border-left: 4px solid #ef4444;
      padding: 12px 16px;
      border-radius: 4px;
      margin-bottom: 20px;
      color: #dc2626;
      font-size: 14px;
    }
    .form-actions {
      display: flex;
      gap: 12px;
      justify-content: center;
      margin-top: 32px;
    }
    .btn {
      padding: 12px 36px;
      border: 2px solid;
      border-radius: 6px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
    }
    .btn-submit {
      background: #D32F2F;
      color: white;
      border-color: #D32F2F;
    }
    .btn-submit:hover {
      background: #B71C1C;
      border-color: #B71C1C;
    }
    .btn-cancel {
      background: white;
      color: #64748b;
      border-color: #e2e8f0;
    }
    .btn-cancel:hover {
      background: #f8fafc;
      border-color: #cbd5e1;
    }
    @media (max-width: 768px) {
      .gov-header { padding: 0 16px; }
      .container { margin: 20px 16px; padding: 24px 20px; }
      .form-row { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>
<header class="gov-header">
  <h1>添加关爱人员</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/user/family/elderly/list">返回列表</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <div class="header">
    <h1>添加关爱人员</h1>
    <p>请完整填写关爱对象的基本信息和特殊需求</p>
  </div>

  <div class="notice">
    <strong>温馨提示：</strong>添加的关爱人员需要经过管理员审核后才能发布关爱需求。审核通过后，您可以为该关爱人员发布服务需求。
  </div>

  <c:if test="${not empty error}">
    <div class="error">${error}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/user/family/elderly/add" method="post" onsubmit="return beforeSubmit()">

    <div class="form-section">
      <div class="section-title">基本信息</div>
      <div class="form-row">
        <div class="form-group">
          <label>姓名<span class="required">*</span></label>
          <input type="text" name="name" value="${elderlyInfo.name}" required placeholder="请输入关爱人员姓名"/>
        </div>
        <div class="form-group">
          <label>身份证号</label>
          <input type="text" name="idCard" value="${elderlyInfo.idCard}" maxlength="18" placeholder="选填"/>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>性别</label>
          <div class="radio-group">
            <label><input type="radio" name="gender" value="MALE" ${empty elderlyInfo or elderlyInfo.gender == 'MALE' ? 'checked' : ''}/> 男</label>
            <label><input type="radio" name="gender" value="FEMALE" ${elderlyInfo.gender == 'FEMALE' ? 'checked' : ''}/> 女</label>
          </div>
        </div>
        <div class="form-group">
          <label>出生日期</label>
          <input type="date" name="birthDate" value="${elderlyInfo.birthDate}"/>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>年龄</label>
          <input type="number" name="age" value="${elderlyInfo.age}" min="0" max="150" placeholder="请输入年龄"/>
        </div>
        <div class="form-group">
          <label>联系电话<span class="required">*</span></label>
          <input type="tel" name="phone" value="${elderlyInfo.phone}" required placeholder="请输入联系电话"/>
        </div>
      </div>

      <div class="form-group full">
        <label>居住地址<span class="required">*</span></label>
        <input type="text" name="address" value="${elderlyInfo.address}" required placeholder="请输入详细居住地址"/>
      </div>
    </div>

    <!-- Photo Upload Section -->
    <div class="form-section">
      <div class="section-title">关爱对象照片</div>
      <%@ include file="/WEB-INF/views/common/file_upload_component.jsp" %>
      <input type="hidden" id="uploadType" value="elderly-photo">
      <input type="hidden" name="photoUrl" id="photoUrl">
    </div>

    <div class="form-section">
      <div class="section-title">健康状况</div>
      <div class="form-row">
        <div class="form-group">
          <label>健康状况</label>
          <input type="text" name="healthStatus" value="${elderlyInfo.healthStatus}" placeholder="如：高血压、糖尿病"/>
        </div>
        <div class="form-group">
          <label>残疾等级</label>
          <select name="disabilityLevel">
            <option value="">无</option>
            <option value="轻度" ${elderlyInfo.disabilityLevel == '轻度' ? 'selected' : ''}>轻度</option>
            <option value="中度" ${elderlyInfo.disabilityLevel == '中度' ? 'selected' : ''}>中度</option>
            <option value="重度" ${elderlyInfo.disabilityLevel == '重度' ? 'selected' : ''}>重度</option>
          </select>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>是否独居</label>
          <div class="radio-group">
            <label><input type="radio" name="livingAlone" value="1" ${elderlyInfo.livingAlone == 1 ? 'checked' : ''}/> 是</label>
            <label><input type="radio" name="livingAlone" value="0" ${empty elderlyInfo or elderlyInfo.livingAlone == 0 ? 'checked' : ''}/> 否</label>
          </div>
        </div>
        <div class="form-group">
          <label>关爱等级</label>
          <select name="careLevel">
            <option value="LOW" ${elderlyInfo.careLevel == 'LOW' ? 'selected' : ''}>低</option>
            <option value="MEDIUM" ${empty elderlyInfo or elderlyInfo.careLevel == 'MEDIUM' ? 'selected' : ''}>中</option>
            <option value="HIGH" ${elderlyInfo.careLevel == 'HIGH' ? 'selected' : ''}>高</option>
            <option value="URGENT" ${elderlyInfo.careLevel == 'URGENT' ? 'selected' : ''}>紧急</option>
          </select>
        </div>
      </div>
    </div>

    <div class="form-section">
      <div class="section-title">与您的关系</div>
      <div class="form-row">
        <div class="form-group">
          <label>您与关爱对象的关系<span class="required">*</span></label>
          <select name="familyContact" required>
            <option value="">请选择</option>
            <option value="子女" ${elderlyInfo.familyContact == '子女' ? 'selected' : ''}>子女</option>
            <option value="配偶" ${elderlyInfo.familyContact == '配偶' ? 'selected' : ''}>配偶</option>
            <option value="孙子女" ${elderlyInfo.familyContact == '孙子女' ? 'selected' : ''}>孙子女</option>
            <option value="兄弟姐妹" ${elderlyInfo.familyContact == '兄弟姐妹' ? 'selected' : ''}>兄弟姐妹</option>
            <option value="其他亲属" ${elderlyInfo.familyContact == '其他亲属' ? 'selected' : ''}>其他亲属</option>
            <option value="朋友" ${elderlyInfo.familyContact == '朋友' ? 'selected' : ''}>朋友</option>
            <option value="邻居" ${elderlyInfo.familyContact == '邻居' ? 'selected' : ''}>邻居</option>
          </select>
        </div>
        <div class="form-group">
          <label>您的联系电话</label>
          <input type="tel" name="familyPhone" value="${currentUser.phone}" readonly style="background:#f8fafc;"/>
        </div>
      </div>
    </div>

    <div class="form-section">
      <div class="section-title">特殊需求</div>
      <div class="form-group full">
        <label>特殊需求说明</label>
        <textarea name="specialNeeds" placeholder="详细描述关爱对象的特殊需求和注意事项，如饮食禁忌、用药情况、行动能力等...">${elderlyInfo.specialNeeds}</textarea>
      </div>
    </div>

    <div class="form-actions">
      <button type="button" class="btn btn-cancel" onclick="history.back()">取消</button>
      <button type="submit" class="btn btn-submit" onclick="return beforeSubmit()">提交审核</button>
    </div>
  </form>
</div>

<script>
function beforeSubmit() {
  // Get uploaded photo URL and set to hidden field
  if (typeof getUploadedFileUrls === 'function') {
    var photoUrls = getUploadedFileUrls();
    console.log('Original photoUrls:', photoUrls);
    if (photoUrls) {
      // 移除contextPath前缀，只保存相对路径
      var contextPath = '${pageContext.request.contextPath}';
      if (photoUrls.startsWith(contextPath)) {
        photoUrls = photoUrls.substring(contextPath.length);
      }
      console.log('Processed photoUrls:', photoUrls);
      document.getElementById('photoUrl').value = photoUrls;
    }
  }
  console.log('Final photoUrl value:', document.getElementById('photoUrl').value);
  return true;
}
</script>
</body>
</html>
