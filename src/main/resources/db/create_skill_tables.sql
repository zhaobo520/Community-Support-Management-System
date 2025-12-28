-- =====================================================
-- 志愿者技能配置数据库表
-- =====================================================

USE community_help;

-- 1. 技能标签表
DROP TABLE IF EXISTS skill;
CREATE TABLE skill (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '技能ID',
    skill_name VARCHAR(100) NOT NULL COMMENT '技能名称',
    skill_code VARCHAR(100) UNIQUE NOT NULL COMMENT '技能代码',
    category VARCHAR(50) NOT NULL COMMENT '技能分类：CARE护理, LIFE生活, HEALTH健康, COMPANION陪伴, REPAIR维修, OTHER其他',
    description VARCHAR(500) COMMENT '技能描述',
    icon VARCHAR(50) COMMENT '图标',
    sort_order INT DEFAULT 0 COMMENT '排序',
    is_active TINYINT DEFAULT 1 COMMENT '是否启用：1启用 0禁用',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_category (category),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='技能标签表';

-- 2. 志愿者技能关联表
DROP TABLE IF EXISTS volunteer_skill;
CREATE TABLE volunteer_skill (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '关联ID',
    user_id BIGINT NOT NULL COMMENT '志愿者ID',
    skill_id BIGINT NOT NULL COMMENT '技能ID',
    proficiency_level VARCHAR(20) DEFAULT 'BEGINNER' COMMENT '熟练度：BEGINNER初级, INTERMEDIATE中级, ADVANCED高级, EXPERT专家',
    years_experience INT DEFAULT 0 COMMENT '经验年数',
    certification VARCHAR(200) COMMENT '相关证书',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_user_skill (user_id, skill_id),
    INDEX idx_user_id (user_id),
    INDEX idx_skill_id (skill_id),
    FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skill(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='志愿者技能关联表';

-- 3. 任务技能关联表
DROP TABLE IF EXISTS task_skill;
CREATE TABLE task_skill (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '关联ID',
    task_id BIGINT NOT NULL COMMENT '任务ID',
    skill_id BIGINT NOT NULL COMMENT '技能ID',
    required_level VARCHAR(20) DEFAULT 'BEGINNER' COMMENT '要求熟练度',
    is_required TINYINT DEFAULT 1 COMMENT '是否必需：1必需 0优先',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_task_skill (task_id, skill_id),
    INDEX idx_task_id (task_id),
    INDEX idx_skill_id (skill_id),
    FOREIGN KEY (task_id) REFERENCES task(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skill(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='任务技能关联表';

-- =====================================================
-- 初始化技能标签数据
-- =====================================================

-- 护理类技能
INSERT INTO skill (skill_name, skill_code, category, description, icon, sort_order) VALUES
('基础护理', 'basic_care', 'CARE', '基础的关爱对象护理技能，包括日常照料', '🏥', 1),
('康复护理', 'rehabilitation_care', 'CARE', '协助关爱对象进行康复训练', '🏥', 2),
('用药指导', 'medication_guide', 'CARE', '帮助关爱对象按时服药和用药指导', '💊', 3),
('伤口护理', 'wound_care', 'CARE', '简单的伤口清洁和换药', '🩹', 4),
('慢病管理', 'chronic_disease_management', 'CARE', '协助关爱对象管理慢性疾病', '📋', 5);

-- 生活类技能
INSERT INTO skill (skill_name, skill_code, category, description, icon, sort_order) VALUES
('做饭烹饪', 'cooking', 'LIFE', '为关爱对象准备营养餐食', '🍳', 11),
('打扫卫生', 'cleaning', 'LIFE', '协助关爱对象打扫房间卫生', '🧹', 12),
('洗衣整理', 'laundry', 'LIFE', '帮助关爱对象洗衣和整理衣物', '👔', 13),
('买菜购物', 'shopping', 'LIFE', '协助关爱对象采购日常用品', '🛒', 14),
('理发美容', 'hairdressing', 'LIFE', '为关爱对象提供理发等服务', '💇', 15);

-- 健康类技能
INSERT INTO skill (skill_name, skill_code, category, description, icon, sort_order) VALUES
('血压测量', 'blood_pressure', 'HEALTH', '测量和记录血压数据', '🩺', 21),
('血糖监测', 'blood_sugar', 'HEALTH', '协助关爱对象监测血糖', '💉', 22),
('健康咨询', 'health_consultation', 'HEALTH', '提供健康相关咨询', '👨‍⚕️', 23),
('按摩理疗', 'massage', 'HEALTH', '提供简单的按摩理疗服务', '💆', 24),
('中医养生', 'traditional_medicine', 'HEALTH', '中医养生知识和指导', '🍵', 25);

-- 陪伴类技能
INSERT INTO skill (skill_name, skill_code, category, description, icon, sort_order) VALUES
('聊天陪伴', 'companionship', 'COMPANION', '陪关爱对象聊天解闷', '💬', 31),
('读书读报', 'reading', 'COMPANION', '为关爱对象朗读书籍报纸', '📰', 32),
('下棋游戏', 'games', 'COMPANION', '陪关爱对象下棋玩游戏', '♟️', 33),
('散步遛弯', 'walking', 'COMPANION', '陪关爱对象户外散步', '🚶', 34),
('文艺表演', 'performance', 'COMPANION', '为关爱对象表演节目', '🎭', 35);

-- 维修类技能
INSERT INTO skill (skill_name, skill_code, category, description, icon, sort_order) VALUES
('电器维修', 'appliance_repair', 'REPAIR', '简单的家电维修', '🔌', 41),
('水电维修', 'plumbing', 'REPAIR', '基础的水电维修', '🔧', 42),
('家具维修', 'furniture_repair', 'REPAIR', '家具的简单维修', '🪑', 43),
('门窗维修', 'door_window_repair', 'REPAIR', '门窗的检查和维修', '🚪', 44);

-- 其他类技能
INSERT INTO skill (skill_name, skill_code, category, description, icon, sort_order) VALUES
('电脑教学', 'computer_teaching', 'OTHER', '教关爱对象使用电脑', '💻', 51),
('手机教学', 'phone_teaching', 'OTHER', '教关爱对象使用智能手机', '📱', 52),
('法律咨询', 'legal_consultation', 'OTHER', '提供法律相关咨询', '⚖️', 53),
('心理疏导', 'psychological_counseling', 'OTHER', '心理健康疏导', '💝', 54),
('应急救护', 'first_aid', 'OTHER', '基础的应急救护技能', '🚑', 55);

-- =====================================================
-- 完成！共30个技能标签
-- =====================================================
