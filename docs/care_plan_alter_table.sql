-- 使用存储过程安全添加字段（自动跳过已存在的字段）
-- 复制全部内容到MySQL执行

USE community_help;

DROP PROCEDURE IF EXISTS add_column_if_not_exists;

DELIMITER //
CREATE PROCEDURE add_column_if_not_exists()
BEGIN
    -- audit_by
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'audit_by') THEN
        ALTER TABLE care_plan ADD COLUMN audit_by BIGINT;
    END IF;

    -- audit_time
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'audit_time') THEN
        ALTER TABLE care_plan ADD COLUMN audit_time DATETIME;
    END IF;

    -- audit_remark
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'audit_remark') THEN
        ALTER TABLE care_plan ADD COLUMN audit_remark VARCHAR(500);
    END IF;

    -- claim_status
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'claim_status') THEN
        ALTER TABLE care_plan ADD COLUMN claim_status VARCHAR(20) DEFAULT 'UNCLAIMED';
    END IF;

    -- assigned_volunteer_id
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'assigned_volunteer_id') THEN
        ALTER TABLE care_plan ADD COLUMN assigned_volunteer_id BIGINT;
    END IF;

    -- claimed_time
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'claimed_time') THEN
        ALTER TABLE care_plan ADD COLUMN claimed_time DATETIME;
    END IF;

    -- period_type
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'period_type') THEN
        ALTER TABLE care_plan ADD COLUMN period_type VARCHAR(20) DEFAULT 'WEEKLY';
    END IF;

    -- services_per_period
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'services_per_period') THEN
        ALTER TABLE care_plan ADD COLUMN services_per_period INT DEFAULT 1;
    END IF;

    -- total_periods
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'total_periods') THEN
        ALTER TABLE care_plan ADD COLUMN total_periods INT DEFAULT 1;
    END IF;

    -- current_period
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'current_period') THEN
        ALTER TABLE care_plan ADD COLUMN current_period INT DEFAULT 1;
    END IF;

    -- total_services
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'total_services') THEN
        ALTER TABLE care_plan ADD COLUMN total_services INT DEFAULT 0;
    END IF;

    -- completed_services
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'completed_services') THEN
        ALTER TABLE care_plan ADD COLUMN completed_services INT DEFAULT 0;
    END IF;

    -- approved_services
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'approved_services') THEN
        ALTER TABLE care_plan ADD COLUMN approved_services INT DEFAULT 0;
    END IF;

    -- created_by
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = 'community_help' AND table_name = 'care_plan' AND column_name = 'created_by') THEN
        ALTER TABLE care_plan ADD COLUMN created_by BIGINT;
    END IF;
END //
DELIMITER ;

-- 执行存储过程
CALL add_column_if_not_exists();

-- 删除存储过程
DROP PROCEDURE IF EXISTS add_column_if_not_exists;

-- 更新默认值
UPDATE care_plan SET audit_status = 'APPROVED' WHERE audit_status IS NULL;
UPDATE care_plan SET claim_status = 'UNCLAIMED' WHERE claim_status IS NULL;
UPDATE care_plan SET period_type = 'WEEKLY' WHERE period_type IS NULL;
UPDATE care_plan SET services_per_period = 1 WHERE services_per_period IS NULL;
UPDATE care_plan SET total_periods = 1 WHERE total_periods IS NULL;
UPDATE care_plan SET current_period = 1 WHERE current_period IS NULL;

SELECT '执行完成！' AS result;
