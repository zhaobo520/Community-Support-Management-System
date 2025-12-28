USE community_help;

-- 添加任务地点的经纬度字段
ALTER TABLE task_info ADD COLUMN latitude DECIMAL(10, 6) DEFAULT NULL COMMENT '任务地点纬度';
ALTER TABLE task_info ADD COLUMN longitude DECIMAL(10, 6) DEFAULT NULL COMMENT '任务地点经度';

-- 为了测试，更新几条数据的坐标（模拟数据）
-- 假设社区中心坐标 (39.9042, 116.4074) 北京
-- 这里的坐标仅为示例，实际应根据地址解析
UPDATE task_info SET latitude = 39.904200, longitude = 116.407400 WHERE status IN ('CLAIMED', 'IN_PROGRESS');
