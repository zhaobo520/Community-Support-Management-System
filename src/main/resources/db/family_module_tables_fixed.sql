-- ===================================================================
-- 家属模块数据库表创建脚本（修正版）
-- 创建时间: 2025-11-19
-- 说明: 包含服务记录、关爱计划、反馈三个核心表及测试数据
-- ===================================================================

-- 选择数据库
USE community_help;

-- 1. 服务记录表
CREATE TABLE IF NOT EXISTS service_record (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  task_id BIGINT NOT NULL COMMENT '任务ID',
  volunteer_id BIGINT NOT NULL COMMENT '志愿者ID',
  elderly_id BIGINT COMMENT '关爱对象ID',
  family_user_id BIGINT NOT NULL COMMENT '家属用户ID',
  service_date DATETIME NOT NULL COMMENT '服务日期',
  service_content TEXT COMMENT '服务内容',
  service_duration INT DEFAULT 0 COMMENT '服务时长(分钟)',
  service_photos VARCHAR(500) COMMENT '服务照片(逗号分隔)',
  service_notes TEXT COMMENT '服务备注',
  family_feedback TEXT COMMENT '家属反馈',
  rating INT COMMENT '评分1-5',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX idx_task (task_id),
  INDEX idx_volunteer (volunteer_id),
  INDEX idx_family (family_user_id),
  INDEX idx_date (service_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='服务记录表';

-- 2. 关爱计划表
CREATE TABLE IF NOT EXISTS care_plan (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  family_user_id BIGINT NOT NULL COMMENT '家属用户ID',
  elderly_id BIGINT COMMENT '关爱对象ID',
  plan_name VARCHAR(200) NOT NULL COMMENT '计划名称',
  description TEXT COMMENT '计划描述',
  service_type VARCHAR(100) COMMENT '服务类型',
  service_frequency VARCHAR(100) COMMENT '服务频率(如:每周3次)',
  start_date DATE COMMENT '开始日期',
  end_date DATE COMMENT '结束日期',
  status VARCHAR(20) DEFAULT 'ACTIVE' COMMENT '状态: ACTIVE-进行中, COMPLETED-已完成, CANCELLED-已取消',
  assigned_volunteer_id BIGINT COMMENT '负责志愿者ID',
  total_services INT DEFAULT 0 COMMENT '总服务次数',
  completed_services INT DEFAULT 0 COMMENT '已完成次数',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  created_by BIGINT COMMENT '创建人ID',
  INDEX idx_family_user (family_user_id),
  INDEX idx_volunteer (assigned_volunteer_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='关爱计划表';

-- 3. 反馈表
CREATE TABLE IF NOT EXISTS feedback (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  family_user_id BIGINT NOT NULL COMMENT '家属用户ID',
  task_id BIGINT COMMENT '关联任务ID',
  volunteer_id BIGINT COMMENT '关联志愿者ID',
  feedback_type VARCHAR(20) NOT NULL COMMENT '反馈类型: RATING-评价, SUGGESTION-建议, COMPLAINT-投诉',
  title VARCHAR(200) COMMENT '标题',
  content TEXT NOT NULL COMMENT '反馈内容',
  rating INT COMMENT '评分1-5',
  status VARCHAR(20) DEFAULT 'PENDING' COMMENT '状态: PENDING-待处理, PROCESSING-处理中, RESOLVED-已解决',
  response TEXT COMMENT '管理员回复',
  responded_by BIGINT COMMENT '回复人ID',
  responded_at DATETIME COMMENT '回复时间',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX idx_family (family_user_id),
  INDEX idx_type (feedback_type),
  INDEX idx_status (status),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='反馈表';

-- ===================================================================
-- 插入测试数据
-- ===================================================================

-- 服务记录测试数据
INSERT INTO service_record (task_id, volunteer_id, family_user_id, service_date, service_content, service_duration, rating) 
VALUES (1, 2, 3, '2025-11-15 14:00:00', '协助关爱对象进行日常生活照料，包括做饭、打扫卫生', 120, 5);

INSERT INTO service_record (task_id, volunteer_id, family_user_id, service_date, service_content, service_duration, rating) 
VALUES (2, 2, 3, '2025-11-13 10:00:00', '陪同关爱对象进行心理辅导，倾听关爱对象心声', 90, 5);

INSERT INTO service_record (task_id, volunteer_id, family_user_id, service_date, service_content, service_duration, rating) 
VALUES (3, 2, 3, '2025-11-10 09:00:00', '陪同关爱对象前往医院体检', 180, 4);

-- 关爱计划测试数据
INSERT INTO care_plan (family_user_id, plan_name, description, service_type, service_frequency, start_date, end_date, status, assigned_volunteer_id, total_services, completed_services) 
VALUES (3, '11月护理计划', '为关爱对象提供日常生活照料和健康护理服务', '生活照料,健康护理', '每周3次', '2025-11-01', '2025-11-30', 'ACTIVE', 2, 12, 3);

-- 反馈测试数据
INSERT INTO feedback (family_user_id, task_id, volunteer_id, feedback_type, title, content, rating, status) 
VALUES (3, 1, 2, 'RATING', '服务非常满意', '志愿者李明服务态度很好，非常耐心细心', 5, 'RESOLVED');

-- ===================================================================
-- 验证脚本（可选执行）
-- ===================================================================

-- 检查表是否创建成功
-- SHOW TABLES LIKE 'service_record';
-- SHOW TABLES LIKE 'care_plan';
-- SHOW TABLES LIKE 'feedback';

-- 查看测试数据
-- SELECT * FROM service_record;
-- SELECT * FROM care_plan;
-- SELECT * FROM feedback;

-- 查看数据统计
-- SELECT COUNT(*) as service_record_count FROM service_record;
-- SELECT COUNT(*) as care_plan_count FROM care_plan;
-- SELECT COUNT(*) as feedback_count FROM feedback;
