-- 修复志愿者用户数据
USE community_help;

-- 添加更多志愿者用户账号
INSERT INTO sys_user (username, password, full_name, phone, email, role_type, status)
VALUES
 ('vol02', 'vol123', '志愿者B', '13800000004', 'vol02@community.cn', 'VOLUNTEER', 1),
 ('vol03', 'vol123', '志愿者C', '13800000005', 'vol03@community.cn', 'VOLUNTEER', 1),
 ('vol04', 'vol123', '志愿者D', '13800000006', 'vol04@community.cn', 'VOLUNTEER', 1),
 ('vol05', 'vol123', '志愿者E', '13800000007', 'vol05@community.cn', 'VOLUNTEER', 1);

-- 查询新插入用户的ID
SELECT id, username, full_name, role_type FROM sys_user WHERE username LIKE 'vol%' ORDER BY id;

-- 现在重新插入volunteer_profile数据（先删除旧数据避免冲突）
DELETE FROM volunteer_profile;

-- 使用正确的user_id重新插入（假设vol01的id是2，后续是3,4,5,6）
-- 注意：这里的user_id需要根据实际情况调整
INSERT INTO volunteer_profile (user_id, id_card, gender, birth_date, age, address, emergency_contact, emergency_phone, skills, service_area, available_time, volunteer_status, approve_time, approve_by, service_hours, task_count, average_rating, introduction)
SELECT u.id, '110101199001011234', 'MALE', '1990-01-01', 35, '朝阳区建国路88号', '张三', '13900000201', '护理技能,心理辅导,送餐服务', '朝阳区,东城区', '周一至周五 18:00-21:00，周末全天', 'APPROVED', '2025-01-15 10:00:00', 1, 128.5, 45, 4.8, '退休护士，有丰富的老年护理经验，愿意为社区关爱对象提供专业服务'
FROM sys_user u WHERE u.username = 'vol01'
UNION ALL
SELECT u.id, '110101199205151235', 'FEMALE', '1992-05-15', 33, '海淀区中关村大街1号', '李四', '13900000202', '陪伴聊天,代购,家政清洁', '海淀区,西城区', '周末全天，工作日晚上', 'APPROVED', '2025-02-20 14:30:00', 1, 86.0, 32, 4.9, '热心公益，喜欢与关爱对象聊天，擅长家政服务'
FROM sys_user u WHERE u.username = 'vol02'
UNION ALL
SELECT u.id, '110101198812121236', 'MALE', '1988-12-12', 37, '东城区王府井大街10号', '王五', '13900000203', '维修,代购,陪同就医', '东城区,朝阳区', '周一、三、五全天', 'PENDING', NULL, NULL, 0, 0, 0, '水电工程师，可以帮助关爱对象解决家电维修问题'
FROM sys_user u WHERE u.username = 'vol03'
UNION ALL
SELECT u.id, '110101199509091237', 'FEMALE', '1995-09-09', 30, '西城区金融街5号', '赵六', '13900000204', '心理辅导,陪伴聊天,文艺活动', '西城区,海淀区', '周末下午', 'APPROVED', '2025-03-10 09:00:00', 1, 45.5, 18, 5.0, '心理咨询师，专注老年人心理健康服务'
FROM sys_user u WHERE u.username = 'vol04'
UNION ALL
SELECT u.id, '110101199703031238', 'MALE', '1997-03-03', 28, '丰台区方庄路20号', '孙七', '13900000205', '代购,送餐服务,陪同就医', '丰台区,大兴区', '周一至周五中午，周末全天', 'PENDING', NULL, NULL, 0, 0, 0, '外卖骑手，熟悉周边地区，可以提供配送服务'
FROM sys_user u WHERE u.username = 'vol05';

-- 验证数据
SELECT 
  vp.id, 
  u.username, 
  u.full_name, 
  vp.volunteer_status, 
  vp.skills,
  vp.service_hours,
  vp.task_count
FROM volunteer_profile vp
INNER JOIN sys_user u ON vp.user_id = u.id
ORDER BY vp.id;
