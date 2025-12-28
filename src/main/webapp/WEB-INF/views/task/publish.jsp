<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>发布任务</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: 'Nunito', sans-serif;
      background: #FAF5F0;
      min-height: 100vh;
      padding: 40px 20px;
    }
    .container {
      max-width: 900px;
      margin: 0 auto;
      background: #fff;
      border-radius: 4px;
      padding: 40px 50px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      border-top: 4px solid #D32F2F;
    }
    .back-link {
      display: inline-block;
      margin-bottom: 20px;
      color: #D32F2F;
      text-decoration: none;
      font-weight: 600;
    }
    .back-link:hover { text-decoration: underline; }
    .header {
      text-align: center;
      margin-bottom: 32px;
      border-bottom: 1px solid #eee;
      padding-bottom: 20px;
    }
    .header h1 {
      font-size: 28px;
      color: #B71C1C;
      margin-bottom: 8px;
    }
    .form-section {
      margin-bottom: 32px;
      background: #FAFAFA;
      padding: 20px;
      border-radius: 4px;
      border: 1px solid #eee;
    }
    .section-title {
      font-size: 18px;
      color: #212121;
      margin-bottom: 16px;
      padding-bottom: 8px;
      border-bottom: 2px solid #EF9A9A;
      font-weight: bold;
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
      color: #666;
      margin-bottom: 8px;
      font-weight: 600;
    }
    .form-group label .required {
      color: #D32F2F;
    }
    .form-group input, .form-group select, .form-group textarea {
      width: 100%;
      padding: 12px 16px;
      border: 1px solid #ccc;
      border-radius: 4px;
      font-size: 14px;
      font-family: 'Nunito', sans-serif;
      transition: all 0.3s;
    }
    .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
      border-color: #D32F2F;
      box-shadow: 0 0 0 3px rgba(183, 28, 28, 0.1);
      outline: none;
    }
    .form-group textarea {
      min-height: 100px;
      resize: vertical;
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
    .type-option label {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 16px;
      border: 1px solid #ddd;
      border-radius: 4px;
      cursor: pointer;
      transition: all 0.3s;
      background: white;
    }
    .type-option input[type="radio"]:checked + label {
      border-color: #D32F2F;
      background: rgba(183, 28, 28, 0.05);
      color: #D32F2F;
    }
    .type-icon {
      font-size: 32px;
      margin-bottom: 8px;
    }
    .type-label {
      font-size: 13px;
      font-weight: 600;
    }
    .form-actions {
      display: flex;
      gap: 12px;
      justify-content: center;
      margin-top: 32px;
    }
    .btn {
      padding: 14px 32px;
      border: none;
      border-radius: 4px;
      font-size: 16px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.3s;
    }
    .btn-submit {
      background: white;
      border: 2px solid #D32F2F;
      color: #D32F2F;
    }
    .btn-submit:hover {
      background: #D32F2F;
      color: white;
    }
    .btn-cancel {
      background: #f5f5f5;
      color: #666;
      border: 1px solid #ddd;
    }
    .btn-cancel:hover {
      background: #e0e0e0;
    }
    .error {
      background: #FFEBEE;
      border-left: 4px solid #B71C1C;
      padding: 12px 16px;
      border-radius: 4px;
      margin-bottom: 20px;
      color: #B71C1C;
    }
  </style>
</head>
<body>
<div class="container fade-in-up">
  <a href="${pageContext.request.contextPath}/admin/task/list" class="back-link">← 返回任务列表</a>
  
  <div class="header">
    <h1>发布关爱任务</h1>
    <p style="color:#666;font-size:14px;">为关爱对象创建服务任务，系统将智能匹配志愿者</p>
  </div>

  <c:if test="${not empty error}">
    <div class="error">${error}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/admin/task/publish" method="post">
    
    <div class="form-section">
      <div class="section-title">任务类型</div>
      <div class="type-selector">
        <div class="type-option">
          <input type="radio" name="taskType" value="SHOPPING" id="type1" checked/>
          <label for="type1">
            <span class="type-label">代购</span>
          </label>
        </div>
        <div class="type-option">
          <input type="radio" name="taskType" value="MEDICAL" id="type2"/>
          <label for="type2">
            <span class="type-label">就医</span>
          </label>
        </div>
        <div class="type-option">
          <input type="radio" name="taskType" value="CLEANING" id="type3"/>
          <label for="type3">
            <span class="type-label">清洁</span>
          </label>
        </div>
        <div class="type-option">
          <input type="radio" name="taskType" value="ACCOMPANY" id="type4"/>
          <label for="type4">
            <span class="type-label">陪伴</span>
          </label>
        </div>
        <div class="type-option">
          <input type="radio" name="taskType" value="REPAIR" id="type5"/>
          <label for="type5">
            <span class="type-label">维修</span>
          </label>
        </div>
        <div class="type-option">
          <input type="radio" name="taskType" value="OTHER" id="type6"/>
          <label for="type6">
            <span class="type-label">其他</span>
          </label>
        </div>
      </div>
    </div>

    <div class="form-section">
      <div class="section-title">基本信息</div>
      <div class="form-group full">
        <label>任务标题<span class="required">*</span></label>
        <input type="text" name="taskTitle" required placeholder="例如：为李大爷代购日用品"/>
      </div>

      <div class="form-group full">
        <label>服务对象<span class="required">*</span></label>
        <select name="elderlyId" id="elderlySelect" required>
          <option value="">请选择关爱对象</option>
          <c:forEach items="${elderlyList}" var="elderly">
            <option value="${elderly.id}" data-address="${elderly.address}" data-phone="${elderly.phone}">
              ${elderly.name} - ${elderly.age}岁 - ${elderly.address}
            </option>
          </c:forEach>
        </select>
      </div>

      <div class="form-group full">
        <label>任务描述</label>
        <textarea name="description" placeholder="详细描述任务内容和要求..."></textarea>
      </div>
    </div>

    <div class="form-section">
      <div class="section-title">服务信息</div>
      <div class="form-group full">
        <label>服务地址</label>
        <input type="text" name="address" id="addressInput" placeholder="自动填充或手动输入"/>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>联系电话</label>
          <input type="tel" name="contactPhone" id="phoneInput" placeholder="自动填充或手动输入"/>
        </div>
        <div class="form-group">
          <label>预约日期</label>
          <input type="date" name="scheduledDate"/>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>预约时段</label>
          <select name="scheduledTime" id="scheduledTimeSelect">
            <option value="">选择时段</option>
            <option value="上午8:00-10:00">上午8:00-10:00</option>
            <option value="上午9:00-11:00">上午9:00-11:00</option>
            <option value="上午10:00-12:00">上午10:00-12:00</option>
            <option value="中午11:30-12:30">中午11:30-12:30</option>
            <option value="下午14:00-16:00">下午14:00-16:00</option>
            <option value="下午15:00-17:00">下午15:00-17:00</option>
            <option value="晚上18:00-20:00">晚上18:00-20:00</option>
          </select>
        </div>
        <div class="form-group">
          <label>优先级</label>
          <select name="priority">
            <option value="LOW">低</option>
            <option value="MEDIUM" selected>中</option>
            <option value="HIGH">高</option>
            <option value="URGENT">紧急</option>
          </select>
        </div>
      </div>
      
      <!-- 智能推荐志愿者 -->
      <div class="form-group full" id="volunteer-section" style="display:none; background:#f8fafc; padding:15px; border-radius:12px; border:1px dashed #cbd5e1;">
        <label style="color:#D32F2F; display:flex; align-items:center; gap:8px;">
          <span>智能推荐志愿者</span>
          <span id="recommend-status" style="font-weight:normal; font-size:12px; color:#64748b;">(请先选择日期和时段)</span>
        </label>
        <select name="volunteerId" id="volunteerSelect" style="border-color:#D32F2F;">
          <option value="">-- 不指派 (发布到大厅) --</option>
        </select>
        <div style="margin-top:8px; font-size:12px; color:#64748b;">
          * 系统已自动过滤掉该时段忙碌或已有任务的志愿者
        </div>
      </div>

    </div>

    <!-- Task Attachment Upload Section -->
    <div class="form-section">
      <div class="section-title">任务附件（可选）</div>
      <div style="color: #666; font-size: 13px; margin-bottom: 15px;">
        支持上传图片或文档（PDF、Word），帮助志愿者更好地了解任务要求
      </div>
      <%@ include file="/WEB-INF/views/common/file_upload_component.jsp" %>
      <input type="hidden" id="uploadType" value="task-attachment">
      <input type="hidden" name="attachments" id="attachmentsUrl">
    </div>

    <div class="form-actions">
      <button type="button" class="btn btn-cancel" onclick="history.back()">取消</button>
      <button type="submit" class="btn btn-submit" onclick="return beforeSubmit()">发布任务</button>
    </div>
  </form>
</div>

<script>
document.getElementById('elderlySelect').addEventListener('change', function() {
  const selected = this.options[this.selectedIndex];
  document.getElementById('addressInput').value = selected.dataset.address || '';
  document.getElementById('phoneInput').value = selected.dataset.phone || '';
});

function beforeSubmit() {
  // Get uploaded attachment URLs and set to hidden field
  var attachmentUrls = getUploadedFileUrls();
  if (attachmentUrls) {
    document.getElementById('attachmentsUrl').value = attachmentUrls;
  }
  return true;
}

// 智能推荐志愿者逻辑
const dateInput = document.querySelector('input[name="scheduledDate"]');
const timeSelect = document.getElementById('scheduledTimeSelect');
const volunteerSection = document.getElementById('volunteer-section');
const volunteerSelect = document.getElementById('volunteerSelect');
const recommendStatus = document.getElementById('recommend-status');

function getTimeSlot(timeStr) {
    if (!timeStr) return null;
    if (timeStr.includes('上午')) return 'MORNING';
    if (timeStr.includes('下午') || timeStr.includes('中午')) return 'AFTERNOON';
    if (timeStr.includes('晚上')) return 'EVENING';
    return null;
}

function fetchRecommendations() {
    const dateVal = dateInput.value;
    const timeVal = timeSelect.value;
    
    if (!dateVal || !timeVal) {
        volunteerSection.style.display = 'none';
        return;
    }
    
    const slot = getTimeSlot(timeVal);
    if (!slot) return;
    
    volunteerSection.style.display = 'block';
    recommendStatus.textContent = '(正在查找合适人选...)';
    recommendStatus.style.color = '#64748b';
    
    // Clear existing options (keep first)
    volunteerSelect.length = 1;
    
    fetch('${pageContext.request.contextPath}/admin/task/recommend-volunteers?date=' + dateVal + '&time=' + slot)
    .then(response => response.json())
    .then(data => {
        if (data && data.length > 0) {
            recommendStatus.textContent = `(已为您找到 ${data.length} 位合适志愿者)`;
            recommendStatus.style.color = '#10b981';
            
            data.forEach(vol => {
                const option = document.createElement('option');
                option.value = vol.id;
                option.textContent = `${vol.name} (排班合适)`;
                volunteerSelect.appendChild(option);
            });
        } else {
            recommendStatus.textContent = '(暂无该时段空闲的志愿者)';
            recommendStatus.style.color = '#f59e0b';
        }
    })
    .catch(err => {
        console.error(err);
        recommendStatus.textContent = '(推荐服务暂时不可用)';
    });
}

dateInput.addEventListener('change', fetchRecommendations);
timeSelect.addEventListener('change', fetchRecommendations);

</script>
</body>
</html>
