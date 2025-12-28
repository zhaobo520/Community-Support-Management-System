-- ===================================================================
-- 家属模块数据库表创建脚本（分步执行版）
-- 创建时间: 2025-11-19
-- 说明: 建议逐步复制执行，确保每步成功
-- ===================================================================

-- ====================== 步骤0：选择数据库 ======================
USE community_help;

-- ====================== 步骤1：创建服务记录表 ======================
CREATE TABLE IF NOT EXISTS service_record (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  task_id BIGINT NOT NULL,
  volunteer_id BIGINT NOT NULL,
  elderly_id BIGINT,
  family_user_id BIGINT NOT NULL,
  service_date DATETIME NOT NULL,
  service_content TEXT,
  service_duration INT DEFAULT 0,
  service_photos VARCHAR(500),
  service_notes TEXT,
  family_feedback TEXT,
  rating INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_task (task_id),
  INDEX idx_volunteer (volunteer_id),
  INDEX idx_family (family_user_id),
  INDEX idx_date (service_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 验证：SHOW CREATE TABLE service_record;

-- ====================== 步骤2：创建关爱计划表 ======================
CREATE TABLE IF NOT EXISTS care_plan (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  family_user_id BIGINT NOT NULL,
  elderly_id BIGINT,
  plan_name VARCHAR(200) NOT NULL,
  description TEXT,
  service_type VARCHAR(100),
  service_frequency VARCHAR(100),
  start_date DATE,
  end_date DATE,
  status VARCHAR(20) DEFAULT 'ACTIVE',
  assigned_volunteer_id BIGINT,
  total_services INT DEFAULT 0,
  completed_services INT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by BIGINT,
  INDEX idx_family_user (family_user_id),
  INDEX idx_volunteer (assigned_volunteer_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 验证：SHOW CREATE TABLE care_plan;

-- ====================== 步骤3：创建反馈表 ======================
CREATE TABLE IF NOT EXISTS feedback (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  family_user_id BIGINT NOT NULL,
  task_id BIGINT,
  volunteer_id BIGINT,
  feedback_type VARCHAR(20) NOT NULL,
  title VARCHAR(200),
  content TEXT NOT NULL,
  rating INT,
  status VARCHAR(20) DEFAULT 'PENDING',
  response TEXT,
  responded_by BIGINT,
  responded_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_family (family_user_id),
  INDEX idx_type (feedback_type),
  INDEX idx_status (status),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 验证：SHOW CREATE TABLE feedback;

-- ====================== 步骤4：插入服务记录数据（第1条）======================
INSERT INTO service_record (task_id, volunteer_id, family_user_id, service_date, service_content, service_duration, rating) 
VALUES (1, 2, 3, '2025-11-15 14:00:00', '协助关爱对象进行日常生活照料，包括做饭、打扫卫生', 120, 5);

-- ====================== 步骤5：插入服务记录数据（第2条）======================
INSERT INTO service_record (task_id, volunteer_id, family_user_id, service_date, service_content, service_duration, rating) 
VALUES (2, 2, 3, '2025-11-13 10:00:00', '陪同关爱对象进行心理辅导，倾听关爱对象心声', 90, 5);

-- ====================== 步骤6：插入服务记录数据（第3条）======================
INSERT INTO service_record (task_id, volunteer_id, family_user_id, service_date, service_content, service_duration, rating) 
VALUES (3, 2, 3, '2025-11-10 09:00:00', '陪同关爱对象前往医院体检', 180, 4);

-- 验证：SELECT * FROM service_record;

-- ====================== 步骤7：插入关爱计划数据 ======================
INSERT INTO care_plan (family_user_id, plan_name, description, service_type, service_frequency, start_date, end_date, status, assigned_volunteer_id, total_services, completed_services) 
VALUES (3, '11月护理计划', '为关爱对象提供日常生活照料和健康护理服务', '生活照料,健康护理', '每周3次', '2025-11-01', '2025-11-30', 'ACTIVE', 2, 12, 3);

-- 验证：SELECT * FROM care_plan;

-- ====================== 步骤8：插入反馈数据 ======================
INSERT INTO feedback (family_user_id, task_id, volunteer_id, feedback_type, title, content, rating, status) 
VALUES (3, 1, 2, 'RATING', '服务非常满意', '志愿者李明服务态度很好，非常耐心细心', 5, 'RESOLVED');

-- 验证：SELECT * FROM feedback;

-- ====================== 步骤9：最终验证 ======================
-- 检查所有表
SHOW TABLES LIKE '%service_record%';
SHOW TABLES LIKE '%care_plan%';
SHOW TABLES LIKE '%feedback%';

-- 统计数据
SELECT 'service_record' as table_name, COUNT(*) as count FROM service_record
UNION ALL
SELECT 'care_plan', COUNT(*) FROM care_plan
UNION ALL
SELECT 'feedback', COUNT(*) FROM feedback;
