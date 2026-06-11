<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>编辑需求 - 管理员控制台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    .navbar .actions a { color: white; text-decoration: none; margin-left: 20px; font-weight: 600; font-size: 14px; }
    .container { background: #fff; border-radius: 4px; padding: 36px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 4px solid #D32F2F; }
    .page-title { font-size: 28px; color: #1e293b; margin-bottom: 12px; font-weight: 700; }
    .page-desc { color: #64748b; margin-bottom: 28px; font-size: 15px; }
    .form-section { margin-bottom: 28px; }
    .section-title { font-size: 18px; color: #1e293b; margin-bottom: 16px; font-weight: 700; padding-left: 12px; border-left: 4px solid #D32F2F; }
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-size: 14px; color: #475569; margin-bottom: 8px; font-weight: 600; }
    .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 12px 16px; border: 2px solid #e2e8f0; border-radius: 4px; font-size: 15px; }
    .form-group input:focus, .form-group select:focus, .form-group textarea:focus { outline: none; border-color: #D32F2F; background: rgba(211,47,47,0.05); }
    .form-group textarea { min-height: 120px; resize: vertical; }
    .required { color: #ef4444; }
    .btn-submit { width: 100%; padding: 16px; background: white; border: 2px solid #D32F2F; color: #D32F2F; border-radius: 4px; font-size: 16px; font-weight: 700; cursor: pointer; }
    .btn-submit:hover { background: #D32F2F; color: white; }
    .error { background: rgba(245,87,108,0.1); border-left: 4px solid #f5576c; padding: 12px 16px; border-radius: 2px; margin-bottom: 24px; color: #dc2626; font-size: 14px; }
    .hint { color: #64748b; font-size: 12px; margin-top: 6px; }
  </style>
</head>
<body>
<div class="navbar" style="background: linear-gradient(90deg, #B71C1C 0%, #D32F2F 100%); padding: 0 40px; height: 60px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; border-radius: 4px; position: relative;">
  <div style="position: absolute; left: 20px; color: #B71C1C; font-size: 24px;">★</div>
  <h1 style="color: white; font-size: 20px; font-weight: 600; margin-left: 50px; letter-spacing: 1px;">编辑需求</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/admin/demand/detail/${demand.id}">返回详情</a>
    <a href="${pageContext.request.contextPath}/admin/demand/list">需求列表</a>
  </div>
</div>

<div class="container">
  <h1 class="page-title">编辑需求信息</h1>
  <p class="page-desc">管理员可直接修改需求内容、联系方式、时间与状态。</p>

  <c:if test="${not empty error}">
    <div class="error">${error}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/admin/demand/update" method="post">
    <input type="hidden" name="id" value="${demand.id}"/>
    <input type="hidden" name="attachmentUrl" id="attachmentUrl" value="${demand.attachmentUrl}"/>
    <input type="hidden" name="taskId" value="${demand.taskId}"/>

    <div class="form-section">
      <div class="section-title">基本信息</div>
      <div class="form-group">
        <label>需求标题 <span class="required">*</span></label>
        <input type="text" name="title" value="${demand.title}" required maxlength="150"/>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>需求类型 <span class="required">*</span></label>
          <input type="text" name="demandType" value="${demand.demandType}" required/>
        </div>
        <div class="form-group">
          <label>紧急程度 <span class="required">*</span></label>
          <select name="urgency" required>
            <option value="LOW" ${demand.urgency == 'LOW' ? 'selected' : ''}>低</option>
            <option value="MEDIUM" ${demand.urgency == 'MEDIUM' ? 'selected' : ''}>中</option>
            <option value="HIGH" ${demand.urgency == 'HIGH' ? 'selected' : ''}>高</option>
            <option value="URGENT" ${demand.urgency == 'URGENT' ? 'selected' : ''}>非常紧急</option>
          </select>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>需求状态 <span class="required">*</span></label>
          <select name="status" required>
            <option value="PENDING" ${demand.status == 'PENDING' ? 'selected' : ''}>待审核</option>
            <option value="APPROVED" ${demand.status == 'APPROVED' ? 'selected' : ''}>已通过</option>
            <option value="REJECTED" ${demand.status == 'REJECTED' ? 'selected' : ''}>已拒绝</option>
            <option value="MATCHED" ${demand.status == 'MATCHED' ? 'selected' : ''}>已匹配</option>
            <option value="CLOSED" ${demand.status == 'CLOSED' ? 'selected' : ''}>已关闭</option>
          </select>
        </div>
        <div class="form-group">
          <label>所需技能</label>
          <input type="text" name="requiredSkill" value="${demand.requiredSkill}" placeholder="例如：护理、陪护、维修"/>
        </div>
      </div>

      <div class="form-group">
        <label>意向志愿者（可选）</label>
        <select name="intendedVolunteerId">
          <option value="">不指定，由志愿者大厅自由认领</option>
          <c:forEach items="${volunteerList}" var="vol">
            <option value="${vol.id}" ${demand.intendedVolunteerId == vol.id ? 'selected' : ''}>
              ${vol.fullName}
              <c:if test="${not empty vol.phone}"> - ${vol.phone}</c:if>
              <c:if test="${not empty vol.skills}"> - ${vol.skills}</c:if>
            </option>
          </c:forEach>
        </select>
        <div class="hint">仅作为发布需求时的意向人选，转任务时可参考该意向选择志愿者</div>
      </div>
    </div>

    <div class="form-section">
      <div class="section-title">详细描述</div>
      <div class="form-group">
        <label>需求描述 <span class="required">*</span></label>
        <textarea name="description" required>${demand.description}</textarea>
      </div>
      <div class="form-group">
        <label>附件图片路径</label>
        <input type="text" name="attachmentUrl" value="${demand.attachmentUrl}"/>
        <div class="hint">可直接保留原路径，也可改为新的 /uploads/... 路径</div>
      </div>
    </div>

    <div class="form-section">
      <div class="section-title">时间与地点</div>
      <div class="form-row">
        <div class="form-group">
          <label>期望开始时间</label>
          <input type="datetime-local" name="expectedStartTime" value="<fmt:formatDate value='${demand.expectedStartTime}' pattern='yyyy-MM-dd\'T\'HH:mm'/>"/>
        </div>
        <div class="form-group">
          <label>期望结束时间</label>
          <input type="datetime-local" name="expectedEndTime" value="<fmt:formatDate value='${demand.expectedEndTime}' pattern='yyyy-MM-dd\'T\'HH:mm'/>"/>
        </div>
      </div>
      <div class="form-group">
        <label>时间要求说明</label>
        <input type="text" name="timeRequirement" value="${demand.timeRequirement}"/>
      </div>
      <div class="form-group">
        <label>服务地址 <span class="required">*</span></label>
        <input type="text" name="serviceAddress" value="${demand.serviceAddress}" required/>
      </div>
    </div>

    <div class="form-section">
      <div class="section-title">联系方式</div>
      <div class="form-row">
        <div class="form-group">
          <label>联系人 <span class="required">*</span></label>
          <input type="text" name="contactPerson" value="${demand.contactPerson}" required/>
        </div>
        <div class="form-group">
          <label>联系电话 <span class="required">*</span></label>
          <input type="tel" name="contactPhone" value="${demand.contactPhone}" required/>
        </div>
      </div>
    </div>

    <button type="submit" class="btn-submit">保存修改</button>
  </form>
</div>
</body>
</html>
