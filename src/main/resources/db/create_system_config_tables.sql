-- =====================================================
-- 系统配置管理数据库表
-- =====================================================

USE community_help;

-- 1. 系统配置表
DROP TABLE IF EXISTS system_config;
CREATE TABLE system_config (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '配置ID',
    config_key VARCHAR(100) UNIQUE NOT NULL COMMENT '配置键',
    config_value TEXT COMMENT '配置值',
    config_type VARCHAR(50) NOT NULL COMMENT '配置类型：STRING, NUMBER, BOOLEAN, JSON',
    category VARCHAR(50) NOT NULL COMMENT '配置分类：SYSTEM, POINTS, TASK, NOTIFICATION',
    display_name VARCHAR(200) NOT NULL COMMENT '显示名称',
    description VARCHAR(500) COMMENT '配置描述',
    is_public TINYINT DEFAULT 0 COMMENT '是否公开：1公开 0私有（仅管理员可见）',
    sort_order INT DEFAULT 0 COMMENT '排序顺序',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    updated_by VARCHAR(100) COMMENT '更新人',
    INDEX idx_category (category),
    INDEX idx_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

-- 2. 系统日志表
DROP TABLE IF EXISTS system_log;
CREATE TABLE system_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID',
    log_type VARCHAR(50) NOT NULL COMMENT '日志类型：CONFIG_CHANGE, LOGIN, OPERATION',
    operation VARCHAR(100) NOT NULL COMMENT '操作类型',
    operator_id BIGINT COMMENT '操作人ID',
    operator_name VARCHAR(100) COMMENT '操作人姓名',
    content TEXT COMMENT '日志内容',
    ip_address VARCHAR(50) COMMENT 'IP地址',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_log_type (log_type),
    INDEX idx_operator_id (operator_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统日志表';

-- =====================================================
-- 初始化系统配置数据
-- =====================================================

-- 系统基础配置
INSERT INTO system_config (config_key, config_value, config_type, category, display_name, description, is_public, sort_order) VALUES
('system.name', '社区志愿服务平台', 'STRING', 'SYSTEM', '系统名称', '系统的显示名称', 1, 1),
('system.version', '1.0.0', 'STRING', 'SYSTEM', '系统版本', '当前系统版本号', 1, 2),
('system.admin_email', 'admin@community.com', 'STRING', 'SYSTEM', '管理员邮箱', '系统管理员邮箱地址', 0, 3),
('system.max_upload_size', '10', 'NUMBER', 'SYSTEM', '最大上传大小', '文件上传最大大小（MB）', 0, 4),
('system.session_timeout', '30', 'NUMBER', 'SYSTEM', '会话超时时间', '用户会话超时时间（分钟）', 0, 5);

-- 积分系统配置
INSERT INTO system_config (config_key, config_value, config_type, category, display_name, description, is_public, sort_order) VALUES
('points.task_complete', '10', 'NUMBER', 'POINTS', '完成任务积分', '志愿者完成任务获得的积分', 1, 10),
('points.task_approve', '5', 'NUMBER', 'POINTS', '审核通过积分', '任务审核通过额外积分', 1, 11),
('points.high_rating', '15', 'NUMBER', 'POINTS', '高分评价积分', '获得5分评价的额外积分', 1, 12),
('points.first_task', '50', 'NUMBER', 'POINTS', '首次任务奖励', '完成第一个任务的奖励积分', 1, 13),
('points.daily_login', '2', 'NUMBER', 'POINTS', '每日登录积分', '每日首次登录获得的积分', 1, 14),
('points.enabled', 'true', 'BOOLEAN', 'POINTS', '积分系统启用', '是否启用积分奖励系统', 0, 15);

-- 任务系统配置
INSERT INTO system_config (config_key, config_value, config_type, category, display_name, description, is_public, sort_order) VALUES
('task.auto_approve', 'false', 'BOOLEAN', 'TASK', '自动审核', '是否自动审核任务', 0, 20),
('task.max_claim', '5', 'NUMBER', 'TASK', '最大认领数', '志愿者同时可认领的最大任务数', 1, 21),
('task.expire_days', '7', 'NUMBER', 'TASK', '任务过期天数', '任务未完成自动过期天数', 1, 22),
('task.reminder_hours', '24', 'NUMBER', 'TASK', '提醒提前时间', '任务开始前提醒时间（小时）', 0, 23);

-- 通知系统配置
INSERT INTO system_config (config_key, config_value, config_type, category, display_name, description, is_public, sort_order) VALUES
('notification.enabled', 'true', 'BOOLEAN', 'NOTIFICATION', '通知功能启用', '是否启用站内通知功能', 0, 30),
('notification.email_enabled', 'false', 'BOOLEAN', 'NOTIFICATION', '邮件通知启用', '是否启用邮件通知', 0, 31),
('notification.sms_enabled', 'false', 'BOOLEAN', 'NOTIFICATION', '短信通知启用', '是否启用短信通知', 0, 32);

-- 勋章系统配置
INSERT INTO system_config (config_key, config_value, config_type, category, display_name, description, is_public, sort_order) VALUES
('badge.enabled', 'true', 'BOOLEAN', 'BADGE', '勋章系统启用', '是否启用勋章系统', 0, 40),
('badge.auto_unlock', 'true', 'BOOLEAN', 'BADGE', '自动解锁勋章', '达成条件后是否自动解锁勋章', 0, 41);

-- 安全配置
INSERT INTO system_config (config_key, config_value, config_type, category, display_name, description, is_public, sort_order) VALUES
('security.password_min_length', '6', 'NUMBER', 'SECURITY', '密码最小长度', '用户密码最小长度要求', 0, 50),
('security.login_max_retry', '5', 'NUMBER', 'SECURITY', '登录最大重试次数', '登录失败最大重试次数', 0, 51),
('security.lock_duration', '30', 'NUMBER', 'SECURITY', '账号锁定时长', '登录失败后账号锁定时长（分钟）', 0, 52);

-- =====================================================
-- 完成！
-- =====================================================
