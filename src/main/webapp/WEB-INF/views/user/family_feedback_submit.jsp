<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>💬 提交反馈</title>
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
            max-width: 800px;
            margin: 0 auto;
        }

        .header {
            background: white;
            border-radius: 4px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 32px;
            background: linear-gradient(135deg, #B71C1C, #D32F2F); -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .header-subtitle {
            color: #666;
            font-size: 14px;
            margin-top: 8px;
        }

        .btn-back { padding: 10px 20px; background: linear-gradient(135deg, #B71C1C, #D32F2F);
            color: white;
            border: none;
            border-radius: 2px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .form-card {
            background: white;
            border-radius: 4px;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }

        .form-label span {
            color: #f97316;
        }

        .form-input,
        .form-select,
        .form-textarea {
            width: 100%;
            padding: 12px 16px;
            font-size: 14px;
            border: 2px solid #e5e7eb;
            border-radius: 2px;
            transition: all 0.3s;
            font-family: inherit;
        }

        .form-input:focus,
        .form-select:focus,
        .form-textarea:focus {
            outline: none;
            border-color: #D32F2F;
            box-shadow: 0 0 0 3px rgba(255, 167, 81, 0.1);
        }

        .form-textarea {
            min-height: 150px;
            resize: vertical;
        }

        .form-hint {
            font-size: 12px;
            color: #999;
            margin-top: 6px;
        }

        .rating-selector {
            display: flex;
            gap: 10px;
        }

        .rating-option {
            display: none;
        }

        .rating-label {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 10px 20px;
            border: 2px solid #e5e7eb;
            border-radius: 2px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 20px;
        }

        .rating-option:checked + .rating-label {
            border-color: #D32F2F;
            background: rgba(255, 167, 81, 0.1);
        }

        .type-selector {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }

        .type-option {
            display: none;
        }

        .type-label {
            padding: 15px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .type-label-icon {
            font-size: 32px;
            margin-bottom: 8px;
        }

        .type-label-text {
            font-size: 14px;
            font-weight: bold;
            color: #333;
        }

        .type-option:checked + .type-label {
            border-color: #D32F2F;
            background: linear-gradient(135deg, rgba(255, 167, 81, 0.1) 0%, rgba(255, 226, 89, 0.1) 100%);
        }

        .btn-submit { width: 100%; padding: 15px; background: linear-gradient(135deg, #B71C1C, #D32F2F);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            transition: all 0.3s;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        @media (max-width: 768px) {
            .type-selector {
                grid-template-columns: 1fr;
            }

            .rating-selector {
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1>提交反馈</h1>
            <p class="header-subtitle">您的意见对我们很重要</p>
        </div>
        <a href="${pageContext.request.contextPath}/user/family/feedback/list" class="btn-back">← 返回列表</a>
    </div>

    <!-- Form Card -->
    <div class="form-card">
        <form action="${pageContext.request.contextPath}/user/family/feedback/submit" method="post">
            <!-- Feedback Type -->
            <div class="form-group">
                <label class="form-label">反馈类型 <span>*</span></label>
                <div class="type-selector">
                    <input type="radio" name="feedbackType" value="RATING" id="type-rating" class="type-option" checked required>
                    <label for="type-rating" class="type-label">
                        <div class="type-label-icon"></div>
                        <div class="type-label-text">服务评价</div>
                    </label>

                    <input type="radio" name="feedbackType" value="SUGGESTION" id="type-suggestion" class="type-option" required>
                    <label for="type-suggestion" class="type-label">
                        <div class="type-label-icon"></div>
                        <div class="type-label-text">建议</div>
                    </label>

                    <input type="radio" name="feedbackType" value="COMPLAINT" id="type-complaint" class="type-option" required>
                    <label for="type-complaint" class="type-label">
                        <div class="type-label-icon">高</div>
                        <div class="type-label-text">投诉</div>
                    </label>
                </div>
            </div>

            <!-- Title -->
            <div class="form-group">
                <label class="form-label" for="title">标题 <span>*</span></label>
                <input type="text" name="title" id="title" class="form-input" placeholder="请输入反馈标题" required maxlength="200">
                <p class="form-hint">简要概括您的反馈内容</p>
            </div>

            <!-- Content -->
            <div class="form-group">
                <label class="form-label" for="content">详细内容 <span>*</span></label>
                <textarea name="content" id="content" class="form-textarea" placeholder="请详细描述您的反馈..." required></textarea>
                <p class="form-hint">请详细描述您的问题或建议</p>
            </div>

            <!-- Rating (Optional) -->
            <div class="form-group">
                <label class="form-label">满意度评分（可选）</label>
                <div class="rating-selector">
                    <input type="radio" name="rating" value="5" id="rating-5" class="rating-option">
                    <label for="rating-5" class="rating-label"></label>

                    <input type="radio" name="rating" value="4" id="rating-4" class="rating-option">
                    <label for="rating-4" class="rating-label"></label>

                    <input type="radio" name="rating" value="3" id="rating-3" class="rating-option">
                    <label for="rating-3" class="rating-label"></label>

                    <input type="radio" name="rating" value="2" id="rating-2" class="rating-option">
                    <label for="rating-2" class="rating-label"></label>

                    <input type="radio" name="rating" value="1" id="rating-1" class="rating-option">
                    <label for="rating-1" class="rating-label"></label>
                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn-submit">提交反馈</button>
        </form>
    </div>
</div>
</body>
</html>
