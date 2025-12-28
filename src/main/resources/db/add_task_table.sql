-- 创建任务信息表
USE community_help;

CREATE TABLE IF NOT EXISTS task_info (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '任务ID',
  task_title VARCHAR(100) NOT NULL COMMENT '任务标题',
  task_type ENUM('SHOPPING','MEDICAL','CLEANING','ACCOMPANY','REPAIR','OTHER') NOT NULL DEFAULT 'OTHER' COMMENT '任务类型',
  elderly_id BIGINT NOT NULL COMMENT '关爱对象ID',
  elderly_name VARCHAR(50) COMMENT '关爱对象姓名',
  description TEXT COMMENT '任务描述',
  address VARCHAR(200) COMMENT '服务地址',
  contact_phone VARCHAR(20) COMMENT '联系电话',
  scheduled_date DATE COMMENT '预约服务日期',
  scheduled_time VARCHAR(20) COMMENT '预约时段',
  priority ENUM('LOW','MEDIUM','HIGH','URGENT') NOT NULL DEFAULT 'MEDIUM' COMMENT '优先级',
  status ENUM('PENDING','CLAIMED','IN_PROGRESS','COMPLETED','APPROVED','CANCELLED') NOT NULL DEFAULT 'PENDING' COMMENT '任务状态',
  volunteer_id BIGINT COMMENT '志愿者ID',
  volunteer_name VARCHAR(50) COMMENT '志愿者姓名',
  claimed_time DATETIME COMMENT '认领时间',
  completed_time DATETIME COMMENT '完成时间',
  completion_note TEXT COMMENT '完成说明',
  rating TINYINT COMMENT '评分1-5',
  feedback TEXT COMMENT '反馈意见',
  created_by BIGINT COMMENT '创建人ID',
  created_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_time DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX idx_elderly_id (elderly_id),
  INDEX idx_volunteer_id (volunteer_id),
  INDEX idx_status (status),
  INDEX idx_scheduled_date (scheduled_date)
) COMMENT='任务信息表';

-- 初始任务测试数据
INSERT INTO task_info (task_title, task_type, elderly_id, elderly_name, description, address, contact_phone, scheduled_date, scheduled_time, priority, status, volunteer_id, volunteer_name, claimed_time, created_by)
VALUES
 ('为李大爷代购日用品', 'SHOPPING', 1, '李大爷', '购买米面油、蔬菜等日常用品，预算200元左右', '朝阳区幸福路1号', '13900000001', '2025-11-20', '上午9:00-11:00', 'MEDIUM', 'PENDING', NULL, NULL, NULL, 1),
 ('陪同王奶奶就医', 'MEDICAL', 2, '王奶奶', '陪同关爱对象前往朝阳医院复查，需要轮椅', '海淀区和平街2号', '13900000002', '2025-11-21', '下午14:00-17:00', 'HIGH', 'PENDING', NULL, NULL, NULL, 1),
 ('为张大妈打扫卫生', 'CLEANING', 3, '张大妈', '关爱对象独居，需要清洁房间、整理物品', '东城区康乐里3号', '13900000003', '2025-11-19', '上午10:00-12:00', 'URGENT', 'CLAIMED', 2, '志愿者A', '2025-11-18 10:30:00', 1),
 ('陪伴赵老伯聊天', 'ACCOMPANY', 4, '赵老伯', '关爱对象独居，需要心理慰藉和陪伴', '西城区安定门4号', '13900000004', '2025-11-22', '下午15:00-17:00', 'LOW', 'PENDING', NULL, NULL, NULL, 1),
 ('为刘大爷送餐', 'OTHER', 5, '刘大爷', '送热饭菜上门，关爱对象腿脚不便', '丰台区方庄5号', '13900000005', '2025-11-18', '中午11:30-12:30', 'HIGH', 'IN_PROGRESS', 2, '志愿者A', '2025-11-18 09:00:00', 1),
 ('修理李大爷家电器', 'REPAIR', 1, '李大爷', '电视机故障，需要维修或更换', '朝阳区幸福路1号', '13900000001', '2025-11-23', '下午14:00-16:00', 'MEDIUM', 'PENDING', NULL, NULL, NULL, 1),
 ('为王奶奶购买药品', 'SHOPPING', 2, '王奶奶', '代购处方药和营养品，已有处方单', '海淀区和平街2号', '13900000002', '2025-11-20', '上午9:00-11:00', 'HIGH', 'PENDING', NULL, NULL, NULL, 1);
