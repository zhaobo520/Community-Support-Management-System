-- 修复 demand 表的外键约束
-- 问题：外键引用的是不存在的 task 表，应该引用 task_info 表

USE community_help;

-- 1. 先检查并删除错误的外键约束（如果存在）
SET @fk_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA = 'community_help'
    AND TABLE_NAME = 'demand'
    AND CONSTRAINT_NAME = 'fk_demand_task'
    AND CONSTRAINT_TYPE = 'FOREIGN KEY'
);

-- 删除外键约束（忽略错误）
SET @sql = IF(@fk_exists > 0, 
    'ALTER TABLE demand DROP FOREIGN KEY fk_demand_task', 
    'SELECT ''外键约束不存在，跳过删除'' AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. 添加正确的外键约束（引用 task_info 表）
ALTER TABLE demand 
ADD CONSTRAINT fk_demand_task 
FOREIGN KEY (task_id) 
REFERENCES task_info(id) 
ON DELETE SET NULL;

-- 3. 验证外键约束
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
    TABLE_SCHEMA = 'community_help'
    AND TABLE_NAME = 'demand'
    AND CONSTRAINT_NAME = 'fk_demand_task';
