-- 为sys_user表添加avatar字段
-- 执行时间：2025-11-19

USE community_elderly_care;

-- 添加avatar字段
ALTER TABLE sys_user 
ADD COLUMN avatar VARCHAR(500) NULL COMMENT '用户头像URL' 
AFTER email;

-- 验证字段添加成功
DESC sys_user;
