<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>发布需求 - 家属服务中心</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
      padding: 40px 20px;
    }
    .family-header {
      background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      padding: 20px 60px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 40px;
      border-radius: 4px;
      color: white;
    }
    .family-header h1 {
      font-size: 24px;
      color: white;
    }
    .family-header .actions a {
      color: white;
      text-decoration: none;
      margin-left: 20px;
      font-weight: 600;
    }
    .container {
      max-width: 900px;
      margin: 0 auto;
      background: #fff;
      border-radius: 4px;
      padding: 48px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.2);
    }
    .page-title {
      font-size: 28px;
      color: #1e293b;
      margin-bottom: 12px;
      font-weight: 700;
    }
    .page-desc {
      color: #64748b;
      margin-bottom: 40px;
      font-size: 15px;
    }
    .form-section {
      margin-bottom: 36px;
    }
    .section-title {
      font-size: 18px;
      color: #1e293b;
      margin-bottom: 20px;
      font-weight: 700;
      padding-left: 12px;
      border-left: 4px solid #D32F2F;
    }
    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
      margin-bottom: 20px;
    }
    .form-group {
      margin-bottom: 24px;
    }
    .form-group label {
      display: block;
      font-size: 14px;
      color: #475569;
      margin-bottom: 8px;
      font-weight: 600;
    }
    .form-group label .required {
      color: #f5576c;
      margin-left: 4px;
    }
    .form-group input,
    .form-group select,
    .form-group textarea {
      width: 100%;
      padding: 14px 18px;
      border: 2px solid #e2e8f0;
      border-radius: 4px;
      font-size: 15px;
      transition: all 0.3s;
      font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    }
    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
      outline: none;
      border-color: #D32F2F;
      background: rgba(211,47,47,0.05);
    }
    .form-group textarea {
      min-height: 120px;
      resize: vertical;
    }
    .urgency-selector {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 12px;
    }
    .urgency-option {
      position: relative;
    }
    .urgency-option input[type="radio"] {
      position: absolute;
      opacity: 0;
    }
    .urgency-label {
      display: block;
      padding: 12px;
      background: #f8fafc;
      border: 2px solid #e2e8f0;
      border-radius: 4px;
      text-align: center;
      cursor: pointer;
      transition: all 0.3s;
      font-weight: 600;
      font-size: 14px;
    }
    .urgency-option input[type="radio"]:checked + .urgency-label {
      background: #D32F2F;
      color: #fff;
      border-color: #D32F2F;
    }
    .type-selector {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 12px;
    }
    .type-option {
      position: relative;
    }
    .type-option input[type="radio"] {
      position: absolute;
      opacity: 0;
    }
    .type-label {
      display: block;
      padding: 16px 12px;
      background: #f8fafc;
      border: 2px solid #e2e8f0;
      border-radius: 4px;
      text-align: center;
      cursor: pointer;
      transition: all 0.3s;
      font-weight: 600;
      font-size: 14px;
    }
    .type-option input[type="radio"]:checked + .type-label {
      background: rgba(211,47,47,0.15);
      color: #D32F2F;
      border-color: #D32F2F;
    }
    .btn-submit {
      width: 100%;
      padding: 18px;
      background: white;
      border: 2px solid #D32F2F;
      color: #D32F2F;
      border-radius: 4px;
      font-size: 16px;
      font-weight: 700;
      cursor: pointer;
      transition: transform 0.3s;
      margin-top: 24px;
    }
    .btn-submit:hover {
      background: #D32F2F;
      color: white;
    }
    .error {
      background: rgba(245,87,108,0.1);
      border-left: 4px solid #f5576c;
      padding: 12px 16px;
      border-radius: 2px;
      margin-bottom: 24px;
      color: #dc2626;
      font-size: 14px;
    }
  </style>
</head>
<body>
<div class="family-header">
  <h1>发布关爱需求</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/demand/family/list">← 返回需求列表</a>
    <a href="${pageContext.request.contextPath}/user/family/dashboard">控制台</a>
  </div>
</div>

