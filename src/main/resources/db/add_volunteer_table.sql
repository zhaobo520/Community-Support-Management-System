-- 创建志愿者扩展信息表
USE community_help;

CREATE TABLE IF NOT EXISTS volunteer_profile (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  user_id BIGINT NOT NULL COMMENT '用户ID',
  id_card VARCHAR(18) COMMENT '身份证号',
  gender ENUM('MALE','FEMALE') COMMENT '性别',
  birth_date DATE COMMENT '出生日期',
  age INT COMMENT '年龄',
  address VARCHAR(200) COMMENT '居住地址',
  emergency_contact VARCHAR(50) COMMENT '紧急联系人',
  emergency_phone VARCHAR(20) COMMENT '紧急联系电话',
  skills VARCHAR(500) COMMENT '技能标签（逗号分隔）',
  service_area VARCHAR(200) COMMENT '服务区域',
  available_time VARCHAR(200) COMMENT '可服务时间',
  volunteer_status ENUM('PENDING','APPROVED','REJECTED','SUSPENDED') NOT NULL DEFAULT 'PENDING' COMMENT '志愿者状态',
  approve_time DATETIME COMMENT '审核时间',
  approve_by BIGINT COMMENT '审核人ID',
  service_hours DECIMAL(10,2) DEFAULT 0 COMMENT '累计服务时长（小时）',
  task_count INT DEFAULT 0 COMMENT '完成任务数',
  average_rating DECIMAL(3,2) DEFAULT 0 COMMENT '平均评分',
  introduction TEXT COMMENT '个人简介',
  photo_url VARCHAR(255) COMMENT '照片URL',
  created_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_time DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  UNIQUE KEY uk_user_id (user_id),
  INDEX idx_status (volunteer_status)
) COMMENT='志愿者扩展信息表';

-- 初始志愿者数据
INSERT INTO volunteer_profile (user_id, id_card, gender, birth_date, age, address, emergency_contact, emergency_phone, skills, service_area, available_time, volunteer_status, approve_time, approve_by, service_hours, task_count, average_rating, introduction)
VALUES
 (2, '110101199001011234', 'MALE', '1990-01-01', 35, '朝阳区建国路88号', '张三', '13900000201', '护理技能,心理辅导,送餐服务', '朝阳区,东城区', '周一至周五 18:00-21:00，周末全天', 'APPROVED', '2025-01-15 10:00:00', 1, 128.5, 45, 4.8, '退休护士，有丰富的老年护理经验，愿意为社区关爱对象提供专业服务'),
 (3, '110101199205151235', 'FEMALE', '1992-05-15', 33, '海淀区中关村大街1号', '李四', '13900000202', '陪伴聊天,代购,家政清洁', '海淀区,西城区', '周末全天，工作日晚上', 'APPROVED', '2025-02-20 14:30:00', 1, 86.0, 32, 4.9, '热心公益，喜欢与关爱对象聊天，擅长家政服务'),
 (4, '110101198812121236', 'MALE', '1988-12-12', 37, '东城区王府井大街10号', '王五', '13900000203', '维修,代购,陪同就医', '东城区,朝阳区', '周一、三、五全天', 'PENDING', NULL, NULL, 0, 0, 0, '水电工程师，可以帮助关爱对象解决家电维修问题'),
 (5, '110101199509091237', 'FEMALE', '1995-09-09', 30, '西城区金融街5号', '赵六', '13900000204', '心理辅导,陪伴聊天,文艺活动', '西城区,海淀区', '周末下午', 'APPROVED', '2025-03-10 09:00:00', 1, 45.5, 18, 5.0, '心理咨询师，专注老年人心理健康服务'),
 (6, '110101199703031238', 'MALE', '1997-03-03', 28, '丰台区方庄路20号', '孙七', '13900000205', '代购,送餐服务,陪同就医', '丰台区,大兴区', '周一至周五中午，周末全天', 'PENDING', NULL, NULL, 0, 0, 0, '外卖骑手，熟悉周边地区，可以提供配送服务');
