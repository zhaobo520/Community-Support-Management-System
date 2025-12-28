<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>任务详情 - 社区关爱协同平台</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #FAF5F0;
      min-height: 100vh;
      padding: 40px 20px;
    }
    .container {
      max-width: 900px;
      margin: 0 auto;
    }
    .back-link {
      display: inline-block;
      margin-bottom: 20px;
      color: #D32F2F;
      text-decoration: none;
      font-weight: 600;
      background: #fff;
      padding: 10px 20px;
      border-radius: 4px;
      border: 1px solid #D32F2F;
      transition: all 0.3s;
    }
    .back-link:hover {
      background: #D32F2F;
      color: #fff;
    }
    .card {
      background: white;
      border-radius: 4px;
      padding: 40px 50px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      border-top: 4px solid #D32F2F;
    }
    .header {
      display: flex;
      justify-content: space-between;
      align-items: start;
      margin-bottom: 32px;
      padding-bottom: 24px;
      border-bottom: 2px solid #e2e8f0;
    }
    .header-left h1 {
      font-size: 28px;
      color: #1e293b;
      margin-bottom: 12px;
    }
    .header-icon {
      font-size: 48px;
    }
    .elderly-avatar {
      width: 80px;
      height: 80px;
      border-radius: 8px;
      object-fit: cover;
      box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }
    .elderly-avatar-placeholder {
      width: 80px;
      height: 80px;
      border-radius: 8px;
      background: linear-gradient(135deg, #B71C1C, #D32F2F);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
      font-size: 32px;
      font-weight: 700;
      box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }
    .tags {
      display: flex;
      gap: 8px;
      margin-bottom: 16px;
    }
    .tag {
      padding: 6px 14px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 600;
    }
    .tag.urgent { background: rgba(239,68,68,0.15); color: #dc2626; }
    .tag.high { background: rgba(249,115,22,0.15); color: #ea580c; }
    .tag.medium { background: rgba(234,179,8,0.15); color: #ca8a04; }
    .tag.low { background: rgba(16,185,129,0.15); color: #059669; }
    .tag.status-pending { background: rgba(211,47,47,0.15); color: #D32F2F; }
    .tag.status-claimed { background: rgba(139,92,246,0.15); color: #7c3aed; }
    .tag.status-progress { background: rgba(245,158,11,0.15); color: #d97706; }
    .tag.status-completed { background: rgba(16,185,129,0.15); color: #059669; }
    .tag.status-approved { background: rgba(34,197,94,0.15); color: #16a34a; }
    .section {
      margin-bottom: 32px;
    }
    .section-title {
      font-size: 18px;
      color: #1e293b;
      margin-bottom: 16px;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .info-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 20px;
    }
    .info-item {
      background: #f8fafc;
      padding: 16px;
      border-radius: 4px;
    }
    .info-item.full {
      grid-column: 1 / -1;
    }
    .info-label {
      font-size: 13px;
      color: #64748b;
      margin-bottom: 6px;
    }
    .info-value {
      font-size: 15px;
      color: #1e293b;
      font-weight: 600;
    }
    .description-box {
      background: #f8fafc;
      padding: 20px;
      border-radius: 4px;
      line-height: 1.8;
      color: #475569;
    }
    .actions {
      display: flex;
      gap: 12px;
      margin-top: 32px;
    }
    .btn {
      flex: 1;
      padding: 14px;
      border: none;
      border-radius: 4px;
      font-size: 15px;
      font-weight: 700;
      cursor: pointer;
      text-align: center;
    }
    .btn-primary {
      background: white;
      border: 2px solid #D32F2F;
      color: #D32F2F;
    }
    .btn-primary:hover {
      background: #D32F2F;
      color: white;
    }
    .btn-success {
      background: white;
      border: 2px solid #10b981;
      color: #10b981;
    }
    .btn-success:hover {
      background: #10b981;
      color: white;
    }
    .btn-danger {
      background: white;
      border: 2px solid #ef4444;
      color: #ef4444;
    }
    .btn-danger:hover {
      background: #ef4444;
      color: white;
    }
    .btn-secondary {
      background: #e2e8f0;
      color: #475569;
    }
    .timeline {
      margin-top: 24px;
    }
    .timeline-item {
      display: flex;
      gap: 16px;
      margin-bottom: 16px;
      padding-bottom: 16px;
      border-bottom: 1px solid #e2e8f0;
    }
    .timeline-item:last-child {
      border-bottom: none;
    }
    .timeline-icon {
      width: 40px;
      height: 40px;
      background: #D32F2F;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
      font-weight: 700;
      flex-shrink: 0;
    }
    .timeline-content {
      flex: 1;
    }
    .timeline-time {
      font-size: 12px;
      color: #94a3b8;
      margin-top: 4px;
    }
    /* 执行照片样式 */
    .photo-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
      gap: 16px;
      margin-top: 16px;
    }
    .photo-item {
      position: relative;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .photo-item img {
      width: 100%;
      height: 150px;
      object-fit: cover;
      cursor: pointer;
      transition: transform 0.3s;
    }
    .photo-item img:hover {
      transform: scale(1.05);
    }
    .photo-item video {
      width: 100%;
      height: 150px;
      object-fit: cover;
      background: #000;
      border-radius: 8px;
    }
    .photo-item .delete-btn {
      position: absolute;
      top: 5px;
      right: 5px;
      width: 24px;
      height: 24px;
      background: rgba(239,68,68,0.9);
      border: none;
      border-radius: 50%;
      color: white;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
    }
    .upload-box {
      border: 2px dashed #D32F2F;
      border-radius: 8px;
      padding: 30px;
      text-align: center;
      cursor: pointer;
      transition: all 0.3s;
      background: #fef2f2;
    }
    .upload-box:hover {
      background: #fee2e2;
      border-color: #B71C1C;
    }
    .upload-box input[type="file"] {
      display: none;
    }
    .upload-icon {
      font-size: 36px;
      color: #D32F2F;
      margin-bottom: 10px;
    }
    .upload-text {
      color: #666;
      font-size: 14px;
    }
  </style>
</head>
<body>
<div class="container">
  <c:choose>
    <c:when test="${currentUser.roleType == 'STAFF'}">
      <a href="${pageContext.request.contextPath}/admin/task/list" class="back-link">← 返回任务列表</a>
    </c:when>
    <c:otherwise>
      <a href="${pageContext.request.contextPath}/volunteer/task/my" class="back-link">← 返回我的任务</a>
    </c:otherwise>
  </c:choose>

  <div class="card">
    <div class="header">
      <div class="header-left">
        <h1>${taskInfo.taskTitle}</h1>
        <div class="tags">
          <span class="tag ${taskInfo.priority == 'URGENT' ? 'urgent' : taskInfo.priority == 'HIGH' ? 'high' : taskInfo.priority == 'MEDIUM' ? 'medium' : 'low'}">
            ${taskInfo.priority == 'URGENT' ? '紧急' : taskInfo.priority == 'HIGH' ? '高优先级' : taskInfo.priority == 'MEDIUM' ? '中等' : '普通'}
          </span>
          <span class="tag ${taskInfo.status == 'PENDING' ? 'status-pending' : taskInfo.status == 'CLAIMED' ? 'status-claimed' : taskInfo.status == 'IN_PROGRESS' ? 'status-progress' : taskInfo.status == 'COMPLETED' ? 'status-completed' : 'status-approved'}">
            <c:choose>
              <c:when test="${taskInfo.status == 'PENDING'}">待认领</c:when>
              <c:when test="${taskInfo.status == 'CLAIMED'}">已认领</c:when>
              <c:when test="${taskInfo.status == 'IN_PROGRESS'}">进行中</c:when>
              <c:when test="${taskInfo.status == 'COMPLETED'}">待审核</c:when>
              <c:when test="${taskInfo.status == 'APPROVED'}">已完成</c:when>
              <c:otherwise>已取消</c:otherwise>
            </c:choose>
          </span>
        </div>
      </div>
      <!-- 关爱对象照片 -->
      <c:choose>
        <c:when test="${not empty taskInfo.elderlyPhotoUrl}">
          <img src="${taskInfo.elderlyPhotoUrl}" alt="${taskInfo.elderlyName}" class="elderly-avatar">
        </c:when>
        <c:otherwise>
          <div class="elderly-avatar-placeholder">
            ${not empty taskInfo.elderlyName ? taskInfo.elderlyName.substring(0,1) : '?'}
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 基本信息 -->
    <div class="section">
      <div class="section-title">基本信息</div>
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">服务对象</div>
          <div class="info-value">${taskInfo.elderlyName}</div>
        </div>
        <div class="info-item">
          <div class="info-label">任务类型</div>
          <div class="info-value">
            <c:choose>
              <c:when test="${taskInfo.taskType == 'SHOPPING'}">代购</c:when>
              <c:when test="${taskInfo.taskType == 'MEDICAL'}">就医</c:when>
              <c:when test="${taskInfo.taskType == 'CLEANING'}">清洁</c:when>
              <c:when test="${taskInfo.taskType == 'ACCOMPANY'}">陪伴</c:when>
              <c:when test="${taskInfo.taskType == 'REPAIR'}">维修</c:when>
              <c:otherwise>其他</c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="info-item">
          <div class="info-label">服务地址</div>
          <div class="info-value">${taskInfo.address}</div>
        </div>
        <div class="info-item">
          <div class="info-label">联系电话</div>
          <div class="info-value">${taskInfo.contactPhone}</div>
        </div>
        <div class="info-item">
          <div class="info-label">预约日期</div>
          <div class="info-value"><fmt:formatDate value="${taskInfo.scheduledDate}" pattern="yyyy-MM-dd"/></div>
        </div>
        <div class="info-item">
          <div class="info-label">预约时段</div>
          <div class="info-value">${taskInfo.scheduledTime}</div>
        </div>
      </div>
    </div>

    <!-- 任务描述 -->
    <c:if test="${not empty taskInfo.description}">
      <div class="section">
        <div class="section-title">任务描述</div>
        <div class="description-box">${taskInfo.description}</div>
      </div>
    </c:if>

    <!-- 需求情景图片 -->
    <c:if test="${not empty taskInfo.demand && not empty taskInfo.demand.attachmentUrl}">
      <div class="section">
        <div class="section-title">情景图片</div>
        <div style="background:#f8fafc;padding:20px;border-radius:12px;text-align:center;">
          <img src="${pageContext.request.contextPath}${taskInfo.demand.attachmentUrl}" 
               alt="需求情景图片" 
               style="max-width:100%;max-height:400px;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.1);cursor:pointer;"
               onclick="window.open('${pageContext.request.contextPath}${taskInfo.demand.attachmentUrl}', '_blank')"/>
          <div style="color:#666;font-size:13px;margin-top:10px;">点击图片查看大图</div>
        </div>
      </div>
    </c:if>

    <!-- 执行信息 -->
    <c:if test="${not empty taskInfo.volunteerName}">
      <div class="section">
        <div class="section-title">执行信息</div>
        <div class="info-grid">
          <div class="info-item">
            <div class="info-label">志愿者</div>
            <div class="info-value">${taskInfo.volunteerName}</div>
          </div>
          <div class="info-item">
            <div class="info-label">认领时间</div>
            <div class="info-value"><fmt:formatDate value="${taskInfo.claimedTime}" pattern="yyyy-MM-dd HH:mm"/></div>
          </div>
          <c:if test="${not empty taskInfo.completedTime}">
            <div class="info-item">
              <div class="info-label">完成时间</div>
              <div class="info-value"><fmt:formatDate value="${taskInfo.completedTime}" pattern="yyyy-MM-dd HH:mm"/></div>
            </div>
          </c:if>
        </div>
        <c:if test="${not empty taskInfo.completionNote}">
          <div style="margin-top:16px;">
            <div class="info-label">完成说明</div>
            <div class="description-box">${taskInfo.completionNote}</div>
          </div>
        </c:if>
      </div>
    </c:if>

    <!-- 执行照片 -->
    <div class="section">
      <div class="section-title">执行记录（照片/视频）</div>
      <div id="executionPhotosContainer">
        <div class="photo-grid" id="photoGrid">
          <c:if test="${not empty taskInfo.executionPhotos}">
            <c:forEach items="${taskInfo.executionPhotos.split(',')}" var="media">
              <c:if test="${not empty media}">
                <div class="photo-item" data-url="${media}">
                  <c:choose>
                    <c:when test="${media.toLowerCase().endsWith('.mp4') || media.toLowerCase().endsWith('.avi') || media.toLowerCase().endsWith('.mov') || media.toLowerCase().endsWith('.webm') || media.toLowerCase().endsWith('.mkv')}">
                      <video src="${media}" controls style="width:100%;height:150px;object-fit:cover;background:#000;"></video>
                    </c:when>
                    <c:otherwise>
                      <img src="${media}" alt="执行照片" onclick="window.open('${media}', '_blank')">
                    </c:otherwise>
                  </c:choose>
                  <c:if test="${currentUser.roleType == 'VOLUNTEER' && taskInfo.volunteerId == currentUser.id && (taskInfo.status == 'IN_PROGRESS' || taskInfo.status == 'CLAIMED')}">
                    <button class="delete-btn" onclick="deleteMedia('${media}')" title="删除">×</button>
                  </c:if>
                </div>
              </c:if>
            </c:forEach>
          </c:if>
        </div>

        <!-- 志愿者上传区域（仅任务执行中可上传） -->
        <c:if test="${currentUser.roleType == 'VOLUNTEER' && taskInfo.volunteerId == currentUser.id && (taskInfo.status == 'IN_PROGRESS' || taskInfo.status == 'CLAIMED')}">
          <div class="upload-box" onclick="document.getElementById('mediaInput').click()" style="margin-top:16px;">
            <input type="file" id="mediaInput" accept="image/*,video/*" onchange="uploadMedia(this)">
            <div class="upload-icon">+</div>
            <div class="upload-text">点击上传执行照片或视频（支持多次上传，最大100MB）</div>
          </div>
        </c:if>

        <c:if test="${empty taskInfo.executionPhotos && (currentUser.roleType != 'VOLUNTEER' || taskInfo.volunteerId != currentUser.id || (taskInfo.status != 'IN_PROGRESS' && taskInfo.status != 'CLAIMED'))}">
          <div style="text-align:center;color:#999;padding:40px;">暂无执行照片</div>
        </c:if>
      </div>
    </div>

    <!-- 审核信息 -->
    <c:if test="${taskInfo.status == 'APPROVED' && not empty taskInfo.rating}">
      <div class="section">
        <div class="section-title">审核评价</div>
        <div class="info-grid">
          <div class="info-item">
            <div class="info-label">评分</div>
            <div class="info-value" style="color:#f59e0b;">${taskInfo.rating} / 5</div>
          </div>
          <c:if test="${not empty taskInfo.feedback}">
            <div class="info-item full">
              <div class="info-label">反馈意见</div>
              <div class="info-value">${taskInfo.feedback}</div>
            </div>
          </c:if>
        </div>
      </div>
    </c:if>

    <!-- 操作按钮 -->
    <div class="actions">
      <c:choose>
        <c:when test="${currentUser.roleType == 'STAFF'}">
          <!-- 管理员操作 -->
          <c:if test="${taskInfo.status == 'COMPLETED'}">
            <button class="btn btn-success" onclick="approveTask()">审核通过</button>
          </c:if>
          <c:if test="${taskInfo.status != 'APPROVED' && taskInfo.status != 'CANCELLED'}">
            <button class="btn btn-danger" onclick="closeTask()">关闭任务</button>
          </c:if>
          <button class="btn btn-secondary" onclick="history.back()">返回</button>
        </c:when>
        <c:otherwise>
          <!-- 志愿者操作 -->
          <c:if test="${taskInfo.status == 'PENDING'}">
            <button class="btn btn-primary" onclick="claimTask()">认领任务</button>
          </c:if>
          <c:if test="${taskInfo.status == 'CLAIMED' && taskInfo.volunteerId == currentUser.id}">
            <button class="btn btn-primary" onclick="startTask()">开始执行</button>
            <button class="btn btn-danger" onclick="cancelTask()">放弃任务</button>
          </c:if>
          <c:if test="${taskInfo.status == 'IN_PROGRESS' && taskInfo.volunteerId == currentUser.id}">
            <button class="btn btn-success" onclick="submitTask()">提交完成</button>
            <button class="btn btn-danger" onclick="cancelTask()">放弃任务</button>
          </c:if>
          <button class="btn btn-secondary" onclick="history.back()">返回</button>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>

<script>
const taskId = '${not empty taskInfo.id ? taskInfo.id : ""}';
const contextPath = '${pageContext.request.contextPath}';
const userRole = '${not empty currentUser.roleType ? currentUser.roleType : ""}';
const isAdmin = (userRole === 'STAFF');

function approveTask() {
  if (!taskId || taskId === 'null' || taskId === '') {
    alert('任务ID无效');
    return;
  }
  const rating = prompt('请输入评分(1-5):', '5');
  if (rating === null) return;
  const feedback = prompt('请输入反馈意见:');
  
  fetch(contextPath + '/admin/task/approve/' + taskId, {
    method: 'POST',
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: 'rating=' + rating + '&feedback=' + encodeURIComponent(feedback || '')
  })
  .then(response => response.json())
  .then(data => {
    alert(data.message);
    if (data.success) location.reload();
  })
  .catch(error => {
    console.error('Error:', error);
    alert('操作失败，请稍后重试');
  });
}

function closeTask() {
  if (!taskId || taskId === 'null') {
    alert('任务ID无效');
    return;
  }
  if (confirm('确定要关闭这个任务吗？')) {
    fetch(contextPath + '/admin/task/close/' + taskId, {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
      if (data.success) history.back();
    });
  }
}

function startTask() {
  if (!taskId || taskId === 'null') {
    alert('任务ID无效');
    return;
  }
  if (confirm('确定要开始执行这个任务吗？')) {
    fetch(contextPath + '/volunteer/task/start/' + taskId, {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
      if (data.success) location.reload();
    });
  }
}

function submitTask() {
  if (!taskId || taskId === 'null') {
    alert('任务ID无效');
    return;
  }
  const note = prompt('请输入完成说明（如：已完成购物并送达）:');
  if (note) {
    fetch(contextPath + '/volunteer/task/submit/' + taskId, {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'completionNote=' + encodeURIComponent(note)
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
      if (data.success) location.reload();
    });
  }
}

function cancelTask() {
  if (!taskId || taskId === 'null' || taskId === '') {
    alert('任务ID无效');
    return;
  }
  if (confirm('确定要放弃这个任务吗？')) {
    fetch(contextPath + '/volunteer/task/cancel/' + taskId, {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
      if (data.success) history.back();
    });
  }
}

function claimTask() {
  if (!taskId || taskId === 'null' || taskId === '') {
    alert('任务ID无效');
    return;
  }
  if (confirm('确定要认领这个任务吗？')) {
    fetch(contextPath + '/volunteer/task/claim/' + taskId, {
      method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message);
      if (data.success) {
        location.reload(); // 刷新页面显示新状态
      }
    })
    .catch(error => {
      console.error('Error:', error);
      alert('操作失败，请稍后重试');
    });
  }
}

// 上传执行照片或视频
function uploadMedia(input) {
  if (!input.files || !input.files[0]) return;

  const file = input.files[0];
  const maxSize = 100 * 1024 * 1024; // 100MB

  if (file.size > maxSize) {
    alert('文件大小不能超过100MB');
    input.value = '';
    return;
  }

  const formData = new FormData();
  formData.append('file', file);

  // 显示上传中提示
  const uploadBox = document.querySelector('.upload-box');
  const originalText = uploadBox.innerHTML;
  uploadBox.innerHTML = '<div style="color:#D32F2F;">上传中，请稍候...</div>';

  // 上传文件到服务器
  fetch(contextPath + '/upload/execution-media', {
    method: 'POST',
    body: formData
  })
  .then(response => response.json())
  .then(data => {
    // ApiResponse 使用 code 字段，200 表示成功
    if (data.code === 200 && data.data) {
      // 上传成功后，将媒体URL关联到任务
      const mediaUrl = data.data.url;
      return fetch(contextPath + '/volunteer/task/uploadPhoto/' + taskId, {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'photoUrl=' + encodeURIComponent(mediaUrl)
      });
    } else {
      throw new Error(data.message || '上传失败');
    }
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      alert('上传成功');
      location.reload();
    } else {
      alert(data.message || '保存失败');
      uploadBox.innerHTML = originalText;
    }
  })
  .catch(error => {
    console.error('Error:', error);
    alert('上传失败：' + error.message);
    uploadBox.innerHTML = originalText;
  });

  // 清空input以便重复上传同一文件
  input.value = '';
}

// 兼容旧函数名
function uploadPhoto(input) {
  uploadMedia(input);
}

// 删除执行媒体（照片或视频）
function deleteMedia(mediaUrl) {
  if (!confirm('确定要删除这个文件吗？')) return;

  fetch(contextPath + '/volunteer/task/deletePhoto/' + taskId, {
    method: 'POST',
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: 'photoUrl=' + encodeURIComponent(mediaUrl)
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      alert('删除成功');
      location.reload();
    } else {
      alert(data.message || '删除失败');
    }
  })
  .catch(error => {
    console.error('Error:', error);
    alert('删除失败');
  });
}

// 兼容旧函数名
function deletePhoto(photoUrl) {
  deleteMedia(photoUrl);
}
</script>
</body>
</html>
