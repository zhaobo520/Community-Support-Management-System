<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>编辑关爱对象</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: #FAF5F0; min-height: 100vh; margin: 0; padding: 0; padding-bottom: 40px; overflow-y: auto; }
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
      content: '';
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
    .gov-header .actions {
      display: flex;
      gap: 20px;
    }
    .gov-header .actions a {
      color: white;
      text-decoration: none;
      font-size: 14px;
      transition: opacity 0.3s;
      padding: 6px 16px;
      border-radius: 2px;
    }
    .gov-header .actions a:hover {
      background: rgba(255,255,255,0.2);
    }
    .container {
      max-width: 800px;
      margin: 40px auto;
      background: #fff;
      border-radius: 4px;
      padding: 40px 50px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      border: 1px solid #E0E0E0;
    }
    .header {
      text-align: center;
      margin-bottom: 32px;
      padding-bottom: 20px;
      border-bottom: 3px solid #D32F2F;
    }
    .header h1 {
      font-size: 28px;
      color: #212121;
      margin-bottom: 8px;
    }
    .header p {
      color: #666;
      font-size: 14px;
    }
    .back-link {
      display: inline-block;
      margin-bottom: 20px;
      color: #D32F2F;
      text-decoration: none;
      font-weight: 600;
    }
    .form-section {
      margin-bottom: 32px;
    }
    .section-title {
      font-size: 18px;
      color: #212121;
      margin-bottom: 16px;
      padding-bottom: 8px;
      border-bottom: 2px solid #E0E0E0;
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
      color: #424242;
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
      padding: 10px 14px;
      border: 1px solid #E0E0E0;
      border-radius: 2px;
      font-size: 14px;
      transition: border-color 0.3s;
    }
    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
      outline: none;
      border-color: #D32F2F;
      box-shadow: 0 0 0 2px rgba(211, 47, 47, 0.1);
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
      background: rgba(211,47,47,0.1);
      border-left: 4px solid #D32F2F;
      padding: 12px 16px;
      border-radius: 2px;
      margin-bottom: 20px;
      color: #B71C1C;
      font-size: 14px;
    }
    .form-actions {
      display: flex;
      gap: 12px;
      justify-content: center;
      margin-top: 32px;
    }
    .btn {
      padding: 10px 32px;
      border: 1px solid;
      border-radius: 2px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
    }
    .btn-submit {
      background: white;
      color: #D32F2F;
      border-color: #D32F2F;
    }
    .btn-submit:hover {
      background: #D32F2F;
      color: white;
    }
    .btn-cancel {
      background: white;
      color: #666;
      border-color: #E0E0E0;
    }
    .btn-cancel:hover {
      background: #F5F5F5;
    }
  </style>
