-- 升级需求表，支持家属发布需求功能
USE community_help;

-- 先删除外键约束
ALTER TABLE demand DROP FOREIGN KEY fk_demand_target;

-- 修改表结构
ALTER TABLE demand
  -- 修改target_id为可空，因为家属需求可能不关联具体的关爱对象
  MODIFY COLUMN target_id BIGINT NULL COMMENT '关爱对象ID（可选）',
  
  -- 添加家属用户ID字段
  ADD COLUMN family_user_id BIGINT NULL COMMENT '发布需求的家属用户ID' AFTER target_id,
  
  -- 添加需求标题
  ADD COLUMN title VARCHAR(150) NOT NULL DEFAULT '' COMMENT '需求标题' AFTER id,
  
  -- 修改需求类型为更具体的枚举
  MODIFY COLUMN demand_type VARCHAR(100) NOT NULL COMMENT '需求类型：医疗护理、生活照料、心理慰藉、家政服务、维修服务、其他',
  
  -- 添加紧急程度
  ADD COLUMN urgency ENUM('LOW','MEDIUM','HIGH','URGENT') DEFAULT 'MEDIUM' COMMENT '紧急程度' AFTER demand_type,
  
  -- 修改时间要求字段
  MODIFY COLUMN time_requirement VARCHAR(255) COMMENT '时间要求描述',
  
  -- 添加期望开始时间
  ADD COLUMN expected_start_time DATETIME NULL COMMENT '期望开始时间' AFTER time_requirement,
  
  -- 添加期望结束时间
  ADD COLUMN expected_end_time DATETIME NULL COMMENT '期望结束时间' AFTER expected_start_time,
  
  -- 添加服务地址
  ADD COLUMN service_address VARCHAR(255) NULL COMMENT '服务地址' AFTER description,
  
  -- 添加联系人信息
  ADD COLUMN contact_person VARCHAR(100) NULL COMMENT '联系人' AFTER service_address,
  ADD COLUMN contact_phone VARCHAR(20) NULL COMMENT '联系电话' AFTER contact_person,
  
  -- 修改状态字段，添加审核状态
  MODIFY COLUMN status ENUM('PENDING','APPROVED','REJECTED','MATCHED','CLOSED') DEFAULT 'PENDING' 
    COMMENT '状态：待审核、已通过、已拒绝、已匹配、已关闭',
  
  -- 添加审核相关字段
  ADD COLUMN reviewer_id BIGINT NULL COMMENT '审核人ID' AFTER status,
  ADD COLUMN review_time DATETIME NULL COMMENT '审核时间' AFTER reviewer_id,
  ADD COLUMN review_comment TEXT NULL COMMENT '审核意见' AFTER review_time,
  
  -- 添加关联任务ID
  ADD COLUMN task_id BIGINT NULL COMMENT '转化的任务ID' AFTER review_comment,
  
  -- 添加索引
  ADD KEY idx_family_user_id (family_user_id),
  ADD KEY idx_urgency (urgency),
  ADD KEY idx_expected_start_time (expected_start_time);

-- 重新添加外键约束
ALTER TABLE demand
  ADD CONSTRAINT fk_demand_target FOREIGN KEY (target_id) REFERENCES help_target(id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_demand_family_user FOREIGN KEY (family_user_id) REFERENCES sys_user(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_demand_reviewer FOREIGN KEY (reviewer_id) REFERENCES sys_user(id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_demand_task FOREIGN KEY (task_id) REFERENCES task(id) ON DELETE SET NULL;

-- 修改表注释
ALTER TABLE demand COMMENT='需求表（支持家属发布和管理员审核）';
