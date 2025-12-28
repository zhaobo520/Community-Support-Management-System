-- =====================================================
-- 积分奖励系统数据库表
-- =====================================================

USE community_help;

-- =====================================================
-- 删除已存在的表（注意顺序：先删除有外键的子表，再删除父表）
-- =====================================================
DROP TABLE IF EXISTS volunteer_badge;  -- 先删除子表
DROP TABLE IF EXISTS badge;            -- 再删除父表
DROP TABLE IF EXISTS points_record;    -- 删除积分记录表
DROP TABLE IF EXISTS points_rule;      -- 删除积分规则表

-- =====================================================
-- 创建新表
-- =====================================================

-- 1. 积分记录表
CREATE TABLE points_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '积分记录ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    points INT NOT NULL COMMENT '积分数（正数为增加，负数为扣减）',
    total_points INT NOT NULL DEFAULT 0 COMMENT '操作后总积分',
    source_type VARCHAR(50) NOT NULL COMMENT '积分来源类型：TASK_COMPLETE, TASK_APPROVE, DAILY_LOGIN, MANUAL_ADJUST',
    source_id BIGINT COMMENT '来源ID（如任务ID）',
    reason VARCHAR(500) COMMENT '积分原因说明',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_user_id (user_id),
    INDEX idx_source_type (source_type),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (user_id) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='积分记录表';

-- 2. 积分规则配置表
CREATE TABLE points_rule (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '规则ID',
    rule_code VARCHAR(50) UNIQUE NOT NULL COMMENT '规则代码：TASK_COMPLETE, TASK_APPROVE等',
    rule_name VARCHAR(100) NOT NULL COMMENT '规则名称',
    points INT NOT NULL COMMENT '积分数',
    description VARCHAR(500) COMMENT '规则描述',
    enabled TINYINT DEFAULT 1 COMMENT '是否启用：1启用 0禁用',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='积分规则配置表';

-- 3. 勋章表（父表，先创建）
CREATE TABLE badge (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '勋章ID',
    badge_code VARCHAR(50) UNIQUE NOT NULL COMMENT '勋章代码',
    badge_name VARCHAR(100) NOT NULL COMMENT '勋章名称',
    badge_icon VARCHAR(200) COMMENT '勋章图标URL或emoji',
    description VARCHAR(500) COMMENT '勋章描述',
    unlock_condition VARCHAR(200) COMMENT '解锁条件（如：完成10个任务）',
    condition_type VARCHAR(50) COMMENT '条件类型：TASK_COUNT, POINTS_TOTAL, CONTINUOUS_DAYS',
    condition_value INT COMMENT '条件值',
    level INT DEFAULT 1 COMMENT '勋章等级：1普通 2优秀 3卓越',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='勋章表';

-- 4. 志愿者勋章关联表（子表，后创建）
CREATE TABLE volunteer_badge (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    badge_id BIGINT NOT NULL COMMENT '勋章ID',
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '获得时间',
    INDEX idx_user_id (user_id),
    FOREIGN KEY (user_id) REFERENCES sys_user(id),
    FOREIGN KEY (badge_id) REFERENCES badge(id),
    UNIQUE KEY uk_user_badge (user_id, badge_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='志愿者勋章关联表';

-- =====================================================
-- 初始化积分规则数据
-- =====================================================

INSERT INTO points_rule (rule_code, rule_name, points, description, enabled) VALUES
('TASK_COMPLETE', '完成任务', 10, '志愿者完成一个任务获得10积分', 1),
('TASK_APPROVE', '任务审核通过', 5, '任务审核通过后额外获得5积分', 1),
('TASK_HIGH_RATING', '高分评价', 15, '任务获得5分评价额外奖励15积分', 1),
('DAILY_LOGIN', '每日登录', 2, '每日首次登录获得2积分', 1),
('CONTINUOUS_7DAYS', '连续7天', 20, '连续7天登录奖励20积分', 1),
('FIRST_TASK', '首次任务', 50, '完成第一个任务奖励50积分', 1),
('MONTHLY_STAR', '月度之星', 100, '月度任务完成数第一名奖励100积分', 1),
('MANUAL_ADD', '手动添加', 0, '管理员手动添加积分（数量可变）', 1),
('MANUAL_DEDUCT', '手动扣减', 0, '管理员手动扣减积分（数量可变）', 1);

-- =====================================================
-- 初始化勋章数据
-- =====================================================

INSERT INTO badge (badge_code, badge_name, badge_icon, description, unlock_condition, condition_type, condition_value, level) VALUES
('NEWBIE', '新手上路', '🔰', '完成第一个任务', '完成1个任务', 'TASK_COUNT', 1, 1),
('ACTIVE_10', '积极分子', '⭐', '完成10个任务', '完成10个任务', 'TASK_COUNT', 10, 1),
('EXPERT_50', '服务专家', '🏅', '完成50个任务', '完成50个任务', 'TASK_COUNT', 50, 2),
('MASTER_100', '服务大师', '👑', '完成100个任务', '完成100个任务', 'TASK_COUNT', 100, 3),
('POINTS_100', '百分达人', '💯', '累计获得100积分', '累计100积分', 'POINTS_TOTAL', 100, 1),
('POINTS_500', '积分富豪', '💰', '累计获得500积分', '累计500积分', 'POINTS_TOTAL', 500, 2),
('POINTS_1000', '积分大亨', '💎', '累计获得1000积分', '累计1000积分', 'POINTS_TOTAL', 1000, 3),
('CONTINUOUS_7', '坚持不懈', '🔥', '连续7天登录', '连续7天登录', 'CONTINUOUS_DAYS', 7, 1),
('CONTINUOUS_30', '持之以恒', '🌟', '连续30天登录', '连续30天登录', 'CONTINUOUS_DAYS', 30, 2),
('HIGH_RATING', '五星好评', '⭐⭐⭐⭐⭐', '获得10次5分好评', '获得10次5分评价', 'HIGH_RATING_COUNT', 10, 2);

-- =====================================================
-- 为志愿者表添加积分字段（如果还没有的话）
-- =====================================================

-- 添加total_points字段（如果已存在会报错，但不影响）
-- 方法：先尝试添加，如果失败则忽略
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = 'community_help' 
     AND TABLE_NAME = 'volunteer_profile' 
     AND COLUMN_NAME = 'total_points') = 0,
    'ALTER TABLE volunteer_profile ADD COLUMN total_points INT DEFAULT 0 COMMENT ''累计总积分''',
    'SELECT ''Column total_points already exists'' AS Info'
));

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加索引（如果已存在会报错，但不影响）
SET @sql2 = (SELECT IF(
    (SELECT COUNT(*) FROM information_schema.STATISTICS
     WHERE TABLE_SCHEMA = 'community_help' 
     AND TABLE_NAME = 'volunteer_profile' 
     AND INDEX_NAME = 'idx_total_points') = 0,
    'ALTER TABLE volunteer_profile ADD INDEX idx_total_points (total_points)',
    'SELECT ''Index idx_total_points already exists'' AS Info'
));

PREPARE stmt2 FROM @sql2;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

-- =====================================================
-- 完成！
-- =====================================================
