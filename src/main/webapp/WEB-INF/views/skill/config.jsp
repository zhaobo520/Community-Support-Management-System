<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>技能配置</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #FAF5F0;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            background: white;
            border-radius: 4px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title h1 {
            font-size: 32px;
            background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 8px;
        }

        .header-subtitle {
            color: #666;
            font-size: 14px;
        }

        .header-actions {
            display: flex;
            gap: 12px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            font-size: 14px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.4);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
        }

        .stats-bar {
            background: white;
            border-radius: 4px;
            padding: 20px 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            display: flex;
            justify-content: space-around;
            align-items: center;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 36px;
            font-weight: bold;
            background: linear-gradient(135deg, #D32F2F 0%, #B71C1C 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .stat-label {
            color: #666;
            font-size: 14px;
            margin-top: 4px;
        }

        .skill-category {
            background: white;
            border-radius: 4px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .category-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .category-icon {
            font-size: 28px;
            margin-right: 12px;
        }

        .category-title {
            font-size: 20px;
            font-weight: bold;
            color: #333;
        }

        .category-count {
            margin-left: auto;
            background: #f0f4ff;
            color: #D32F2F;
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .skill-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
        }

        .skill-card {
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            padding: 16px;
            cursor: pointer;
            transition: all 0.3s;
            background: white;
            position: relative;
            overflow: hidden;
        }

        .skill-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #D32F2F 0%, #B71C1C 100%);
            transform: scaleX(0);
            transition: transform 0.3s;
        }

        .skill-card:hover {
            border-color: #D32F2F;
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
        }

        .skill-card:hover::before {
            transform: scaleX(1);
        }

        .skill-card.selected {
            border-color: #D32F2F;
            background: linear-gradient(135deg, #f0f4ff 0%, #f8f9ff 100%);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }

        .skill-card.selected::before {
            transform: scaleX(1);
        }

        .skill-icon {
            font-size: 32px;
            margin-bottom: 8px;
        }

        .skill-name {
            font-size: 15px;
            font-weight: bold;
            color: #333;
            margin-bottom: 4px;
        }

        .skill-desc {
            font-size: 12px;
            color: #999;
            line-height: 1.4;
        }

        .skill-check {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #10b981;
            color: white;
            display: none;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }

        .skill-card.selected .skill-check {
            display: flex;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-icon {
            font-size: 64px;
            margin-bottom: 16px;
        }

        .floating-panel {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: white;
            border-radius: 4px;
            padding: 20px 25px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
            min-width: 250px;
            display: none;
        }

        .floating-panel.show {
            display: block;
            animation: slideUp 0.3s ease-out;
        }

        @keyframes slideUp {
            from {
                transform: translateY(100px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .floating-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 12px;
            color: #333;
        }

        .floating-count {
            font-size: 14px;
            color: #666;
            margin-bottom: 15px;
        }

        .floating-count span {
            color: #D32F2F;
            font-weight: bold;
            font-size: 18px;
        }

        .level-selector {
            margin-top: 20px;
        }

        .level-label {
            font-size: 13px;
            color: #666;
            margin-bottom: 8px;
        }

        .level-options {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 8px;
        }

        .level-option {
            padding: 8px;
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            text-align: center;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .level-option:hover {
            border-color: #D32F2F;
        }

        .level-option.selected {
            border-color: #D32F2F;
            background: #f0f4ff;
            color: #D32F2F;
            font-weight: bold;
        }

        @media (max-width: 768px) {
            .skill-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            }

            .stats-bar {
                flex-direction: column;
                gap: 15px;
            }

            .floating-panel {
                right: 15px;
                left: 15px;
                bottom: 15px;
            }
        }

        .loading {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #D32F2F;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto 15px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>技能配置</h1>
                <p class="header-subtitle">更新您的志愿服务技能标签，获得更精准的任务匹配</p>
            </div>
            <div class="header-actions">
                <button class="btn btn-success" onclick="saveSkills()">保存技能</button>
                <a href="${pageContext.request.contextPath}/user/volunteer/dashboard" class="btn btn-primary">← 返回首页</a>
            </div>
        </div>
    </div>

    <!-- Stats Bar -->
    <div class="stats-bar">
        <div class="stat-item">
            <div class="stat-number" id="totalSkills">30</div>
            <div class="stat-label">可选技能</div>
        </div>
        <div class="stat-item">
            <div class="stat-number" id="selectedCount">0</div>
            <div class="stat-label">已选技能</div>
        </div>
        <div class="stat-item">
            <div class="stat-number" id="categoryCount">6</div>
            <div class="stat-label">技能分类</div>
        </div>
    </div>

    <!-- 护理类技能 -->
    <c:if test="${not empty skillsMap['CARE']}">
    <div class="skill-category">
        <div class="category-header">
            <span class="category-icon">护理</span>
            <span class="category-title">护理类技能</span>
            <span class="category-count">${skillsMap['CARE'].size()}项</span>
        </div>
        <div class="skill-grid" id="category-CARE">
            <c:forEach items="${skillsMap['CARE']}" var="skill">
                <div class="skill-card" data-skill-id="${skill.id}" onclick="toggleSkill(this)">
                    <div class="skill-check">√</div>
                    <div class="skill-icon">${skill.icon}</div>
                    <div class="skill-name">${skill.skillName}</div>
                    <div class="skill-desc">${skill.description}</div>
                </div>
            </c:forEach>
        </div>
    </div>
    </c:if>

    <!-- 生活类技能 -->
    <c:if test="${not empty skillsMap['LIFE']}">
    <div class="skill-category">
        <div class="category-header">
            <span class="category-icon">烹饪</span>
            <span class="category-title">生活类技能</span>
            <span class="category-count">${skillsMap['LIFE'].size()}项</span>
        </div>
        <div class="skill-grid" id="category-LIFE">
            <c:forEach items="${skillsMap['LIFE']}" var="skill">
                <div class="skill-card" data-skill-id="${skill.id}" onclick="toggleSkill(this)">
                    <div class="skill-check">√</div>
                    <div class="skill-icon">${skill.icon}</div>
                    <div class="skill-name">${skill.skillName}</div>
                    <div class="skill-desc">${skill.description}</div>
                </div>
            </c:forEach>
        </div>
    </div>
    </c:if>

    <!-- 健康类技能 -->
    <c:if test="${not empty skillsMap['HEALTH']}">
    <div class="skill-category">
        <div class="category-header">
            <span class="category-icon">就医</span>
            <span class="category-title">健康类技能</span>
            <span class="category-count">${skillsMap['HEALTH'].size()}项</span>
        </div>
        <div class="skill-grid" id="category-HEALTH">
            <c:forEach items="${skillsMap['HEALTH']}" var="skill">
                <div class="skill-card" data-skill-id="${skill.id}" onclick="toggleSkill(this)">
                    <div class="skill-check">√</div>
                    <div class="skill-icon">${skill.icon}</div>
                    <div class="skill-name">${skill.skillName}</div>
                    <div class="skill-desc">${skill.description}</div>
                </div>
            </c:forEach>
        </div>
    </div>
    </c:if>

    <!-- 陪伴类技能 -->
    <c:if test="${not empty skillsMap['COMPANION']}">
    <div class="skill-category">
        <div class="category-header">
            <span class="category-icon">陪伴</span>
            <span class="category-title">陪伴类技能</span>
            <span class="category-count">${skillsMap['COMPANION'].size()}项</span>
        </div>
        <div class="skill-grid" id="category-COMPANION">
            <c:forEach items="${skillsMap['COMPANION']}" var="skill">
                <div class="skill-card" data-skill-id="${skill.id}" onclick="toggleSkill(this)">
                    <div class="skill-check">√</div>
                    <div class="skill-icon">${skill.icon}</div>
                    <div class="skill-name">${skill.skillName}</div>
                    <div class="skill-desc">${skill.description}</div>
                </div>
            </c:forEach>
        </div>
    </div>
    </c:if>

    <!-- 维修类技能 -->
    <c:if test="${not empty skillsMap['REPAIR']}">
    <div class="skill-category">
        <div class="category-header">
            <span class="category-icon">维修</span>
            <span class="category-title">维修类技能</span>
            <span class="category-count">${skillsMap['REPAIR'].size()}项</span>
        </div>
        <div class="skill-grid" id="category-REPAIR">
            <c:forEach items="${skillsMap['REPAIR']}" var="skill">
                <div class="skill-card" data-skill-id="${skill.id}" onclick="toggleSkill(this)">
                    <div class="skill-check">√</div>
                    <div class="skill-icon">${skill.icon}</div>
                    <div class="skill-name">${skill.skillName}</div>
                    <div class="skill-desc">${skill.description}</div>
                </div>
            </c:forEach>
        </div>
    </div>
    </c:if>

    <!-- 其他技能 -->
    <c:if test="${not empty skillsMap['OTHER']}">
    <div class="skill-category">
        <div class="category-header">
            <span class="category-icon">其他</span>
            <span class="category-title">其他技能</span>
            <span class="category-count">${skillsMap['OTHER'].size()}项</span>
        </div>
        <div class="skill-grid" id="category-OTHER">
            <c:forEach items="${skillsMap['OTHER']}" var="skill">
                <div class="skill-card" data-skill-id="${skill.id}" onclick="toggleSkill(this)">
                    <div class="skill-check">√</div>
                    <div class="skill-icon">${skill.icon}</div>
                    <div class="skill-name">${skill.skillName}</div>
                    <div class="skill-desc">${skill.description}</div>
                </div>
            </c:forEach>
        </div>
    </div>
    </c:if>
</div>

<!-- Floating Panel -->
<div class="floating-panel" id="floatingPanel">
    <div class="floating-title">已选技能</div>
    <div class="floating-count">共选择 <span id="floatingCount">0</span> 项技能</div>
    <button class="btn btn-success" style="width: 100%;" onclick="saveSkills()">保存配置</button>
</div>

<script>
    let selectedSkills = new Set();
    let mySkills = [];

    // 页面加载时初始化
    window.onload = function() {
        loadMySkills();
        updateStats();
    };

    // 预加载我的技能ID列表
    const mySkillIds = [
        <c:forEach items="${mySkills}" var="mySkill" varStatus="status">
            ${mySkill.skillId}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    // 加载我的技能
    function loadMySkills() {
        mySkillIds.forEach(function(skillId) {
            selectedSkills.add(skillId);
            mySkills.push(skillId);
            
            // 标记为已选
            const card = document.querySelector('[data-skill-id="' + skillId + '"]');
            if (card) {
                card.classList.add('selected');
            }
        });
        
        updateSelectedCount();
    }

    // 切换技能选择
    function toggleSkill(card) {
        const skillId = parseInt(card.getAttribute('data-skill-id'));
        
        if (selectedSkills.has(skillId)) {
            selectedSkills.delete(skillId);
            card.classList.remove('selected');
        } else {
            selectedSkills.add(skillId);
            card.classList.add('selected');
        }
        
        updateSelectedCount();
    }

    // 更新已选数量
    function updateSelectedCount() {
        const count = selectedSkills.size;
        document.getElementById('selectedCount').textContent = count;
        document.getElementById('floatingCount').textContent = count;
        
        const panel = document.getElementById('floatingPanel');
        if (count > 0) {
            panel.classList.add('show');
        } else {
            panel.classList.remove('show');
        }
    }

    // 更新统计信息
    function updateStats() {
        const totalCards = document.querySelectorAll('.skill-card').length;
        document.getElementById('totalSkills').textContent = totalCards;
        
        const categories = document.querySelectorAll('.skill-category').length;
        document.getElementById('categoryCount').textContent = categories;
    }

    // 保存技能
    function saveSkills() {
        const skillIds = Array.from(selectedSkills);
        
        if (skillIds.length === 0) {
            if (!confirm('您还没有选择任何技能，确定要清空技能配置吗？')) {
                return;
            }
        }
        
        fetch('${pageContext.request.contextPath}/skill/update', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'skillIds=' + skillIds.join(',')
        })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                alert('技能配置保存成功！\n\n已选择 ' + skillIds.length + ' 项技能。');
                // 可选：跳转回Dashboard
                // window.location.href = '${pageContext.request.contextPath}/user/volunteer/dashboard';
            } else {
                alert('保存失败：' + result.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('请求失败，请稍后重试');
        });
    }
</script>
</body>
</html>
