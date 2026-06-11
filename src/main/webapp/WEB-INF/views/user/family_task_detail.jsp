<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<title>服务记录详情</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/gov-theme.css">
<style>
body{margin:0;background:#FAF5F0;font-family:'Microsoft YaHei',Arial,sans-serif;color:#1f2937}
.gov-header{background:linear-gradient(135deg,#B71C1C 0%,#D32F2F 100%);height:64px;padding:0 32px;display:flex;align-items:center;justify-content:space-between;box-shadow:0 2px 12px rgba(0,0,0,.15);position:relative;color:#fff}
.gov-header::before{content:'★';position:absolute;left:24px;color:rgba(255,255,255,.3);font-size:20px}.gov-header h1{color:#fff;font-size:18px;font-weight:600;margin:0 0 0 40px;letter-spacing:2px}.gov-header .nav-right{display:flex;align-items:center;gap:24px;color:rgba(255,255,255,.9);font-size:13px;flex-wrap:wrap}.gov-header .nav-right a{color:rgba(255,255,255,.9);text-decoration:none;padding:6px 12px;border-radius:4px;transition:all .2s}.gov-header .nav-right a:hover{background:rgba(255,255,255,.15);color:#fff}
.container{max-width:1100px;margin:0 auto;padding:24px 20px}.card{background:#fff;border-radius:12px;padding:24px;box-shadow:0 2px 10px rgba(0,0,0,.06);border:1px solid #eee}.section{margin-bottom:28px}.section-title{font-size:20px;font-weight:700;color:#1f2937;border-left:4px solid #D32F2F;padding-left:12px;margin-bottom:16px}.info-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:16px}.info-item{background:#f9fafb;padding:14px;border-radius:8px;border:1px solid #edf2f7}.info-item.full{grid-column:1/-1}.info-label{font-size:13px;color:#6b7280;margin-bottom:6px}.info-value{font-size:15px;color:#111827;font-weight:600;line-height:1.7}.description-box{background:#f9fafb;padding:16px;border-radius:8px;line-height:1.8;color:#374151;border:1px solid #edf2f7;white-space:pre-wrap}
.photo-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:16px}.photo-item{background:#f3f4f6;border-radius:10px;overflow:hidden;border:1px solid #e5e7eb}.photo-item img,.photo-item video{width:100%;height:180px;object-fit:cover;display:block;background:#000}.photo-meta{padding:10px 12px;font-size:12px;color:#6b7280;background:#fff}.empty-photos{text-align:center;color:#999;padding:40px;background:#f9fafb;border-radius:10px;border:1px dashed #d1d5db}.btn{display:inline-block;padding:10px 18px;background:#6b7280;color:#fff;border-radius:8px;text-decoration:none;font-weight:600;border:none;cursor:pointer}.btn:hover{opacity:.9}.actions{display:flex;gap:12px;flex-wrap:wrap;margin-top:24px}
@media (max-width:768px){.gov-header{padding:10px 16px;height:auto;min-height:64px;flex-direction:column;align-items:flex-start;justify-content:center;gap:8px}.gov-header h1{margin-left:32px}.container{padding:18px 14px}.card{padding:18px}.photo-grid{grid-template-columns:1fr}}
</style>
</head>
<body>
<header class="gov-header">
  <h1>家属服务中心</h1>
  <div class="nav-right">
    <span>当前页面：服务记录详情</span>
    <a href="${pageContext.request.contextPath}/user/family/dashboard">控制台</a>
    <a href="${pageContext.request.contextPath}/user/family/service-records">返回服务记录</a>
  </div>
</header>

<div class="container">
  <div class="card">
    <div class="section">
      <div class="section-title">任务基本信息</div>
      <div class="info-grid">
        <div class="info-item"><div class="info-label">任务标题</div><div class="info-value">${taskInfo.taskTitle}</div></div>
        <div class="info-item"><div class="info-label">任务状态</div><div class="info-value">${taskInfo.status}</div></div>
        <div class="info-item"><div class="info-label">关爱对象</div><div class="info-value">${taskInfo.elderlyName}</div></div>
        <div class="info-item"><div class="info-label">志愿者</div><div class="info-value">${taskInfo.volunteerName}</div></div>
        <div class="info-item"><div class="info-label">联系电话</div><div class="info-value">${taskInfo.contactPhone}</div></div>
        <div class="info-item"><div class="info-label">服务时间</div><div class="info-value"><fmt:formatDate value="${taskInfo.scheduledDate}" pattern="yyyy-MM-dd"/> ${taskInfo.scheduledTime}</div></div>
        <div class="info-item full"><div class="info-label">服务地址</div><div class="info-value">${taskInfo.address}</div></div>
        <div class="info-item full"><div class="info-label">任务描述</div><div class="description-box">${taskInfo.description}</div></div>
        <c:if test="${not empty taskInfo.completionNote}"><div class="info-item full"><div class="info-label">完成说明</div><div class="description-box">${taskInfo.completionNote}</div></div></c:if>
      </div>
    </div>

    <div class="section">
      <div class="section-title">服务记录（照片/视频）</div>
      <c:choose>
        <c:when test="${not empty taskInfo.executionPhotos}">
          <div class="photo-grid">
            <c:forEach items="${taskInfo.executionPhotos.split(',')}" var="media" varStatus="status">
              <c:if test="${not empty media}">
                <div class="photo-item">
                  <c:choose>
                    <c:when test="${media.toLowerCase().endsWith('.mp4') || media.toLowerCase().endsWith('.avi') || media.toLowerCase().endsWith('.mov') || media.toLowerCase().endsWith('.webm') || media.toLowerCase().endsWith('.mkv')}">
                      <video src="${pageContext.request.contextPath}${media}" controls></video>
                    </c:when>
                    <c:otherwise>
                      <img src="${pageContext.request.contextPath}${media}" alt="服务照片${status.index + 1}" onclick="window.open('${pageContext.request.contextPath}${media}', '_blank')">
                    </c:otherwise>
                  </c:choose>
                  <div class="photo-meta">第 ${status.index + 1} 个记录文件</div>
                </div>
              </c:if>
            </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <div class="empty-photos">暂无服务照片或视频</div>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="actions">
      <button class="btn" onclick="history.back()">返回</button>
    </div>
  </div>
</div>
</body>
</html>
