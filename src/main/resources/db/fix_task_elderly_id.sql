-- 修复任务表：允许 elderly_id 为 NULL
-- 因为有些任务可能不需要关联特定的关爱对象

USE community_help;

-- 修改 elderly_id 字段，允许 NULL
ALTER TABLE task_info 
MODIFY COLUMN elderly_id BIGINT NULL COMMENT '关联的关爱对象ID（可选）';

-- 修改 elderly_name 字段，允许 NULL
ALTER TABLE task_info 
MODIFY COLUMN elderly_name VARCHAR(50) NULL COMMENT '关爱对象姓名（可选）';

-- 验证修改结果
DESC task_info;
