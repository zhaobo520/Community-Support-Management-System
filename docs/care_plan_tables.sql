-- 关爱计划完整数据库脚本
-- 复制全部内容到MySQL执行

USE community_help;

-- 1. 创建服务记录表（如果不存在）
CREATE TABLE IF NOT EXISTS care_plan_service_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    plan_id BIGINT NOT NULL COMMENT '关爱计划ID',
    volunteer_id BIGINT NOT NULL COMMENT '志愿者ID',
    period_number INT DEFAULT 1 COMMENT '周期编号',
    service_number INT DEFAULT 1 COMMENT '服务编号',
    service_date DATE COMMENT '服务日期',
    service_time_start TIME COMMENT '服务开始时间',
    service_time_end TIME COMMENT '服务结束时间',
    service_content TEXT COMMENT '服务内容',
    service_photos VARCHAR(1000) COMMENT '服务照片URL，多个用逗号分隔',
    elderly_condition TEXT COMMENT '老人状况',
    remarks TEXT COMMENT '备注',
    audit_status VARCHAR(20) DEFAULT 'PENDING' COMMENT '审核状态',
    audit_by BIGINT COMMENT '审核人ID',
    audit_time DATETIME COMMENT '审核时间',
    audit_remark VARCHAR(500) COMMENT '审核备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_plan_id (plan_id),
    INDEX idx_volunteer_id (volunteer_id),
    INDEX idx_audit_status (audit_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='关爱计划服务记录表';

-- 2. 创建周期表（如果不存在）
CREATE TABLE IF NOT EXISTS care_plan_period (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    plan_id BIGINT NOT NULL COMMENT '关爱计划ID',
    period_number INT NOT NULL COMMENT '周期编号',
    start_date DATE COMMENT '周期开始日期',
    end_date DATE COMMENT '周期结束日期',
    required_services INT DEFAULT 1 COMMENT '需要完成的服务次数',
    completed_services INT DEFAULT 0 COMMENT '已完成服务次数',
    approved_services INT DEFAULT 0 COMMENT '已审核通过服务次数',
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT '周期状态',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_plan_id (plan_id),
    UNIQUE KEY uk_plan_period (plan_id, period_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='关爱计划周期表';

SELECT '数据库表创建完成！' AS result;
