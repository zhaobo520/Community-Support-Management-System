# SSM1 社区互助平台 - 部署包

## 目录结构
- /db : 存放所有 SQL 初始化脚本
- /community_help.war : 编译后的项目 WAR 包 (需在源环境执行 mvn clean package 生成)

## 快速部署指南

1. **数据库准备**
   - 登录 MySQL，执行: `CREATE DATABASE community_help CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
   - 导入 /db/ 目录下的所有 SQL 文件 (建议优先导入 community_help.sql)。

2. **环境变量**
   - JDK 17
   - Tomcat 9.0.98

3. **配置检查**
   - 修改 /src/main/resources/applicationContext.xml 中的数据库连接信息 (用户名/密码)。

4. **部署**
   - 将 community_help.war 放入 Tomcat 的 webapps 目录。
   - 启动 Tomcat，访问 http://localhost:8080/community_help/ 。

## 注意事项
- 本项目已统一编码为 UTF-8。
- 文件上传目前存入数据库 (sys_file 表)，无需额外的本地磁盘权限配置。
