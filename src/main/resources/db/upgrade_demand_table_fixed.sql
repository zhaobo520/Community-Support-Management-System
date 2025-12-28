-- 升级需求表，支持家属发布需求功能（修复版）
USE community_help;

-- 先查看当前demand表的结构
-- SHOW CREATE TABLE demand;

-- 删除外键约束（如果存在）
SET @constraint_name = (
    SELECT CONSTRAINT_NAME 
    FROM information_schema.KEY_COLUMN_USAGE 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND REFERENCED_TABLE_NAME = 'help_target'
    LIMIT 1
);

SET @sql_drop_fk = IF(@constraint_name IS NOT NULL, 
    CONCAT('ALTER TABLE demand DROP FOREIGN KEY ', @constraint_name), 
    'SELECT "No foreign key to drop"');

PREPARE stmt FROM @sql_drop_fk;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查并添加列（如果不存在）
-- 添加family_user_id
SET @col_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND COLUMN_NAME = 'family_user_id'
);

SET @sql_add_family_user = IF(@col_exists = 0, 
    'ALTER TABLE demand ADD COLUMN family_user_id BIGINT NULL COMMENT "发布需求的家属用户ID" AFTER target_id', 
    'SELECT "Column family_user_id already exists"');

PREPARE stmt FROM @sql_add_family_user;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加title
SET @col_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND COLUMN_NAME = 'title'
);

SET @sql_add_title = IF(@col_exists = 0, 
    'ALTER TABLE demand ADD COLUMN title VARCHAR(150) NOT NULL DEFAULT "" COMMENT "需求标题" AFTER id', 
    'SELECT "Column title already exists"');

PREPARE stmt FROM @sql_add_title;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加urgency
SET @col_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND COLUMN_NAME = 'urgency'
);

SET @sql_add_urgency = IF(@col_exists = 0, 
    'ALTER TABLE demand ADD COLUMN urgency ENUM("LOW","MEDIUM","HIGH","URGENT") DEFAULT "MEDIUM" COMMENT "紧急程度" AFTER demand_type', 
    'SELECT "Column urgency already exists"');

PREPARE stmt FROM @sql_add_urgency;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加expected_start_time
SET @col_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND COLUMN_NAME = 'expected_start_time'
);

SET @sql_add_est = IF(@col_exists = 0, 
    'ALTER TABLE demand ADD COLUMN expected_start_time DATETIME NULL COMMENT "期望开始时间" AFTER time_requirement', 
    'SELECT "Column expected_start_time already exists"');

PREPARE stmt FROM @sql_add_est;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加expected_end_time
SET @col_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND COLUMN_NAME = 'expected_end_time'
);

SET @sql_add_eet = IF(@col_exists = 0, 
    'ALTER TABLE demand ADD COLUMN expected_end_time DATETIME NULL COMMENT "期望结束时间" AFTER expected_start_time', 
    'SELECT "Column expected_end_time already exists"');

PREPARE stmt FROM @sql_add_eet;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加service_address
SET @col_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND COLUMN_NAME = 'service_address'
);

SET @sql_add_addr = IF(@col_exists = 0, 
    'ALTER TABLE demand ADD COLUMN service_address VARCHAR(255) NULL COMMENT "服务地址" AFTER description', 
    'SELECT "Column service_address already exists"');

PREPARE stmt FROM @sql_add_addr;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加contact_person
SET @col_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND COLUMN_NAME = 'contact_person'
);

SET @sql_add_cp = IF(@col_exists = 0, 
    'ALTER TABLE demand ADD COLUMN contact_person VARCHAR(100) NULL COMMENT "联系人" AFTER service_address', 
    'SELECT "Column contact_person already exists"');

PREPARE stmt FROM @sql_add_cp;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加contact_phone
SET @col_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND COLUMN_NAME = 'contact_phone'
);

SET @sql_add_phone = IF(@col_exists = 0, 
    'ALTER TABLE demand ADD COLUMN contact_phone VARCHAR(20) NULL COMMENT "联系电话" AFTER contact_person', 
    'SELECT "Column contact_phone already exists"');

PREPARE stmt FROM @sql_add_phone;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加reviewer_id
SET @col_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND COLUMN_NAME = 'reviewer_id'
);

SET @sql_add_reviewer = IF(@col_exists = 0, 
    'ALTER TABLE demand ADD COLUMN reviewer_id BIGINT NULL COMMENT "审核人ID" AFTER status', 
    'SELECT "Column reviewer_id already exists"');

