-- =====================================================
-- 关爱计划功能完整数据库表结构
-- 业务流程：家属发布 -> 管理员审核 -> 志愿者接单 -> 提交服务记录 -> 管理员审核记录
-- =====================================================

-- 1. 修改care_plan表，增加审核相关字段（如果表已存在）
-- 注意：如果是新建表，请使用下面的完整建表语句

-- 如果需要修改现有表，使用以下ALTER语句：
-- ALTER TABLE care_plan
-- ADD COLUMN audit_status VARCHAR(20) DEFAULT 'PENDING' COMMENT '审核状态: PENDING-待审核, APPROVED-已通过, REJECTED-已拒绝' AFTER status,
-- ADD COLUMN audit_by BIGINT COMMENT '审核人ID' AFTER audit_status,
-- ADD COLUMN audit_time DATETIME COMMENT '审核时间' AFTER audit_by,
-- ADD COLUMN audit_remark VARCHAR(500) COMMENT '审核备注' AFTER audit_time,
-- ADD COLUMN claim_status VARCHAR(20) DEFAULT 'UNCLAIMED' COMMENT '认领状态: UNCLAIMED-待认领, CLAIMED-已认领' AFTER audit_remark,
-- ADD COLUMN claimed_time DATETIME COMMENT '认领时间' AFTER claim_status,
-- ADD COLUMN period_type VARCHAR(20) DEFAULT 'WEEKLY' COMMENT '周期类型: DAILY-每日, WEEKLY-每周, MONTHLY-每月' AFTER claimed_time,
-- ADD COLUMN services_per_period INT DEFAULT 1 COMMENT '每周期服务次数' AFTER period_type,
-- ADD COLUMN total_periods INT DEFAULT 1 COMMENT '总周期数' AFTER services_per_period,
-- ADD COLUMN current_period INT DEFAULT 1 COMMENT '当前周期' AFTER total_periods,
-- ADD COLUMN approved_services INT DEFAULT 0 COMMENT '已审核通过服务次数' AFTER completed_services;

-- 完整的care_plan表结构（如果需要重建）
DROP TABLE IF EXISTS care_plan_service_record;
DROP TABLE IF EXISTS care_plan_period;
DROP TABLE IF EXISTS care_plan;

