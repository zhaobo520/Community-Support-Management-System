-- 插入统计测试数据
USE community_help;

-- ========================================
-- 1. 插入需求测试数据（如果表是空的）
-- ========================================

-- 检查是否已有需求数据
SET @demand_count = (SELECT COUNT(*) FROM demand);

-- 如果需求表为空，插入测试数据
INSERT INTO demand (title, target_id, family_user_id, demand_type, urgency, 
                    required_skill, time_requirement, expected_start_time, expected_end_time,
                    description, service_address, contact_person, contact_phone, status, created_at)
SELECT * FROM (
  SELECT '帮助购买日常用品' AS title, NULL AS target_id, 3 AS family_user_id, 
         '生活照料' AS demand_type, 'MEDIUM' AS urgency,
         '购物协助' AS required_skill, '每周2次' AS time_requirement, 
         NOW() AS expected_start_time, DATE_ADD(NOW(), INTERVAL 7 DAY) AS expected_end_time,
         '需要帮助购买日常生活用品' AS description, '阳光社区12号楼' AS service_address,
         '张女士' AS contact_person, '13800138001' AS contact_phone, 
         'APPROVED' AS status, NOW() AS created_at
  UNION ALL
  SELECT '陪同就医检查', NULL, 3, '医疗护理', 'HIGH',
         '医疗陪护', '本周内', NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY),
         '需要陪同关爱对象去医院检查', '阳光社区12号楼', '张女士', '13800138001',
         'PENDING', NOW()
  UNION ALL
  SELECT '心理疏导服务', NULL, 3, '心理慰藉', 'LOW',
         '心理咨询', '每月1次', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY),
         '关爱对象情绪低落，需要心理疏导', '阳光社区12号楼', '张女士', '13800138001',
         'MATCHED', NOW()
  UNION ALL
  SELECT '家政清洁服务', NULL, 3, '生活照料', 'MEDIUM',
         '家政服务', '每周1次', NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY),
         '需要定期打扫卫生', '阳光社区12号楼', '张女士', '13800138001',
         'REJECTED', DATE_SUB(NOW(), INTERVAL 2 DAY)
  UNION ALL
  SELECT '送餐服务', NULL, 3, '生活照料', 'MEDIUM',
         '送餐', '每日', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY),
         '需要每日送餐服务', '阳光社区12号楼', '张女士', '13800138001',
         'CLOSED', DATE_SUB(NOW(), INTERVAL 5 DAY)
) AS tmp
WHERE @demand_count = 0;

-- ========================================
-- 2. 插入任务测试数据
-- ========================================

SET @task_count = (SELECT COUNT(*) FROM task_info);

INSERT INTO task_info (task_title, task_type, elderly_id, elderly_name, 
                       description, address, contact_phone, 
                       scheduled_date, scheduled_time, priority, status,
                       volunteer_id, volunteer_name, rating, feedback, created_by, created_time)
