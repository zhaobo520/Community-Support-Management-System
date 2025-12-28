-- 关爱人员审核功能 - 数据库更新脚本
-- 执行此脚本为elderly_info表添加家属关联和审核相关字段

-- 选择数据库
USE community_help;

-- 添加新字段
ALTER TABLE elderly_info
ADD COLUMN family_user_id BIGINT COMMENT '关联家属用户ID' AFTER status,
ADD COLUMN audit_status ENUM('PENDING','APPROVED','REJECTED') DEFAULT 'APPROVED' COMMENT '审核状态：PENDING待审核 APPROVED已通过 REJECTED已拒绝' AFTER family_user_id,
ADD COLUMN audit_time DATETIME COMMENT '审核时间' AFTER audit_status,
ADD COLUMN audit_by BIGINT COMMENT '审核人ID' AFTER audit_time,
ADD COLUMN audit_remark VARCHAR(200) COMMENT '审核备注' AFTER audit_by;

-- 添加索引
ALTER TABLE elderly_info
ADD INDEX idx_family_user_id (family_user_id),
ADD INDEX idx_audit_status (audit_status);

-- 将现有数据的审核状态设置为已通过（因为是管理员直接添加的）
UPDATE elderly_info SET audit_status = 'APPROVED' WHERE audit_status IS NULL;
