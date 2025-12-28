<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>从需求创建任务 - 社区关爱协同平台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
      padding: 40px 20px;
    }
    .gov-header {
      background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%);
      padding: 20px 60px;
      margin-bottom: 40px;
      border-radius: 4px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      color: white;
    }
    .gov-header h1 {
      font-size: 24px;
      color: white;
    }
    .navbar a {
      color: white;
      text-decoration: none;
      margin-left: 20px;
      font-weight: 600;
    }
    .container {
      max-width: 1000px;
      margin: 0 auto;
    }
    .main-content {
      display: grid;
      grid-template-columns: 1fr 2fr;
      gap: 24px;
    }
    .demand-info {
      background: #fff;
      border-radius: 4px;
      padding: 24px;
      height: fit-content;
    }
    .demand-info h3 {
      font-size: 18px;
      color: #1e293b;
      margin-bottom: 16px;
      padding-bottom: 12px;
      border-bottom: 2px solid #e2e8f0;
    }
    .info-item {
      margin-bottom: 12px;
    }
    .info-label {
      font-size: 11px;
      color: #64748b;
      margin-bottom: 3px;
    }
    .info-value {
      font-size: 13px;
      color: #1e293b;
      font-weight: 600;
    }
    .form-container {
      background: #fff;
      border-radius: 4px;
      padding: 28px;
    }
    .form-header {
      text-align: center;
      margin-bottom: 20px;
    }
    .form-header h2 {
      font-size: 22px;
      color: #1e293b;
      margin-bottom: 6px;
    }
    .form-header p {
      color: #64748b;
      font-size: 13px;
    }
    .form-section {
      margin-bottom: 20px;
    }
    .form-section:last-of-type {
      margin-bottom: 12px;
    }
    .section-title {
      font-size: 15px;
      color: #1e293b;
      margin-bottom: 12px;
      padding-left: 10px;
      border-left: 4px solid #D32F2F;
      font-weight: 700;
    }
    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 14px;
      margin-bottom: 14px;
    }
    .form-group {
      margin-bottom: 16px;
    }
    .form-group label {
      display: block;
      font-size: 14px;
      color: #475569;
      margin-bottom: 8px;
      font-weight: 600;
    }
    .form-group label .required {
      color: #ef4444;
    }
    .form-group input,
    .form-group select,
    .form-group textarea {
      width: 100%;
      padding: 12px 16px;
      border: 2px solid #e2e8f0;
      border-radius: 4px;
      font-size: 14px;
      font-family: 'Nunito', sans-serif;
      transition: all 0.3s;
    }
    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
      outline: none;
      border-color: #D32F2F;
      background: rgba(211,47,47,0.05);
    }
    .form-group textarea {
      min-height: 80px;
      resize: vertical;
    }
    .btn-submit {
      width: 100%;
      padding: 16px;
      background: white;
      border: 2px solid #D32F2F;
      color: #D32F2F;
      border-radius: 4px;
      font-size: 16px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.3s;
      margin-top: 20px;
    }
    .btn-submit:hover {
      background: #D32F2F;
      color: white;
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
    .tag {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 700;
      background: rgba(211,47,47,0.15);
      color: #D32F2F;
      margin-bottom: 8px;
    }
  </style>
</head>
<body>
<div class="navbar">
  <h1>从需求创建任务</h1>
  <div>
    <a href="${pageContext.request.contextPath}/admin/demand/detail/${demand.id}">← 返回需求详情</a>
    <a href="${pageContext.request.contextPath}/admin/demand/list">需求列表</a>
  </div>
</div>

<div class="container">
  <div class="main-content">
    <!-- 需求信息卡片 -->
    <div class="demand-info">
      <h3>需求信息</h3>
      <c:if test="${not empty demand}">
        <div class="info-item">
          <div class="info-label">需求标题</div>
          <div class="info-value">${demand.title}</div>
        </div>
        <div class="info-item">
          <div class="info-label">需求类型</div>
          <div class="info-value">
            <span class="tag">${demand.demandType}</span>
          </div>
        </div>
        <div class="info-item">
          <div class="info-label">紧急程度</div>
          <div class="info-value">
            <c:choose>
              <c:when test="${demand.urgency == 'LOW'}">低 - 不急</c:when>
              <c:when test="${demand.urgency == 'MEDIUM'}">中 - 一般</c:when>
              <c:when test="${demand.urgency == 'HIGH'}">高 - 紧急</c:when>
              <c:when test="${demand.urgency == 'URGENT'}">紧急 - 非常紧急</c:when>
            </c:choose>
          </div>
        </div>
        <div class="info-item">
          <div class="info-label">发布人</div>
          <div class="info-value">${demand.familyUser.fullName}</div>
        </div>
        <div class="info-item">
          <div class="info-label">联系方式</div>
          <div class="info-value">${demand.contactPerson} - ${demand.contactPhone}</div>
        </div>
        <div class="info-item">
          <div class="info-label">服务地址</div>
          <div class="info-value">${demand.serviceAddress}</div>
        </div>
        <c:if test="${not empty demand.description}">
          <div class="info-item">
            <div class="info-label">需求描述</div>
            <div class="info-value" style="line-height:1.6;white-space:pre-wrap;">${demand.description}</div>
          </div>
        </c:if>
        <c:if test="${not empty demand.attachmentUrl}">
          <div class="info-item">
            <div class="info-label">情景图片</div>
            <div class="info-value">
              <img src="${pageContext.request.contextPath}${demand.attachmentUrl}" 
                   alt="需求情景图片" 
                   style="max-width:200px;max-height:150px;border-radius:8px;cursor:pointer;"
                   onclick="window.open('${pageContext.request.contextPath}${demand.attachmentUrl}', '_blank')"/>
            </div>
          </div>
        </c:if>
      </c:if>
    </div>

    <!-- 任务创建表单 -->
    <div class="form-container">
      <div class="form-header">
        <h2>创建任务</h2>
        <p>基于需求信息创建任务，系统已自动填充部分信息</p>
      </div>

      <c:if test="${not empty error}">
        <div class="error">${error}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/admin/task/publish" method="post">
        <input type="hidden" name="demandId" value="${demand.id}"/>

        <!-- 基本信息 -->
        <div class="form-section">
          <div class="section-title">基本信息</div>
          
          <div class="form-group">
            <label>任务标题 <span class="required">*</span></label>
            <input type="text" name="taskTitle" value="${demand.title}" required maxlength="100"/>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>任务类型 <span class="required">*</span></label>
              <select name="taskType" required>
                <option value="">请选择</option>
                <option value="SHOPPING" ${demand.demandType == '生活照料' ? 'selected' : ''}>代购服务</option>
                <option value="MEDICAL" ${demand.demandType == '医疗护理' ? 'selected' : ''}>医疗护理</option>
                <option value="CLEANING" ${demand.demandType == '家政服务' ? 'selected' : ''}>家政清洁</option>
                <option value="ACCOMPANY" ${demand.demandType == '心理慰藉' ? 'selected' : ''}>陪伴服务</option>
                <option value="REPAIR" ${demand.demandType == '维修服务' ? 'selected' : ''}>维修服务</option>
                <option value="OTHER" ${demand.demandType == '其他' ? 'selected' : ''}>其他服务</option>
              </select>
            </div>

            <div class="form-group">
              <label>优先级 <span class="required">*</span></label>
              <select name="priority" required>
                <option value="">请选择</option>
                <option value="LOW" ${demand.urgency == 'LOW' ? 'selected' : ''}>低</option>
                <option value="MEDIUM" ${demand.urgency == 'MEDIUM' ? 'selected' : ''}>中</option>
                <option value="HIGH" ${demand.urgency == 'HIGH' ? 'selected' : ''}>高</option>
                <option value="URGENT" ${demand.urgency == 'URGENT' ? 'selected' : ''}>紧急</option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label>任务描述 <span class="required">*</span></label>
            <textarea name="description" required>${demand.description}</textarea>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>计划日期</label>
              <input type="date" name="scheduledDate" 
                     value="<fmt:formatDate value='${demand.expectedStartTime}' pattern='yyyy-MM-dd'/>"/>
            </div>
            <div class="form-group">
              <label>计划时间</label>
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
          </div>
        </div>

        <!-- 服务信息 -->
        <div class="form-section">
          <div class="section-title">服务信息</div>

          <div class="form-group">
            <label>关联关爱对象</label>
            <select name="elderlyId">
              <option value="">不关联关爱对象</option>
              <c:forEach items="${elderlyList}" var="elderly">
                <option value="${elderly.id}" ${demand.targetId == elderly.id ? 'selected' : ''}>${elderly.name} - ${elderly.phone}</option>
              </c:forEach>
            </select>
          </div>

          <div class="form-group">
            <label>服务地址 <span class="required">*</span></label>
            <input type="text" name="address" value="${demand.serviceAddress}" required/>
          </div>

          <div class="form-group">
            <label>联系电话</label>
            <input type="tel" name="contactPhone" value="${demand.contactPhone}"/>
          </div>
          
          <!-- 智能推荐志愿者 -->
          <div class="form-group" id="volunteer-section" style="display:none; background:#f8fafc; padding:15px; border-radius:12px; border:1px dashed #cbd5e1; margin-top:20px;">
            <label style="color:#D32F2F; display:flex; align-items:center; gap:8px;">
              <span>智能推荐志愿者</span>
              <span id="recommend-status" style="font-weight:normal; font-size:12px; color:#64748b;">(请先选择日期和时段)</span>
            </label>
            <select name="volunteerId" id="volunteerSelect" style="border-color:#D32F2F; width:100%;">
              <option value="">-- 不指派 (发布到大厅) --</option>
            </select>
            <div style="margin-top:8px; font-size:12px; color:#64748b;">
              * 系统已自动过滤掉该时段忙碌或已有任务的志愿者
            </div>
          </div>
        </div>

        <button type="submit" class="btn-submit">创建任务并发布</button>
      </form>
    </div>
  </div>
</div>

<script>
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
