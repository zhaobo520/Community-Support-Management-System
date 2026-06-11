<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>技能配置</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(180deg, #f9f4ef 0%, #f6efe8 100%);
            min-height: 100vh;
            padding: 24px;
            color: #333;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        .page-header {
            background: linear-gradient(90deg, #b71c1c 0%, #d32f2f 100%);
            color: white;
            border-radius: 14px;
            padding: 26px 30px;
            margin-bottom: 24px;
            box-shadow: 0 10px 28px rgba(183, 28, 28, 0.18);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }
        .page-header h1 {
            font-size: 30px;
            margin-bottom: 8px;
            letter-spacing: 1px;
        }
        .page-header p {
            font-size: 14px;
            color: rgba(255,255,255,0.92);
            line-height: 1.7;
        }
        .header-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 18px;
            border-radius: 10px;
            text-decoration: none;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.25s ease;
        }
        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 18px rgba(0,0,0,0.14);
        }
        .btn-primary {
            background: white;
            color: #d32f2f;
        }
        .btn-success {
            background: #10b981;
            color: white;
        }
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        .summary-card {
            background: rgba(255,255,255,0.96);
            border-radius: 14px;
            padding: 20px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.06);
            border: 1px solid #f3e5e5;
            position: relative;
            overflow: hidden;
        }
        .summary-card::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 5px;
            background: linear-gradient(180deg, #d32f2f 0%, #b71c1c 100%);
        }
        .summary-value {
            font-size: 30px;
            font-weight: bold;
            color: #d32f2f;
            margin-bottom: 6px;
        }
        .summary-label {
            font-size: 13px;
            color: #666;
        }
        .toolbar {
            background: rgba(255,255,255,0.96);
            border-radius: 14px;
            padding: 18px 20px;
            margin-bottom: 24px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.06);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            border: 1px solid #f3e5e5;
        }
        .search-box {
            flex: 1;
            min-width: 260px;
            position: relative;
        }
        .search-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #b0b0b0;
            font-size: 15px;
            pointer-events: none;
        }
        .search-input {
            width: 100%;
            padding: 12px 14px 12px 40px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.25s ease, box-shadow 0.25s ease;
            background: #fff;
        }
        .search-input:focus {
            border-color: #d32f2f;
            box-shadow: 0 0 0 4px rgba(211,47,47,0.08);
        }
        .toolbar-tip {
            color: #666;
            font-size: 13px;
        }
        .layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 330px;
            gap: 24px;
            align-items: start;
        }
        .main-panel {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .category-section {
            background: rgba(255,255,255,0.97);
            border-radius: 14px;
            padding: 22px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.06);
            border: 1px solid #f4eaea;
        }
        .category-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 18px;
            padding-bottom: 14px;
            border-bottom: 1px solid #f1eded;
        }
        .category-title-wrap {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .category-icon {
            width: 46px;
            height: 46px;
            border-radius: 12px;
            background: linear-gradient(135deg, #d32f2f 0%, #b71c1c 100%);
            color: white;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: bold;
            box-shadow: 0 6px 14px rgba(211,47,47,0.22);
        }
        .category-title {
            font-size: 20px;
            font-weight: bold;
            color: #333;
        }
        .category-subtitle {
            font-size: 12px;
            color: #888;
            margin-top: 3px;
        }
        .category-count {
            background: #fff3f3;
            color: #d32f2f;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: bold;
            border: 1px solid #f6d3d3;
        }
        .skill-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 14px;
            align-items: stretch;
        }
        .skill-card {
            border: 2px solid #e5e7eb;
            border-radius: 14px;
            padding: 16px;
            background: linear-gradient(180deg, #ffffff 0%, #fffdfd 100%);
            cursor: pointer;
            transition: all 0.25s ease;
            position: relative;
            min-height: 150px;
            display: flex;
            flex-direction: column;
        }
        .skill-card:hover {
            border-color: #d32f2f;
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(211,47,47,0.12);
        }
        .skill-card.selected {
            border-color: #d32f2f;
            background: linear-gradient(135deg, #fff5f5 0%, #fffafa 100%);
            box-shadow: 0 10px 20px rgba(211,47,47,0.16);
        }
        .skill-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
            gap: 10px;
        }
        .skill-badge {
            min-width: 42px;
            height: 42px;
            border-radius: 12px;
            background: #fff3f3;
            color: #d32f2f;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: bold;
            border: 1px solid #f5caca;
        }
        .skill-check {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #10b981;
            color: white;
            display: none;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: bold;
        }
        .skill-card.selected .skill-check {
            display: inline-flex;
        }
        .skill-name {
            font-size: 15px;
            font-weight: bold;
            color: #222;
            margin-bottom: 8px;
            line-height: 1.5;
        }
        .skill-desc {
            font-size: 12px;
            color: #777;
            line-height: 1.7;
            margin-top: auto;
        }
        .side-panel {
            background: rgba(255,255,255,0.97);
            border-radius: 14px;
            padding: 22px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.06);
            height: fit-content;
            position: sticky;
            top: 20px;
            border: 1px solid #f4eaea;
        }
        .side-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        .side-desc {
            font-size: 13px;
            color: #666;
            line-height: 1.7;
            margin-bottom: 16px;
        }
        .side-summary {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-bottom: 16px;
        }
        .side-metric {
            background: #faf7f7;
            border: 1px solid #f1e4e4;
            border-radius: 10px;
            padding: 12px;
            text-align: center;
        }
        .side-metric-value {
            font-size: 20px;
            font-weight: bold;
            color: #d32f2f;
        }
        .side-metric-label {
            font-size: 12px;
            color: #888;
            margin-top: 4px;
        }
        .selected-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 18px;
            min-height: 40px;
            max-height: 280px;
            overflow-y: auto;
            padding-right: 4px;
        }
        .selected-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 10px;
            border-radius: 999px;
            background: #fff3f3;
            color: #d32f2f;
            font-size: 12px;
            font-weight: bold;
            border: 1px solid #f5caca;
        }
        .empty-tip {
            font-size: 13px;
            color: #999;
        }
        .save-panel {
            padding-top: 14px;
            border-top: 1px solid #f0f0f0;
        }
        .empty-state {
            background: rgba(255,255,255,0.97);
            border-radius: 14px;
            padding: 60px 20px;
            text-align: center;
            color: #999;
            box-shadow: 0 6px 18px rgba(0,0,0,0.06);
            border: 1px solid #f4eaea;
        }
        .empty-state .empty-icon {
            font-size: 52px;
            margin-bottom: 12px;
        }
        @media (max-width: 1024px) {
            .layout {
                grid-template-columns: 1fr;
            }
            .side-panel {
                position: static;
            }
        }
        @media (max-width: 768px) {
            body {
                padding: 14px;
            }
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                padding: 20px;
            }
            .summary-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .skill-grid {
                grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
            }
            .category-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .header-actions {
                width: 100%;
            }
            .header-actions .btn {
                flex: 1;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="page-header">
        <div>
            <h1>技能配置</h1>
            <p>选择您的志愿服务技能，系统会为您匹配更合适的任务。页面已按分类整理，方便快速查看和勾选。</p>
        </div>
        <div class="header-actions">
            <button class="btn btn-success" onclick="saveSkills()">保存技能</button>
            <a href="${pageContext.request.contextPath}/user/volunteer/dashboard" class="btn btn-primary">返回首页</a>
        </div>
    </div>

    <div class="summary-grid">
        <div class="summary-card">
            <div class="summary-value" id="totalSkills">0</div>
            <div class="summary-label">可选技能</div>
        </div>
        <div class="summary-card">
            <div class="summary-value" id="selectedCount">0</div>
            <div class="summary-label">已选技能</div>
        </div>
        <div class="summary-card">
            <div class="summary-value" id="categoryCount">0</div>
            <div class="summary-label">技能分类</div>
        </div>
        <div class="summary-card">
            <div class="summary-value" id="selectedRate">0%</div>
            <div class="summary-label">选择完成度</div>
        </div>
    </div>

    <div class="toolbar">
        <div class="search-box">
            <span class="search-icon">🔍</span>
            <input type="text" id="skillSearch" class="search-input" placeholder="搜索技能名称或描述..." oninput="filterSkills()">
        </div>
        <div class="toolbar-tip">点击卡片即可选择或取消；右侧会同步显示已选技能。</div>
    </div>

    <div class="layout">
        <div class="main-panel">
            <c:if test="${not empty skillsMap['护理类']}">
            <div class="category-section skill-category-box" data-category="护理类">
                <div class="category-header">
                    <div class="category-title-wrap">
                        <span class="category-icon">护</span>
                        <div>
                            <div class="category-title">护理类技能</div>
                            <div class="category-subtitle">适合日常照护、康护支持等服务</div>
                        </div>
                    </div>
                    <span class="category-count">${skillsMap['护理类'].size()}项</span>
                </div>
                <div class="skill-grid">
                    <c:forEach items="${skillsMap['护理类']}" var="skill">
                        <div class="skill-card" data-skill-id="${skill.id}" data-skill-name="${skill.skillName}" data-skill-desc="${skill.description}" onclick="toggleSkill(this)">
                            <div class="skill-top">
                                <span class="skill-badge">护</span>
                                <span class="skill-check">√</span>
                            </div>
                            <div class="skill-name">${skill.skillName}</div>
                            <div class="skill-desc">${skill.description}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            </c:if>

            <c:if test="${not empty skillsMap['心理类']}">
            <div class="category-section skill-category-box" data-category="心理类">
                <div class="category-header">
                    <div class="category-title-wrap">
                        <span class="category-icon">心</span>
                        <div>
                            <div class="category-title">心理类技能</div>
                            <div class="category-subtitle">适合陪伴沟通、心理支持与情绪疏导</div>
                        </div>
                    </div>
                    <span class="category-count">${skillsMap['心理类'].size()}项</span>
                </div>
                <div class="skill-grid">
                    <c:forEach items="${skillsMap['心理类']}" var="skill">
                        <div class="skill-card" data-skill-id="${skill.id}" data-skill-name="${skill.skillName}" data-skill-desc="${skill.description}" onclick="toggleSkill(this)">
                            <div class="skill-top">
                                <span class="skill-badge">心</span>
                                <span class="skill-check">√</span>
                            </div>
                            <div class="skill-name">${skill.skillName}</div>
                            <div class="skill-desc">${skill.description}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            </c:if>

            <c:if test="${not empty skillsMap['医疗类']}">
            <div class="category-section skill-category-box" data-category="医疗类">
                <div class="category-header">
                    <div class="category-title-wrap">
                        <span class="category-icon">医</span>
                        <div>
                            <div class="category-title">医疗类技能</div>
                            <div class="category-subtitle">适合康复指导、健康协助等场景</div>
                        </div>
                    </div>
                    <span class="category-count">${skillsMap['医疗类'].size()}项</span>
                </div>
                <div class="skill-grid">
                    <c:forEach items="${skillsMap['医疗类']}" var="skill">
                        <div class="skill-card" data-skill-id="${skill.id}" data-skill-name="${skill.skillName}" data-skill-desc="${skill.description}" onclick="toggleSkill(this)">
                            <div class="skill-top">
                                <span class="skill-badge">医</span>
                                <span class="skill-check">√</span>
                            </div>
                            <div class="skill-name">${skill.skillName}</div>
                            <div class="skill-desc">${skill.description}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            </c:if>

            <c:if test="${not empty skillsMap['技术类']}">
            <div class="category-section skill-category-box" data-category="技术类">
                <div class="category-header">
                    <div class="category-title-wrap">
                        <span class="category-icon">技</span>
                        <div>
                            <div class="category-title">技术类技能</div>
                            <div class="category-subtitle">适合维修、设备处理等技术服务</div>
                        </div>
                    </div>
                    <span class="category-count">${skillsMap['技术类'].size()}项</span>
                </div>
                <div class="skill-grid">
                    <c:forEach items="${skillsMap['技术类']}" var="skill">
                        <div class="skill-card" data-skill-id="${skill.id}" data-skill-name="${skill.skillName}" data-skill-desc="${skill.description}" onclick="toggleSkill(this)">
                            <div class="skill-top">
                                <span class="skill-badge">技</span>
                                <span class="skill-check">√</span>
                            </div>
                            <div class="skill-name">${skill.skillName}</div>
                            <div class="skill-desc">${skill.description}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            </c:if>

            <c:if test="${not empty skillsMap['生活类']}">
            <div class="category-section skill-category-box" data-category="生活类">
                <div class="category-header">
                    <div class="category-title-wrap">
                        <span class="category-icon">生</span>
                        <div>
                            <div class="category-title">生活类技能</div>
                            <div class="category-subtitle">适合代购、陪同办事、日常协助</div>
                        </div>
                    </div>
                    <span class="category-count">${skillsMap['生活类'].size()}项</span>
                </div>
                <div class="skill-grid">
                    <c:forEach items="${skillsMap['生活类']}" var="skill">
                        <div class="skill-card" data-skill-id="${skill.id}" data-skill-name="${skill.skillName}" data-skill-desc="${skill.description}" onclick="toggleSkill(this)">
                            <div class="skill-top">
                                <span class="skill-badge">生</span>
                                <span class="skill-check">√</span>
                            </div>
                            <div class="skill-name">${skill.skillName}</div>
                            <div class="skill-desc">${skill.description}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            </c:if>

            <c:if test="${empty skillsMap['护理类'] and empty skillsMap['心理类'] and empty skillsMap['医疗类'] and empty skillsMap['技术类'] and empty skillsMap['生活类']}">
            <div class="empty-state">
                <div class="empty-icon">📭</div>
                <div>当前没有可配置的技能数据</div>
            </div>
            </c:if>
        </div>

        <div class="side-panel">
            <div class="side-title">已选技能</div>
            <div class="side-desc">这里会显示您当前勾选的技能标签。保存后系统会根据这些标签为您匹配更合适的志愿服务任务。</div>
            <div class="side-summary">
                <div class="side-metric">
                    <div class="side-metric-value" id="sideSelectedCount">0</div>
                    <div class="side-metric-label">已选数量</div>
                </div>
                <div class="side-metric">
                    <div class="side-metric-value" id="sideCategoryCount">0</div>
                    <div class="side-metric-label">分类数量</div>
                </div>
            </div>
            <div class="selected-list" id="selectedList"></div>
            <div class="save-panel">
                <button class="btn btn-success" style="width: 100%; margin-bottom: 10px;" onclick="saveSkills()">保存当前选择</button>
                <button class="btn btn-primary" style="width: 100%;" onclick="clearSkills()">清空当前选择</button>
            </div>
        </div>
    </div>
</div>

<script>
    let selectedSkills = new Set();
    const mySkillIds = [
        <c:forEach items="${mySkills}" var="mySkill" varStatus="status">
            ${mySkill.skillId}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    window.onload = function() {
        loadMySkills();
        updateStats();
        renderSelectedList();
    };

    function loadMySkills() {
        mySkillIds.forEach(function(skillId) {
            selectedSkills.add(skillId);
            const card = document.querySelector('[data-skill-id="' + skillId + '"]');
            if (card) {
                card.classList.add('selected');
            }
        });
        updateSelectedCount();
    }

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
        renderSelectedList();
    }

    function updateSelectedCount() {
        const count = selectedSkills.size;
        document.getElementById('selectedCount').textContent = count;
        document.getElementById('sideSelectedCount').textContent = count;
        const total = document.querySelectorAll('.skill-card').length;
        const categories = document.querySelectorAll('.skill-category-box').length;
        document.getElementById('sideCategoryCount').textContent = categories;
        const rate = total > 0 ? Math.round((count / total) * 100) : 0;
        document.getElementById('selectedRate').textContent = rate + '%';
    }

    function updateStats() {
        const totalCards = document.querySelectorAll('.skill-card').length;
        document.getElementById('totalSkills').textContent = totalCards;
        const categories = document.querySelectorAll('.skill-category-box').length;
        document.getElementById('categoryCount').textContent = categories;
        document.getElementById('sideCategoryCount').textContent = categories;
    }

    function renderSelectedList() {
        const wrap = document.getElementById('selectedList');
        wrap.innerHTML = '';
        const selectedCards = document.querySelectorAll('.skill-card.selected');
        if (!selectedCards.length) {
            wrap.innerHTML = '<div class="empty-tip">暂未选择任何技能</div>';
            return;
        }
        selectedCards.forEach(function(card) {
            const tag = document.createElement('div');
            tag.className = 'selected-tag';
            tag.textContent = card.getAttribute('data-skill-name');
            wrap.appendChild(tag);
        });
    }

    function filterSkills() {
        const keyword = document.getElementById('skillSearch').value.trim().toLowerCase();
        const cards = document.querySelectorAll('.skill-card');
        const sections = document.querySelectorAll('.skill-category-box');

        cards.forEach(function(card) {
            const name = (card.getAttribute('data-skill-name') || '').toLowerCase();
            const desc = (card.getAttribute('data-skill-desc') || '').toLowerCase();
            const matched = !keyword || name.indexOf(keyword) >= 0 || desc.indexOf(keyword) >= 0;
            card.style.display = matched ? 'flex' : 'none';
        });

        sections.forEach(function(section) {
            const visibleCards = Array.from(section.querySelectorAll('.skill-card')).filter(function(card) {
                return card.style.display !== 'none';
            });
            section.style.display = visibleCards.length > 0 ? 'block' : 'none';
        });
    }

    function clearSkills() {
        if (!confirm('确定清空当前已选择的技能吗？')) {
            return;
        }
        selectedSkills.clear();
        document.querySelectorAll('.skill-card.selected').forEach(function(card) {
            card.classList.remove('selected');
        });
        updateSelectedCount();
        renderSelectedList();
    }

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
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'skillIds=' + skillIds.join(',')
        })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                alert('技能配置保存成功！\n\n已选择 ' + skillIds.length + ' 项技能。');
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