</head>
<body>
<header class="gov-header">
  <h1>编辑关爱对象</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/admin/elderly/list">返回列表</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <div class="header">
    <h1>编辑关爱对象</h1>
    <p>修改关爱对象的信息</p>
  </div>

  <c:if test="${not empty error}">
    <div class="error">${error}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/admin/elderly/edit" method="post">
    <input type="hidden" name="id" value="${elderlyInfo.id}"/>
    <input type="hidden" name="status" value="${elderlyInfo.status}"/>
    
    <div class="form-section">
      <div class="section-title">基本信息</div>
      <div class="form-row">
        <div class="form-group">
          <label>姓名<span class="required">*</span></label>
          <input type="text" name="name" value="${elderlyInfo.name}" required/>
        </div>
        <div class="form-group">
          <label>身份证号</label>
          <input type="text" name="idCard" value="${elderlyInfo.idCard}" maxlength="18"/>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>性别</label>
          <div class="radio-group">
            <label><input type="radio" name="gender" value="MALE" ${elderlyInfo.gender == 'MALE' ? 'checked' : ''}/> 男</label>
            <label><input type="radio" name="gender" value="FEMALE" ${elderlyInfo.gender == 'FEMALE' ? 'checked' : ''}/> 女</label>
          </div>
        </div>
        <div class="form-group">
          <label>出生日期</label>
          <input type="date" name="birthDate" value="<fmt:formatDate value='${elderlyInfo.birthDate}' pattern='yyyy-MM-dd'/>"/>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>年龄</label>
          <input type="number" name="age" value="${elderlyInfo.age}" min="0" max="150"/>
        </div>
        <div class="form-group">
          <label>联系电话</label>
          <input type="tel" name="phone" value="${elderlyInfo.phone}"/>
        </div>
      </div>

      <div class="form-group full">
        <label>居住地址</label>
        <input type="text" name="address" value="${elderlyInfo.address}"/>
      </div>
    </div>

    <!-- Photo Upload Section -->
    <div class="form-section">
      <div class="section-title">关爱对象照片</div>
      <!-- 显示已有照片 -->
      <c:if test="${not empty elderlyInfo.photoUrl}">
        <div style="margin-bottom: 20px;">
          <p style="color: #666; font-size: 14px; margin-bottom: 10px;">当前照片：</p>
          <div style="display: inline-block; position: relative;">
            <c:choose>
              <c:when test="${fn:startsWith(elderlyInfo.photoUrl, pageContext.request.contextPath)}">
                <img src="${elderlyInfo.photoUrl}" alt="关爱对象照片"
                     style="max-width: 200px; max-height: 200px; border-radius: 8px; border: 1px solid #E0E0E0; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
              </c:when>
              <c:otherwise>
                <img src="${pageContext.request.contextPath}${elderlyInfo.photoUrl}" alt="关爱对象照片"
                     style="max-width: 200px; max-height: 200px; border-radius: 8px; border: 1px solid #E0E0E0; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
              </c:otherwise>
            </c:choose>
          </div>
          <p style="color: #999; font-size: 12px; margin-top: 8px;">如需更换照片，请在下方上传新照片</p>
        </div>
      </c:if>
      <%@ include file="/WEB-INF/views/common/file_upload_component.jsp" %>
      <input type="hidden" id="uploadType" value="elderly-photo">
      <input type="hidden" name="photoUrl" id="photoUrl" value="${elderlyInfo.photoUrl}">
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
            <label><input type="radio" name="livingAlone" value="0" ${elderlyInfo.livingAlone == 0 ? 'checked' : ''}/> 否</label>
          </div>
        </div>
        <div class="form-group">
          <label>关爱等级</label>
          <select name="careLevel">
            <option value="LOW" ${elderlyInfo.careLevel == 'LOW' ? 'selected' : ''}>低</option>
            <option value="MEDIUM" ${elderlyInfo.careLevel == 'MEDIUM' ? 'selected' : ''}>中</option>
            <option value="HIGH" ${elderlyInfo.careLevel == 'HIGH' ? 'selected' : ''}>高</option>
            <option value="URGENT" ${elderlyInfo.careLevel == 'URGENT' ? 'selected' : ''}>紧急</option>
          </select>
        </div>
      </div>
    </div>

    <div class="form-section">
      <div class="section-title">家属信息</div>
      <div class="form-row">
        <div class="form-group">
          <label>家属联系人</label>
          <input type="text" name="familyContact" value="${elderlyInfo.familyContact}"/>
        </div>
        <div class="form-group">
          <label>家属电话</label>
          <input type="tel" name="familyPhone" value="${elderlyInfo.familyPhone}"/>
        </div>
      </div>
    </div>

    <div class="form-section">
      <div class="section-title">特殊需求</div>
      <div class="form-group full">
        <label>特殊需求说明</label>
        <textarea name="specialNeeds" placeholder="详细描述关爱对象的特殊需求和注意事项...">${elderlyInfo.specialNeeds}</textarea>
      </div>
    </div>

    <div class="form-actions">
      <button type="button" class="btn btn-cancel" onclick="history.back()">取消</button>
      <button type="submit" class="btn btn-submit" onclick="return beforeSubmit()">保存修改</button>
    </div>
  </form>
</div>

<script>
function beforeSubmit() {
  // Get uploaded photo URL and set to hidden field
  var photoUrls = getUploadedFileUrls();
  if (photoUrls) {
    document.getElementById('photoUrl').value = photoUrls;
  }
  return true;
}
</script>
</body>
</html>
