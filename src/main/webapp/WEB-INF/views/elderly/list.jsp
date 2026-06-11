<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>关爱对象管理</title>
  <link href="${pageContext.request.contextPath}/css/gov-theme.css" rel="stylesheet">
  <style>
    body {
      background: #FAF5F0;
      min-height: 100vh;
      margin: 0;
      padding: 0;
    }

    /* 顶部导航栏 */
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
      content: '★';
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
      padding: 40px 60px;
      max-width: 1400px;
      margin: 0 auto;
    }

    .header-section {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 32px;
    }

    .stats {
      display: flex;
      gap: 20px;
    }

    .stat-item {
      background: #fff;
      padding: 12px 24px;
      border-radius: 4px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      border-left: 4px solid #D32F2F;
    }

    .stat-item span {
      font-size: 24px;
      font-weight: 700;
      color: #D32F2F;
      margin-right: 8px;
    }

    .btn-add {
      background: white;
      color: #D32F2F;
      border: 1px solid #D32F2F;
      padding: 10px 24px;
      border-radius: 2px;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s;
      display: inline-block;
    }

    .btn-add:hover {
      background: #D32F2F;
      color: white;
    }

    .search-bar {
      background: #fff;
      padding: 20px 24px;
      border-radius: 4px;
      margin-bottom: 24px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      border-left: 4px solid #D32F2F;
    }

    .search-bar form {
      display: flex;
      gap: 12px;
      align-items: center;
      flex-wrap: wrap;
    }

    .search-bar input, .search-bar select {
      padding: 8px 14px;
      border: 1px solid #E0E0E0;
      border-radius: 2px;
      font-size: 14px;
      flex: 1;
      min-width: 150px;
    }

    .search-bar input:focus, .search-bar select:focus {
      outline: none;
      border-color: #D32F2F;
      box-shadow: 0 0 0 2px rgba(211, 47, 47, 0.1);
    }

    .search-bar button {
      padding: 8px 24px;
      background: white;
      color: #D32F2F;
      border: 1px solid #D32F2F;
      border-radius: 2px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
    }

    .search-bar button:hover {
      background: #D32F2F;
      color: white;
    }

    .elderly-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
      gap: 24px;
    }

    .elderly-card {
      background: #fff;
      border-radius: 4px;
      padding: 24px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      transition: all 0.3s;
      position: relative;
      overflow: hidden;
      border: 1px solid #E0E0E0;
    }

    .elderly-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 16px rgba(0,0,0,0.15);
      border-color: #EF9A9A;
    }

    .elderly-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
    }

    .elderly-card.urgent::before { background: #B71C1C; }
    .elderly-card.high::before { background: #D32F2F; }
    .elderly-card.medium::before { background: #FF5252; }
    .elderly-card.low::before { background: #D32F2F; }

    .card-header {
      display: flex;
      align-items: center;
      gap: 16px;
      margin-bottom: 16px;
    }

    .avatar {
      width: 60px;
      height: 60px;
      border-radius: 4px;
      background: linear-gradient(135deg, #B71C1C, #D32F2F);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
      font-size: 24px;
      font-weight: 700;
      box-shadow: 0 2px 6px rgba(183, 28, 28, 0.3);
      overflow: hidden;
    }

    .avatar img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .card-info h3 {
      font-size: 18px;
      color: #212121;
      margin-bottom: 4px;
      margin-top: 0;
    }

    .card-info p {
      font-size: 13px;
      color: #666;
      margin: 0;
    }

    .tags {
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
      margin-bottom: 16px;
    }

    .tag {
      padding: 4px 12px;
      border-radius: 2px;
      font-size: 12px;
      font-weight: 600;
      border: 1px solid;
    }

    .tag.urgent { background: rgba(183,28,28,0.1); color: #B71C1C; border-color: rgba(183,28,28,0.3); }
    .tag.high { background: rgba(211,47,47,0.1); color: #D32F2F; border-color: rgba(211,47,47,0.3); }
    .tag.medium { background: rgba(255,82,82,0.1); color: #FF5252; border-color: rgba(255,82,82,0.3); }
    .tag.low { background: rgba(211, 47, 47,0.1); color: #D32F2F; border-color: rgba(211, 47, 47,0.3); }
    .tag.alone { background: rgba(211,47,47,0.1); color: #D32F2F; border-color: rgba(211,47,47,0.3); }

    .card-details {
      font-size: 14px;
      color: #666;
      line-height: 1.8;
      margin-bottom: 16px;
    }

    .card-details div {
      display: flex;
      justify-content: space-between;
      padding: 4px 0;
    }

    .card-actions {
      display: flex;
      gap: 8px;
    }

    .btn {
      flex: 1;
      padding: 8px;
      border: 1px solid;
      border-radius: 2px;
      font-weight: 600;
      font-size: 13px;
      cursor: pointer;
      text-align: center;
      text-decoration: none;
      display: inline-block;
      transition: all 0.3s;
    }

    .btn-view {
      background: white;
      color: #D32F2F;
      border-color: #D32F2F;
    }

    .btn-view:hover {
      background: #D32F2F;
      color: white;
    }

    .btn-edit {
      background: white;
      color: #D32F2F;
      border-color: #D32F2F;
    }

    .btn-edit:hover {
      background: #D32F2F;
      color: white;
    }

    .btn-delete {
      background: white;
      color: #B71C1C;
      border-color: #B71C1C;
    }

    .btn-delete:hover {
      background: #B71C1C;
      color: white;
    }

    .empty {
      text-align: center;
      padding: 60px;
      color: #999;
      background: white;
      border-radius: 4px;
      margin-top: 40px;
    }

    .empty h2 {
      color: #666;
      margin-bottom: 12px;
    }
  </style>
</head>
<body>
<header class="gov-header">
  <h1>关爱对象管理</h1>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/user/admin/dashboard">返回控制台</a>
    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
  </div>
</header>

<div class="container">
  <div class="header-section">
    <div class="stats">
      <div class="stat-item">
        <span>${total}</span>总计
      </div>
    </div>
    <a href="${pageContext.request.contextPath}/admin/elderly/add" class="btn-add">+ 添加关爱对象</a>
  </div>

  <div class="search-bar">
    <form action="${pageContext.request.contextPath}/admin/elderly/list" method="get">
      <input type="text" name="keyword" placeholder="搜索姓名、电话、地址..." value="${keyword}"/>
      <select name="careLevel">
        <option value="">全部等级</option>
        <option value="URGENT" ${careLevel == 'URGENT' ? 'selected' : ''}>紧急</option>
        <option value="HIGH" ${careLevel == 'HIGH' ? 'selected' : ''}>高</option>
        <option value="MEDIUM" ${careLevel == 'MEDIUM' ? 'selected' : ''}>中</option>
        <option value="LOW" ${careLevel == 'LOW' ? 'selected' : ''}>低</option>
      </select>
      <select name="livingAlone">
        <option value="">全部状态</option>
        <option value="1" ${livingAlone == 1 ? 'selected' : ''}>独居</option>
        <option value="0" ${livingAlone == 0 ? 'selected' : ''}>非独居</option>
      </select>
      <button type="submit">搜索</button>
    </form>
  </div>

  <div class="elderly-grid">
    <c:forEach items="${list}" var="elderly">
      <div class="elderly-card ${elderly.careLevel == 'URGENT' ? 'urgent' : elderly.careLevel == 'HIGH' ? 'high' : elderly.careLevel == 'MEDIUM' ? 'medium' : 'low'}">
        <div class="card-header">
          <div class="avatar">
            <c:choose>
              <c:when test="${not empty elderly.photoUrl}">
                <c:choose>
                  <c:when test="${fn:startsWith(elderly.photoUrl, pageContext.request.contextPath)}">
                    <img src="${pageContext.request.contextPath}${elderly.photoUrl}" alt="${elderly.name}">
                  </c:when>
                  <c:otherwise>
                    <img src="${pageContext.request.contextPath}${elderly.photoUrl}" alt="${elderly.name}">
                  </c:otherwise>
                </c:choose>
              </c:when>
              <c:otherwise>
                ${elderly.name.substring(0,1)}
              </c:otherwise>
            </c:choose>
          </div>
          <div class="card-info">
            <h3>${elderly.name}</h3>
            <p>${elderly.age}岁 · ${elderly.gender == 'MALE' ? '男' : '女'}</p>
          </div>
        </div>

        <div class="tags">
          <span class="tag ${elderly.careLevel == 'URGENT' ? 'urgent' : elderly.careLevel == 'HIGH' ? 'high' : elderly.careLevel == 'MEDIUM' ? 'medium' : 'low'}">
            ${elderly.careLevel == 'URGENT' ? '紧急' : elderly.careLevel == 'HIGH' ? '高等级' : elderly.careLevel == 'MEDIUM' ? '中等级' : '低等级'}
          </span>
          <c:if test="${elderly.livingAlone == 1}">
            <span class="tag alone">独居</span>
          </c:if>
        </div>

        <div class="card-details">
          <div><span>电话：</span><span>${elderly.phone}</span></div>
          <div><span>地址：</span><span>${elderly.address}</span></div>
          <div><span>家属：</span><span>${elderly.familyContact} ${elderly.familyPhone}</span></div>
        </div>

        <div class="card-actions">
          <a href="${pageContext.request.contextPath}/admin/elderly/detail/${elderly.id}" class="btn btn-view">查看</a>
          <a href="${pageContext.request.contextPath}/admin/elderly/edit/${elderly.id}" class="btn btn-edit">编辑</a>
          <button class="btn btn-delete" onclick="deleteElderly(${elderly.id})">删除</button>
        </div>
      </div>
    </c:forEach>
  </div>

  <c:if test="${empty list}">
    <div class="empty">
      <h2>暂无关爱对象数据</h2>
      <p>点击右上角"添加关爱对象"按钮开始录入信息</p>
    </div>
  </c:if>
</div>

<script>
function deleteElderly(id) {
  if (confirm('确定要删除这条记录吗？')) {
    fetch('${pageContext.request.contextPath}/admin/elderly/delete/' + id, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        alert('删除成功');
        location.reload();
      } else {
        alert('删除失败：' + data.message);
      }
    })
    .catch(error => {
      alert('操作失败');
    });
  }
}
</script>
</body>
</html>