SELECT * FROM (
  SELECT '购买日常用品' AS task_title, 'SHOPPING' AS task_type, NULL AS elderly_id, '王奶奶' AS elderly_name,
         '帮助购买米、油、蔬菜等日常用品' AS description, '阳光社区15号楼' AS address, '13900139001' AS contact_phone,
         CURDATE() AS scheduled_date, '09:00-11:00' AS scheduled_time, 'MEDIUM' AS priority, 'APPROVED' AS status,
         2 AS volunteer_id, '志愿者李明' AS volunteer_name, 5 AS rating, '服务态度很好，准时送达' AS feedback,
         1 AS created_by, DATE_SUB(NOW(), INTERVAL 3 DAY) AS created_time
  UNION ALL
  SELECT '陪同就医', 'MEDICAL', NULL, '李大爷',
         '陪同去社区医院做常规检查', '阳光社区18号楼', '13900139002',
         DATE_ADD(CURDATE(), INTERVAL 1 DAY), '08:00-12:00', 'HIGH', 'IN_PROGRESS',
         2, '志愿者李明', NULL, NULL, 1, NOW()
  UNION ALL
  SELECT '家政清洁', 'CLEANING', NULL, '张奶奶',
         '帮助打扫房间卫生', '阳光社区20号楼', '13900139003',
         DATE_ADD(CURDATE(), INTERVAL 2 DAY), '14:00-16:00', 'LOW', 'PENDING',
         NULL, NULL, NULL, NULL, 1, NOW()
  UNION ALL
  SELECT '心理陪伴', 'ACCOMPANY', NULL, '刘大爷',
         '陪关爱对象聊天，缓解孤独感', '阳光社区22号楼', '13900139004',
         CURDATE(), '15:00-17:00', 'MEDIUM', 'CLAIMED',
         2, '志愿者李明', NULL, NULL, 1, DATE_SUB(NOW(), INTERVAL 1 DAY)
  UNION ALL
  SELECT '设备维修', 'REPAIR', NULL, '赵奶奶',
         '帮助维修电视机', '阳光社区25号楼', '13900139005',
         DATE_SUB(CURDATE(), INTERVAL 1 DAY), '10:00-12:00', 'HIGH', 'COMPLETED',
         2, '志愿者李明', 4, '维修及时，技术熟练', 1, DATE_SUB(NOW(), INTERVAL 2 DAY)
  UNION ALL
  SELECT '其他服务', 'OTHER', NULL, '孙大爷',
         '帮助缴纳水电费', '阳光社区28号楼', '13900139006',
         DATE_SUB(CURDATE(), INTERVAL 5 DAY), '09:00-10:00', 'LOW', 'CANCELLED',
         NULL, NULL, NULL, NULL, 1, DATE_SUB(NOW(), INTERVAL 6 DAY)
  UNION ALL
  SELECT '送餐服务', 'SHOPPING', NULL, '周奶奶',
         '送午餐', '阳光社区30号楼', '13900139007',
         DATE_SUB(CURDATE(), INTERVAL 2 DAY), '11:30-12:00', 'MEDIUM', 'APPROVED',
         2, '志愿者李明', 5, '非常满意', 1, DATE_SUB(NOW(), INTERVAL 3 DAY)
) AS tmp
WHERE @task_count = 0;

-- ========================================
-- 3. 确保关爱对象有护理等级数据
-- ========================================

-- 更新已有关爱对象的护理等级（如果为NULL）
UPDATE elderly_info 
SET care_level = CASE 
  WHEN id % 4 = 0 THEN 'LOW'
  WHEN id % 4 = 1 THEN 'MEDIUM'
  WHEN id % 4 = 2 THEN 'HIGH'
  ELSE 'URGENT'
END
WHERE care_level IS NULL OR care_level = '';

-- ========================================
-- 4. 验证数据插入
-- ========================================

SELECT '=== 数据插入完成，统计结果 ===' AS message;

SELECT '需求总数' AS metric, COUNT(*) AS value FROM demand
UNION ALL
SELECT '任务总数', COUNT(*) FROM task_info
UNION ALL
SELECT '志愿者总数', COUNT(*) FROM volunteer_profile
UNION ALL
SELECT '关爱对象总数', COUNT(*) FROM elderly_info
UNION ALL
SELECT '用户总数', COUNT(*) FROM sys_user WHERE status = 1;

SELECT '=== 需求状态分布 ===' AS message;
SELECT status, COUNT(*) AS count FROM demand GROUP BY status;

SELECT '=== 任务状态分布 ===' AS message;
SELECT status, COUNT(*) AS count FROM task_info GROUP BY status;

SELECT '=== 志愿者状态分布 ===' AS message;
SELECT volunteer_status, COUNT(*) AS count FROM volunteer_profile GROUP BY volunteer_status;

SELECT '=== 护理等级分布 ===' AS message;
SELECT care_level, COUNT(*) AS count FROM elderly_info WHERE status = 1 GROUP BY care_level;

SELECT '✅ 测试数据插入完成！刷新统计看板查看效果。' AS message;