<div class="container">
  <h1 class="page-title">发布新需求</h1>
  <p class="page-desc">填写以下信息，我们会尽快为您安排合适的志愿者提供帮助</p>

  <c:if test="${not empty error}">
    <div class="error">${error}</div>
  </c:if>

  <c:if test="${noElderly}">
    <div class="error" style="background:rgba(59,130,246,0.1);border-left-color:#3b82f6;color:#1e40af;">
      <strong>提示：</strong>您还没有已审核通过的关爱人员，请先<a href="${pageContext.request.contextPath}/user/family/elderly/add" style="color:#D32F2F;font-weight:600;">添加关爱人员</a>并等待管理员审核通过后再发布需求。
    </div>
  </c:if>

  <form action="${pageContext.request.contextPath}/demand/family/create" method="post" onsubmit="return validateForm()">
    <!-- 选择关爱人员 -->
    <div class="form-section">
      <div class="section-title">选择关爱人员</div>

      <c:choose>
        <c:when test="${not empty elderlyList}">
          <div class="form-group">
            <label>为谁发布需求 <span class="required">*</span></label>
            <select name="targetId" id="elderlySelect" required onchange="fillElderlyInfo()">
              <option value="">请选择关爱人员</option>
              <c:forEach items="${elderlyList}" var="elderly">
                <option value="${elderly.id}"
                        data-name="${elderly.name}"
                        data-phone="${elderly.phone}"
                        data-address="${elderly.address}"
                        ${selectedElderlyId == elderly.id ? 'selected' : ''}>
                  ${elderly.name} - ${elderly.age}岁 - ${elderly.address}
                </option>
              </c:forEach>
            </select>
          </div>
          <div style="margin-top:10px;padding:12px;background:#f8fafc;border-radius:6px;font-size:13px;color:#64748b;">
            <span style="color:#D32F2F;">*</span> 如需为其他人员发布需求，请先<a href="${pageContext.request.contextPath}/user/family/elderly/add" style="color:#D32F2F;">添加关爱人员</a>
          </div>
        </c:when>
        <c:otherwise>
          <div style="text-align:center;padding:40px;background:#f8fafc;border-radius:8px;">
            <div style="font-size:48px;margin-bottom:16px;">&#128100;</div>
            <div style="font-size:16px;color:#1e293b;margin-bottom:8px;">暂无可选的关爱人员</div>
            <div style="color:#64748b;margin-bottom:20px;">请先添加关爱人员并等待管理员审核通过</div>
            <a href="${pageContext.request.contextPath}/user/family/elderly/add" style="display:inline-block;padding:10px 24px;background:#D32F2F;color:white;border-radius:6px;text-decoration:none;font-weight:600;">+ 添加关爱人员</a>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 基本信息 -->
    <div class="form-section">
      <div class="section-title">基本信息</div>

      <div class="form-group">
        <label>需求标题 <span class="required">*</span></label>
        <input type="text" name="title" placeholder="简要描述您的需求" required maxlength="150"/>
      </div>

      <div class="form-group">
        <label>需求类型 <span class="required">*</span></label>
        <div class="type-selector">
          <div class="type-option">
            <input type="radio" name="demandType" value="医疗护理" id="type1" required/>
            <label for="type1" class="type-label">就医 医疗护理</label>
          </div>
          <div class="type-option">
            <input type="radio" name="demandType" value="生活照料" id="type2"/>
            <label for="type2" class="type-label">生活照料</label>
          </div>
          <div class="type-option">
            <input type="radio" name="demandType" value="心理慰藉" id="type3"/>
            <label for="type3" class="type-label">陪伴 心理慰藉</label>
          </div>
          <div class="type-option">
            <input type="radio" name="demandType" value="家政服务" id="type4"/>
            <label for="type4" class="type-label">清洁 家政服务</label>
          </div>
          <div class="type-option">
            <input type="radio" name="demandType" value="维修服务" id="type5"/>
            <label for="type5" class="type-label">维修 维修服务</label>
          </div>
          <div class="type-option">
            <input type="radio" name="demandType" value="其他" id="type6"/>
            <label for="type6" class="type-label">其他 其他</label>
          </div>
        </div>
      </div>

      <div class="form-group">
        <label>紧急程度 <span class="required">*</span></label>
        <div class="urgency-selector">
          <div class="urgency-option">
            <input type="radio" name="urgency" value="LOW" id="urgency1"/>
            <label for="urgency1" class="urgency-label">低 不急</label>
          </div>
          <div class="urgency-option">
            <input type="radio" name="urgency" value="MEDIUM" id="urgency2" checked/>
            <label for="urgency2" class="urgency-label">中 一般</label>
          </div>
          <div class="urgency-option">
            <input type="radio" name="urgency" value="HIGH" id="urgency3"/>
            <label for="urgency3" class="urgency-label">高 紧急</label>
          </div>
          <div class="urgency-option">
            <input type="radio" name="urgency" value="URGENT" id="urgency4"/>
            <label for="urgency4" class="urgency-label">紧急 非常紧急</label>
          </div>
        </div>
      </div>
    </div>

    <!-- 详细描述 -->
    <div class="form-section">
      <div class="section-title">详细描述</div>
      
      <div class="form-group">
        <label>需求描述 <span class="required">*</span></label>
        <textarea name="description" placeholder="请详细描述您的需求..." required></textarea>
      </div>

      <div class="form-group">
        <label>所需技能</label>
        <input type="text" name="requiredSkill" placeholder="例如：护理、烹饪、维修等"/>
      </div>

      <div class="form-group">
        <label>意向志愿者（可选）</label>
        <select name="intendedVolunteerId">
          <option value="">不指定，由志愿者大厅自由认领</option>
          <c:forEach items="${volunteerList}" var="vol">
            <option value="${vol.id}">
              ${vol.fullName}
              <c:if test="${not empty vol.phone}"> - ${vol.phone}</c:if>
              <c:if test="${not empty vol.skills}"> - ${vol.skills}</c:if>
            </option>
          </c:forEach>
        </select>
        <div style="color:#666;font-size:13px;margin-top:6px;">仅作为发布需求时的意向人选，最终是否由该志愿者执行需经审核流程</div>
      </div>

      <!-- 需求说明图片 -->
      <div class="form-group">
        <label>情景图片（可选）</label>
        <div style="color:#666;font-size:13px;margin-bottom:10px;">上传相关图片可以帮助志愿者更好地了解您的需求情况</div>
        <div id="imageUploadArea" style="background:#f8f9fa;padding:20px;border-radius:12px;text-align:center;">
          <input type="file" id="attachmentFile" accept="image/*" style="display:none;" onchange="uploadImage(this)"/>
          <div id="uploadPrompt" onclick="document.getElementById('attachmentFile').click()" style="cursor:pointer;padding:40px;border:2px dashed #ddd;border-radius:8px;">
            <div style="font-size:48px;color:#999;">图片</div>
            <div style="color:#666;margin-top:10px;">点击上传图片</div>
            <div style="color:#999;font-size:12px;margin-top:5px;">支持JPG、PNG、GIF等格式，大小不超过5MB</div>
          </div>
          <div id="imagePreview" style="display:none;position:relative;">
            <img id="previewImg" src="" style="max-width:100%;max-height:300px;border-radius:8px;"/>
            <button type="button" onclick="removeImage()" style="position:absolute;top:10px;right:10px;background:rgba(255,255,255,0.9);border:none;padding:5px 10px;border-radius:5px;cursor:pointer;">删除</button>
          </div>
          <input type="hidden" name="attachmentUrl" id="attachmentUrl"/>
        </div>
      </div>
    </div>

    <!-- 时间和地点 -->
    <div class="form-section">
      <div class="section-title">时间和地点</div>
      
      <div class="form-row">
        <div class="form-group">
          <label>期望开始时间</label>
          <input type="datetime-local" name="expectedStartTime"/>
        </div>
        <div class="form-group">
          <label>期望结束时间</label>
          <input type="datetime-local" name="expectedEndTime"/>
        </div>
      </div>

      <div class="form-group">
        <label>时间要求说明</label>
        <input type="text" name="timeRequirement" placeholder="例如：每周三下午、工作日均可等"/>
      </div>

      <div class="form-group">
        <label>服务地址 <span class="required">*</span></label>
        <input type="text" name="serviceAddress" placeholder="请填写详细地址" required/>
      </div>
    </div>

    <!-- 联系方式 -->
    <div class="form-section">
      <div class="section-title">联系方式</div>
      
      <div class="form-row">
        <div class="form-group">
          <label>联系人 <span class="required">*</span></label>
          <input type="text" name="contactPerson" placeholder="联系人姓名" required/>
        </div>
        <div class="form-group">
          <label>联系电话 <span class="required">*</span></label>
          <input type="tel" name="contactPhone" placeholder="手机号码" required pattern="^1[3-9]\d{9}$"/>
        </div>
      </div>
    </div>

    <button type="submit" class="btn-submit">提交需求</button>
  </form>