CREATE TABLE care_plan (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  family_user_id BIGINT NOT NULL COMMENT '家属用户ID',
  elderly_id BIGINT NOT NULL COMMENT '关爱对象ID',
  plan_name VARCHAR(100) NOT NULL COMMENT '计划名称',
  description TEXT COMMENT '计划描述',
  service_type VARCHAR(50) COMMENT '服务类型',
  service_frequency VARCHAR(50) COMMENT '服务频率描述',
  start_date DATE COMMENT '开始日期',
  end_date DATE COMMENT '结束日期',
  status VARCHAR(20) DEFAULT 'ACTIVE' COMMENT '状态: ACTIVE-进行中, COMPLETED-已完成, CANCELLED-已取消',
  audit_status VARCHAR(20) DEFAULT 'PENDING' COMMENT '审核状态: PENDING-待审核, APPROVED-已通过, REJECTED-已拒绝',
  audit_by BIGINT COMMENT '审核人ID',
  audit_time DATETIME COMMENT '审核时间',
  audit_remark VARCHAR(500) COMMENT '审核备注',
  claim_status VARCHAR(20) DEFAULT 'UNCLAIMED' COMMENT '认领状态: UNCLAIMED-待认领, CLAIMED-已认领',
  assigned_volunteer_id BIGINT COMMENT '分配的志愿者ID',
  claimed_time DATETIME COMMENT '认领时间',
  period_type VARCHAR(20) DEFAULT 'WEEKLY' COMMENT '周期类型: DAILY-每日, WEEKLY-每周, MONTHLY-每月',
  services_per_period INT DEFAULT 1 COMMENT '每周期服务次数',
  total_periods INT DEFAULT 1 COMMENT '总周期数',
  current_period INT DEFAULT 1 COMMENT '当前周期',
  total_services INT DEFAULT 0 COMMENT '总服务次数',
  completed_services INT DEFAULT 0 COMMENT '已完成服务次数（已提交）',
  approved_services INT DEFAULT 0 COMMENT '已审核通过服务次数',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  created_by BIGINT COMMENT '创建人ID',

  INDEX idx_family_user_id (family_user_id),
  INDEX idx_elderly_id (elderly_id),
  INDEX idx_status (status),
  INDEX idx_audit_status (audit_status),
  INDEX idx_claim_status (claim_status),
  INDEX idx_assigned_volunteer_id (assigned_volunteer_id),

  FOREIGN KEY (family_user_id) REFERENCES sys_user(id),
  FOREIGN KEY (elderly_id) REFERENCES elderly_info(id),
  FOREIGN KEY (assigned_volunteer_id) REFERENCES sys_user(id),
  FOREIGN KEY (audit_by) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='关爱计划表';

-- 2. 创建关爱计划服务记录表
CREATE TABLE care_plan_service_record (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  plan_id BIGINT NOT NULL COMMENT '关爱计划ID',
  volunteer_id BIGINT NOT NULL COMMENT '志愿者ID',
  period_number INT NOT NULL DEFAULT 1 COMMENT '周期编号（第几个周期）',
  service_number INT NOT NULL DEFAULT 1 COMMENT '本周期第几次服务',
  service_date DATE NOT NULL COMMENT '服务日期',
  service_time_start TIME COMMENT '服务开始时间',
  service_time_end TIME COMMENT '服务结束时间',
  service_content TEXT COMMENT '服务内容描述',
  service_photos VARCHAR(2000) COMMENT '服务照片URL，多个用逗号分隔',
  elderly_condition TEXT COMMENT '关爱对象状况描述',
  remarks TEXT COMMENT '备注',
  audit_status VARCHAR(20) DEFAULT 'PENDING' COMMENT '审核状态: PENDING-待审核, APPROVED-已通过, REJECTED-已拒绝',
  audit_by BIGINT COMMENT '审核人ID',
  audit_time DATETIME COMMENT '审核时间',
  audit_remark VARCHAR(500) COMMENT '审核备注',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  INDEX idx_plan_id (plan_id),
  INDEX idx_volunteer_id (volunteer_id),
  INDEX idx_period_number (period_number),
  INDEX idx_audit_status (audit_status),
  INDEX idx_service_date (service_date),

  FOREIGN KEY (plan_id) REFERENCES care_plan(id) ON DELETE CASCADE,
  FOREIGN KEY (volunteer_id) REFERENCES sys_user(id),
  FOREIGN KEY (audit_by) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='关爱计划服务记录表';

-- 3. 创建周期完成记录表（用于跟踪每个周期的完成状态）
CREATE TABLE care_plan_period (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  plan_id BIGINT NOT NULL COMMENT '关爱计划ID',
  period_number INT NOT NULL COMMENT '周期编号',
  period_start_date DATE NOT NULL COMMENT '周期开始日期',
  period_end_date DATE NOT NULL COMMENT '周期结束日期',
  required_services INT NOT NULL COMMENT '本周期需要完成的服务次数',
  completed_services INT DEFAULT 0 COMMENT '本周期已完成的服务次数',
  approved_services INT DEFAULT 0 COMMENT '本周期已审核通过的服务次数',
  status VARCHAR(20) DEFAULT 'PENDING' COMMENT '状态: PENDING-进行中, COMPLETED-已完成, OVERDUE-已逾期',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  INDEX idx_plan_id (plan_id),
  INDEX idx_period_number (period_number),
  INDEX idx_status (status),

  UNIQUE KEY uk_plan_period (plan_id, period_number),
  FOREIGN KEY (plan_id) REFERENCES care_plan(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='关爱计划周期表';

-- 4. 插入测试数据（可选）
-- INSERT INTO care_plan (family_user_id, elderly_id, plan_name, description, service_type, service_frequency,
--   start_date, end_date, status, audit_status, period_type, services_per_period, total_periods, total_services)
-- VALUES
-- (3, 1, '12月日常照料计划', '为关爱对象提供日常生活照料服务', '生活照料', '每周3次',
--  '2025-12-01', '2025-12-31', 'ACTIVE', 'PENDING', 'WEEKLY', 3, 4, 12);
