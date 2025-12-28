<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>页面未找到 - 社区关爱协同平台</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #FAF5F0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-container {
            text-align: center;
            padding: 60px 40px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            border-top: 4px solid #D32F2F;
            max-width: 500px;
        }
        .error-code {
            font-size: 100px;
            font-weight: bold;
            color: #D32F2F;
            line-height: 1;
            margin-bottom: 20px;
        }
        .error-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 15px;
        }
        .error-message {
            font-size: 14px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .back-btn {
            display: inline-block;
            padding: 12px 30px;
            background: #D32F2F;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
            transition: all 0.3s;
        }
        .back-btn:hover {
            background: #B71C1C;
            transform: translateY(-2px);
        }
        .home-link {
            display: block;
            margin-top: 20px;
            color: #D32F2F;
            text-decoration: none;
        }
        .home-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">404</div>
        <h1 class="error-title">页面未找到</h1>
        <p class="error-message">
            您访问的页面不存在或已被移除。<br>
            请检查URL是否正确，或返回首页重新导航。
        </p>
        <a href="javascript:history.back()" class="back-btn">返回上一页</a>
        <a href="${pageContext.request.contextPath}/" class="home-link">返回首页</a>
    </div>
</body>
</html>