</div>

<script>
// 选择关爱人员后自动填充信息
function fillElderlyInfo() {
  var select = document.getElementById('elderlySelect');
  var selectedOption = select.options[select.selectedIndex];

  if (selectedOption && selectedOption.value) {
    var address = selectedOption.getAttribute('data-address');
    var phone = selectedOption.getAttribute('data-phone');
    var name = selectedOption.getAttribute('data-name');

    // 自动填充服务地址
    var addressInput = document.querySelector('input[name="serviceAddress"]');
    if (addressInput && address) {
      addressInput.value = address;
    }

    // 自动填充联系人
    var contactPersonInput = document.querySelector('input[name="contactPerson"]');
    if (contactPersonInput && name) {
      contactPersonInput.value = name;
    }

    // 自动填充联系电话
    var contactPhoneInput = document.querySelector('input[name="contactPhone"]');
    if (contactPhoneInput && phone) {
      contactPhoneInput.value = phone;
    }
  }
}

// 页面加载时如果有预选的关爱人员，自动填充
window.onload = function() {
  var select = document.getElementById('elderlySelect');
  if (select && select.value) {
    fillElderlyInfo();
  }
};

function validateForm() {
  // 检查是否选择了关爱人员
  var elderlySelect = document.getElementById('elderlySelect');
  if (elderlySelect && !elderlySelect.value) {
    alert('请选择关爱人员！');
    return false;
  }

  const title = document.querySelector('input[name="title"]').value;
  const demandType = document.querySelector('input[name="demandType"]:checked');
  const description = document.querySelector('textarea[name="description"]').value;
  const serviceAddress = document.querySelector('input[name="serviceAddress"]').value;
  const contactPerson = document.querySelector('input[name="contactPerson"]').value;
  const contactPhone = document.querySelector('input[name="contactPhone"]').value;

  if (!title || !demandType || !description || !serviceAddress || !contactPerson || !contactPhone) {
    alert('请填写所有必填项！');
    return false;
  }

  const phonePattern = /^1[3-9]\d{9}$/;
  if (!phonePattern.test(contactPhone)) {
    alert('请输入正确的手机号码！');
    return false;
  }

  // 图片已经通过uploadImage函数上传并保存在隐藏字段中

  return true;
}

