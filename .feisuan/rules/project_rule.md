
# 开发规范指南

为保证代码质量、可维护性、安全性与可扩展性，请在开发过程中严格遵循以下规范。

## 一、项目环境与技术栈要求

- **操作系统**：Windows 11
- **工作目录**：`C:\idea\SSM1`
- **语言版本**：Java 1.8
- **构建工具**：Maven
- **代码作者**：32546

### 技术栈详情

- **框架**：
  - Spring Framework 5.3.34
  - MyBatis 3.5.15
- **数据库驱动**：MySQL 8.0.33
- **数据源**：Druid 1.2.20
- **日志框架**：SLF4J + Logback 1.2.13
- **JSON处理**：Jackson 2.17.1
- **单元测试**：JUnit 4.13.2 + Mockito 5.11.0

## 二、目录结构说明

```bash
SSM1
└── src
    └── main
        ├── java
        │   └── com
        │       └── community
        │           ├── dao              # 数据访问层
        │           ├── domain           # 实体类（DO）
        │           ├── dto              # 数据传输对象（DTO）
        │           ├── service
        │           │   └── impl         # 服务接口实现
        │           ├── util             # 工具类
        │           └── web
        │               ├── controller   # 控制器
        │               ├── converter    # 类型转换器
        │               └── interceptor  # 拦截器
        ├── resources
        │   ├── db                       # 数据库脚本
        │   └── mapper                   # MyBatis 映射文件
        │       ├── badge
        │       ├── config
        │       ├── demand
        │       ├── elderly
        │       ├── notification
        │       ├── points
        │       ├── skill
        │       ├── task
        │       ├── user
        │       └── volunteer
        └── webapp
            ├── static
            │   └── js
            └── WEB-INF
                └── views
                    ├── admin
                    ├── demand
                    ├── elderly
                    ├── error
                    ├── notification
                    ├── points
                    ├── skill
                    ├── statistics
                    ├── task
                    ├── user
                    └── volunteer
```

## 三、分层架构规范

| 层级        | 职责说明                         | 开发约束与注意事项                                               |
|-------------|----------------------------------|----------------------------------------------------------------|
| **Controller** | 处理 HTTP 请求与响应，定义 API 接口 | 不得直接访问数据库，必须通过 Service 层调用                  |
| **Service**    | 实现业务逻辑、事务管理与数据校验   | 必须通过 DAO 层访问数据库；返回 DTO 而非 Entity（除非必要） |
| **DAO**        | 数据库访问与持久化操作             | 使用 MyBatis 进行数据库操作；避免硬编码 SQL                   |
| **Domain**     | 映射数据库表结构                   | 不得直接返回给前端（需转换为 DTO）；包名统一为 `domain`       |
| **DTO**        | 数据传输对象                       | 用于前后端交互的数据封装                                     |

### 接口与实现分离

- 所有接口实现类需放在接口所在包下的 `impl` 子包中。

## 四、安全与性能规范

### 输入校验

- 使用 `@Valid` 与 JSR-303 校验注解（如 `@NotBlank`, `@Size` 等）
  - 注意：Spring 5.x 中校验注解位于 `javax.validation.constraints.*`

- 禁止手动拼接 SQL 字符串，防止 SQL 注入攻击。

### 事务管理

- `@Transactional` 注解仅用于 **Service 层**方法。
- 避免在循环中频繁提交事务，影响性能。

## 五、代码风格规范

### 命名规范

| 类型       | 命名方式             | 示例                  |
|------------|----------------------|-----------------------|
| 类名       | UpperCamelCase       | `UserServiceImpl`     |
| 方法/变量  | lowerCamelCase       | `saveUser()`          |
| 常量       | UPPER_SNAKE_CASE     | `MAX_LOGIN_ATTEMPTS`  |

### 注释规范

- 所有类、方法、字段需添加 **Javadoc** 注释。
- 注释语言使用中文（第一语言）

### 类型命名规范（阿里巴巴风格）

| 后缀 | 用途说明                     | 示例         |
|------|------------------------------|--------------|
| DTO  | 数据传输对象                 | `UserDTO`    |
| DO   | 数据库实体对象               | `UserDO`     |
| BO   | 业务逻辑封装对象             | `UserBO`     |
| VO   | 视图展示对象                 | `UserVO`     |
| Query| 查询参数封装对象             | `UserQuery`  |

## 六、扩展性与日志规范

### 接口优先原则

- 所有业务逻辑通过接口定义（如 `UserService`），具体实现放在 `impl` 包中（如 `UserServiceImpl`）。

### 日志记录

- 使用 `@Slf4j` 注解代替 `System.out.println`

## 七、编码原则总结

| 原则       | 说明                                       |
|------------|--------------------------------------------|
| **SOLID**  | 高内聚、低耦合，增强可维护性与可扩展性     |
| **DRY**    | 避免重复代码，提高复用性                   |
| **KISS**   | 保持代码简洁易懂                           |
| **YAGNI**  | 不实现当前不需要的功能                     |
| **OWASP**  | 防范常见安全漏洞，如 SQL 注入、XSS 等      |