PREPARE stmt FROM @sql_add_reviewer;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加review_time
SET @col_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND COLUMN_NAME = 'review_time'
);

SET @sql_add_rt = IF(@col_exists = 0, 
    'ALTER TABLE demand ADD COLUMN review_time DATETIME NULL COMMENT "审核时间" AFTER reviewer_id', 
    'SELECT "Column review_time already exists"');

PREPARE stmt FROM @sql_add_rt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加review_comment
SET @col_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND COLUMN_NAME = 'review_comment'
);

SET @sql_add_rc = IF(@col_exists = 0, 
    'ALTER TABLE demand ADD COLUMN review_comment TEXT NULL COMMENT "审核意见" AFTER review_time', 
    'SELECT "Column review_comment already exists"');

PREPARE stmt FROM @sql_add_rc;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加task_id
SET @col_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND COLUMN_NAME = 'task_id'
);

SET @sql_add_task = IF(@col_exists = 0, 
    'ALTER TABLE demand ADD COLUMN task_id BIGINT NULL COMMENT "转化的任务ID" AFTER review_comment', 
    'SELECT "Column task_id already exists"');

PREPARE stmt FROM @sql_add_task;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 修改target_id为可空
ALTER TABLE demand MODIFY COLUMN target_id BIGINT NULL COMMENT '关爱对象ID（可选）';

-- 修改status字段
ALTER TABLE demand 
  MODIFY COLUMN status ENUM('PENDING','APPROVED','REJECTED','MATCHED','CLOSED') DEFAULT 'PENDING' 
  COMMENT '状态：待审核、已通过、已拒绝、已匹配、已关闭';

-- 添加索引（如果不存在）
SET @index_exists = (
    SELECT COUNT(*) 
    FROM information_schema.STATISTICS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND INDEX_NAME = 'idx_family_user_id'
);

SET @sql_add_idx1 = IF(@index_exists = 0, 
    'ALTER TABLE demand ADD KEY idx_family_user_id (family_user_id)', 
    'SELECT "Index idx_family_user_id already exists"');

PREPARE stmt FROM @sql_add_idx1;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = (
    SELECT COUNT(*) 
    FROM information_schema.STATISTICS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND INDEX_NAME = 'idx_urgency'
);

SET @sql_add_idx2 = IF(@index_exists = 0, 
    'ALTER TABLE demand ADD KEY idx_urgency (urgency)', 
    'SELECT "Index idx_urgency already exists"');

PREPARE stmt FROM @sql_add_idx2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = (
    SELECT COUNT(*) 
    FROM information_schema.STATISTICS 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND INDEX_NAME = 'idx_expected_start_time'
);

SET @sql_add_idx3 = IF(@index_exists = 0, 
    'ALTER TABLE demand ADD KEY idx_expected_start_time (expected_start_time)', 
    'SELECT "Index idx_expected_start_time already exists"');

PREPARE stmt FROM @sql_add_idx3;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加外键约束（如果不存在）
SET @fk_exists = (
    SELECT COUNT(*) 
    FROM information_schema.KEY_COLUMN_USAGE 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND CONSTRAINT_NAME = 'fk_demand_family_user'
);

SET @sql_add_fk1 = IF(@fk_exists = 0, 
    'ALTER TABLE demand ADD CONSTRAINT fk_demand_family_user FOREIGN KEY (family_user_id) REFERENCES sys_user(id) ON DELETE CASCADE', 
    'SELECT "FK fk_demand_family_user already exists"');

PREPARE stmt FROM @sql_add_fk1;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @fk_exists = (
    SELECT COUNT(*) 
    FROM information_schema.KEY_COLUMN_USAGE 
    WHERE TABLE_SCHEMA = 'community_help' 
    AND TABLE_NAME = 'demand' 
    AND CONSTRAINT_NAME = 'fk_demand_reviewer'
);

SET @sql_add_fk2 = IF(@fk_exists = 0, 
    'ALTER TABLE demand ADD CONSTRAINT fk_demand_reviewer FOREIGN KEY (reviewer_id) REFERENCES sys_user(id) ON DELETE SET NULL', 
    'SELECT "FK fk_demand_reviewer already exists"');

PREPARE stmt FROM @sql_add_fk2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 修改表注释
ALTER TABLE demand COMMENT='需求表（支持家属发布和管理员审核）';

SELECT 'Demand table upgrade completed successfully!' AS Result;