// 图片上传功能
function uploadImage(input) {
  if (input.files && input.files[0]) {
    var file = input.files[0];
    
    // 检查文件大小
    if (file.size > 5 * 1024 * 1024) {
      alert('图片大小不能超过5MB');
      input.value = '';
      return;
    }
    
    // 检查文件类型
    if (!file.type.match('image.*')) {
      alert('请选择图片文件');
      input.value = '';
      return;
    }
    
    // 创建FormData对象
    var formData = new FormData();
    formData.append('file', file);
    
    // 显示上传中状态
    document.getElementById('uploadPrompt').innerHTML = '<div style="color:#667eea;">上传中...</div>';
    
    // 发送AJAX请求上传图片
    fetch('${pageContext.request.contextPath}/upload/demand-attachment', {
      method: 'POST',
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      if (data.code === 200) {
        var rawUrl = data.data.url;
        var contextPath = '${pageContext.request.contextPath}';
        var imageUrl = rawUrl.indexOf(contextPath) === 0 ? rawUrl : contextPath + rawUrl;
        
        // 保存URL到隐藏字段（不包含contextPath的相对路径）
        var relativeUrl = rawUrl;
        document.getElementById('attachmentUrl').value = relativeUrl;
        
        // 显示预览（imageUrl已经包含contextPath，直接使用）
        document.getElementById('previewImg').src = imageUrl;
        document.getElementById('uploadPrompt').style.display = 'none';
        document.getElementById('imagePreview').style.display = 'block';
      } else {
        alert('上传失败：' + (data.msg || '未知错误'));
        document.getElementById('uploadPrompt').innerHTML = '<div style="font-size:48px;color:#999;">图片</div><div style="color:#666;margin-top:10px;">点击上传图片</div><div style="color:#999;font-size:12px;margin-top:5px;">支持JPG、PNG、GIF等格式，大小不超过5MB</div>';
      }
    })
    .catch(error => {
      console.error('Upload error:', error);
      alert('上传失败，请重试');
      document.getElementById('uploadPrompt').innerHTML = '<div style="font-size:48px;color:#999;">图片</div><div style="color:#666;margin-top:10px;">点击上传图片</div><div style="color:#999;font-size:12px;margin-top:5px;">支持JPG、PNG、GIF等格式，大小不超过5MB</div>';
    });
  }
}

// 删除图片
function removeImage() {
  document.getElementById('attachmentUrl').value = '';
  document.getElementById('attachmentFile').value = '';
  document.getElementById('uploadPrompt').style.display = 'block';
  document.getElementById('imagePreview').style.display = 'none';
  document.getElementById('uploadPrompt').innerHTML = '<div style="font-size:48px;color:#999;">图片</div><div style="color:#666;margin-top:10px;">点击上传图片</div><div style="color:#999;font-size:12px;margin-top:5px;">支持JPG、PNG、GIF等格式，大小不超过5MB</div>';
}
</script>
</body>
</html>


