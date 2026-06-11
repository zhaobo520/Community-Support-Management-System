<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<title>任务详情</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/gov-theme.css">
<style>
body{margin:0;background:#f5f7fa;font-family:Arial,sans-serif}
.container{max-width:1200px;margin:0 auto;padding:20px}
.card{background:#fff;border-radius:12px;padding:24px;box-shadow:0 2px 8px rgba(0,0,0,.08)}
.section{margin-bottom:28px}
.section-title{font-size:20px;font-weight:700;color:#1f2937;border-left:4px solid #D32F2F;padding-left:12px;margin-bottom:16px}
.info-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:16px}
.info-item{background:#f9fafb;padding:14px;border-radius:8px}.info-item.full{grid-column:1/-1}
.info-label{font-size:13px;color:#6b7280;margin-bottom:6px}.info-value{font-size:15px;color:#111827;font-weight:600}
.description-box{background:#f9fafb;padding:16px;border-radius:8px;line-height:1.7;color:#374151}
.photo-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:16px}
.photo-item{position:relative;background:#f3f4f6;border-radius:10px;overflow:hidden}
.photo-item img,.photo-item video{width:100%;height:150px;object-fit:cover;display:block}
.delete-btn{position:absolute;top:8px;right:8px;width:28px;height:28px;border:none;border-radius:50%;background:rgba(220,38,38,.9);color:#fff;cursor:pointer;font-size:18px;line-height:28px}
.upload-box{border:2px dashed #d1d5db;border-radius:10px;padding:24px;text-align:center;cursor:pointer;background:#fafafa}
.upload-box:hover{border-color:#D32F2F;background:#fff5f5}.upload-box input{display:none}.upload-icon{font-size:36px;color:#9ca3af}.upload-text{margin-top:8px;color:#6b7280}
.actions{display:flex;gap:12px;flex-wrap:wrap;margin-top:24px}.btn{padding:10px 18px;border:none;border-radius:8px;cursor:pointer;font-weight:600}.btn-primary{background:#2563eb;color:#fff}.btn-success{background:#16a34a;color:#fff}.btn-danger{background:#dc2626;color:#fff}.btn-secondary{background:#6b7280;color:#fff}
</style>
</head>
<body>
<div class="container">
  <div class="card">
    <div class="section">
      <div class="section-title">任务基本信息</div>
      <div class="info-grid">
        <div class="info-item"><div class="info-label">任务标题</div><div class="info-value">${taskInfo.taskTitle}</div></div>
        <div class="info-item"><div class="info-label">任务状态</div><div class="info-value">${taskInfo.status}</div></div>
        <div class="info-item"><div class="info-label">关爱对象</div><div class="info-value">${taskInfo.elderlyName}</div></div>
        <div class="info-item"><div class="info-label">联系电话</div><div class="info-value">${taskInfo.contactPhone}</div></div>
        <c:if test="${not empty taskInfo.demand && not empty taskInfo.demand.intendedVolunteer}">
          <div class="info-item">
            <div class="info-label">家属意向志愿者</div>
            <div class="info-value" style="color:#F57C00;">
              ★ ${taskInfo.demand.intendedVolunteer.fullName}
              <c:if test="${not empty taskInfo.demand.intendedVolunteer.phone}">
                <span style="color:#6b7280;font-size:12px;"> · ${taskInfo.demand.intendedVolunteer.phone}</span>
              </c:if>
            </div>
          </div>
        </c:if>
        <div class="info-item full"><div class="info-label">服务地址</div><div class="info-value">${taskInfo.address}</div></div>
        <div class="info-item full"><div class="info-label">任务描述</div><div class="description-box">${taskInfo.description}</div></div>
        <c:if test="${not empty taskInfo.completionNote}"><div class="info-item full"><div class="info-label">完成说明</div><div class="description-box">${taskInfo.completionNote}</div></div></c:if>
      </div>
    </div>

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
                      <video src="${pageContext.request.contextPath}${media}" controls style="width:100%;height:150px;object-fit:cover;background:#000;"></video>
                    </c:when>
                    <c:otherwise>
                      <img src="${pageContext.request.contextPath}${media}" alt="执行照片" onclick="window.open('${pageContext.request.contextPath}${media}', '_blank')">
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

    <div class="actions">
      <button class="btn btn-secondary" onclick="history.back()">返回</button>
    </div>
  </div>
</div>

<script>
const taskId = '${not empty taskInfo.id ? taskInfo.id : ""}';
const contextPath = '${pageContext.request.contextPath}';
function fullMediaUrl(url){ return url.indexOf('http')===0 ? url : contextPath + url; }
function isVideo(url){ return /\.(mp4|avi|mov|webm|mkv)$/i.test(url); }
function appendMediaItem(mediaUrl, canDelete){
  const grid = document.getElementById('photoGrid');
  const div = document.createElement('div');
  div.className = 'photo-item';
  div.setAttribute('data-url', mediaUrl);
  const fullUrl = fullMediaUrl(mediaUrl);
  if(isVideo(mediaUrl)){
    div.innerHTML = '<video src="'+fullUrl+'" controls style="width:100%;height:150px;object-fit:cover;background:#000;"></video>' + (canDelete ? '<button class="delete-btn" onclick="deleteMedia(\''+mediaUrl+'\')" title="删除">×</button>' : '');
  } else {
    div.innerHTML = '<img src="'+fullUrl+'" alt="执行照片" onclick="window.open(\''+fullUrl+'\', \"_blank\")">' + (canDelete ? '<button class="delete-btn" onclick="deleteMedia(\''+mediaUrl+'\')" title="删除">×</button>' : '');
  }
  grid.appendChild(div);
}
function uploadMedia(input) {
  if (!input.files || !input.files[0]) return;
  const file = input.files[0];
  const maxSize = 100 * 1024 * 1024;
  if (file.size > maxSize) { alert('文件大小不能超过100MB'); input.value=''; return; }
  const formData = new FormData();
  formData.append('file', file);
  const uploadBox = document.querySelector('.upload-box');
  const originalText = uploadBox.innerHTML;
  uploadBox.innerHTML = '<div style="color:#D32F2F;">上传中，请稍候...</div>';
  fetch(contextPath + '/upload/execution-media', { method: 'POST', body: formData })
  .then(r => r.json())
  .then(data => {
    if (data.code === 200 && data.data) {
      const mediaUrl = data.data.url;
      return fetch(contextPath + '/volunteer/task/uploadPhoto/' + taskId, {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'photoUrl=' + encodeURIComponent(mediaUrl)
      }).then(r => r.json()).then(saveData => ({saveData, mediaUrl}));
    }
    throw new Error(data.message || '上传失败');
  })
  .then(({saveData, mediaUrl}) => {
    if (saveData.success) {
      appendMediaItem(mediaUrl, true);
      alert('上传成功');
    } else {
      alert(saveData.message || '保存失败');
    }
    uploadBox.innerHTML = originalText;
  })
  .catch(error => {
    console.error('Error:', error);
    alert('上传失败：' + error.message);
    uploadBox.innerHTML = originalText;
  });
  input.value = '';
}
function deleteMedia(mediaUrl) {
  if (!confirm('确定要删除这个文件吗？')) return;
  fetch(contextPath + '/volunteer/task/deletePhoto/' + taskId, {
    method: 'POST',
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: 'photoUrl=' + encodeURIComponent(mediaUrl)
  })
  .then(r => r.json())
  .then(data => {
    if (data.success) {
      const item = document.querySelector('[data-url="' + mediaUrl + '"]');
      if (item) item.remove();
      alert('删除成功');
    } else {
      alert(data.message || '删除失败');
    }
  })
  .catch(error => { console.error('Error:', error); alert('删除失败'); });
}
</script>
</body>
</html>