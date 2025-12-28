-- community_help database initialization script
DROP DATABASE IF EXISTS community_help;
CREATE DATABASE community_help CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE community_help;

-- 用户表
CREATE TABLE sys_user (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
  username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
  password VARCHAR(100) NOT NULL COMMENT '密码（加密）',
  full_name VARCHAR(100) NOT NULL COMMENT '姓名',
  phone VARCHAR(20) NOT NULL COMMENT '手机号',
  email VARCHAR(100) COMMENT '邮箱',
  role_type ENUM('STAFF','VOLUNTEER','FAMILY') NOT NULL DEFAULT 'STAFF' COMMENT '角色类型',
  status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用 0禁用',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  UNIQUE KEY uk_user_phone (phone)
) COMMENT='系统用户表';

-- 角色表
CREATE TABLE sys_role (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '角色ID',
  role_code VARCHAR(50) NOT NULL UNIQUE COMMENT '角色编码',
  role_name VARCHAR(100) NOT NULL COMMENT '角色名称',
  description VARCHAR(255) COMMENT '描述',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT='角色表';

-- 权限表
CREATE TABLE sys_permission (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '权限ID',
  perm_code VARCHAR(100) NOT NULL UNIQUE COMMENT '权限编码',
  perm_name VARCHAR(100) NOT NULL COMMENT '权限名称',
  url VARCHAR(200) COMMENT '资源路径',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT='权限表';

-- 角色权限关联
CREATE TABLE sys_role_permission (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  role_id BIGINT NOT NULL COMMENT '角色ID',
  permission_id BIGINT NOT NULL COMMENT '权限ID',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_role_perm (role_id, permission_id),
  CONSTRAINT fk_role_perm_role FOREIGN KEY (role_id) REFERENCES sys_role(id),
  CONSTRAINT fk_role_perm_perm FOREIGN KEY (permission_id) REFERENCES sys_permission(id)
) COMMENT='角色权限关系';

-- 用户角色关联
CREATE TABLE sys_user_role (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  user_id BIGINT NOT NULL COMMENT '用户ID',
  role_id BIGINT NOT NULL COMMENT '角色ID',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_user_role (user_id, role_id),
  CONSTRAINT fk_user_role_user FOREIGN KEY (user_id) REFERENCES sys_user(id),
  CONSTRAINT fk_user_role_role FOREIGN KEY (role_id) REFERENCES sys_role(id)
) COMMENT='用户角色关系';

-- 关爱对象
CREATE TABLE help_target (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '关爱对象ID',
  archive_no VARCHAR(40) NOT NULL UNIQUE COMMENT '档案号',
  name VARCHAR(100) NOT NULL COMMENT '姓名',
  gender CHAR(1) COMMENT '性别',
  age INT COMMENT '年龄',
  special_condition VARCHAR(255) COMMENT '特殊情况',
  family_address VARCHAR(255) COMMENT '家庭住址',
  contact_phone VARCHAR(20) COMMENT '联系方式',
  region VARCHAR(100) COMMENT '所属区域',
  status TINYINT DEFAULT 1 COMMENT '状态',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_help_target_region (region)
) COMMENT='关爱对象档案表';

-- 志愿者
CREATE TABLE volunteer (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '志愿者ID',
  user_id BIGINT NOT NULL COMMENT '关联用户ID',
  name VARCHAR(100) NOT NULL COMMENT '姓名',
  skill_tags VARCHAR(255) COMMENT '技能标签',
  register_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  total_service_hours INT DEFAULT 0 COMMENT '服务总时长',
  review_status ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING' COMMENT '审核状态',
  rating DECIMAL(3,2) DEFAULT 5.00 COMMENT '平均评分',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_volunteer_status (review_status),
  CONSTRAINT fk_volunteer_user FOREIGN KEY (user_id) REFERENCES sys_user(id)
) COMMENT='志愿者信息表';

-- 任务表
CREATE TABLE task (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '任务ID',
  demand_id BIGINT COMMENT '需求ID',
  volunteer_id BIGINT COMMENT '志愿者ID',
  title VARCHAR(150) NOT NULL COMMENT '任务标题',
  description TEXT COMMENT '任务描述',
  status ENUM('PENDING','ASSIGNED','ACCEPTED','COMPLETED','CANCELLED') DEFAULT 'PENDING' COMMENT '状态',
  progress VARCHAR(100) DEFAULT '待处理' COMMENT '进度说明',
  start_time DATETIME COMMENT '开始时间',
  end_time DATETIME COMMENT '结束时间',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_task_status (status)
) COMMENT='任务表';

-- 需求表
CREATE TABLE demand (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '需求ID',
  target_id BIGINT NOT NULL COMMENT '关爱对象ID',
  demand_type VARCHAR(100) NOT NULL COMMENT '需求类型',
  required_skill VARCHAR(100) COMMENT '所需技能',
  time_requirement VARCHAR(100) COMMENT '时间要求',
  description TEXT COMMENT '需求描述',
  status ENUM('OPEN','MATCHED','CLOSED') DEFAULT 'OPEN' COMMENT '状态',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_demand_type (demand_type),
  CONSTRAINT fk_demand_target FOREIGN KEY (target_id) REFERENCES help_target(id)
) COMMENT='需求表';

-- 资源表
CREATE TABLE resource (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '资源ID',
  name VARCHAR(150) NOT NULL COMMENT '资源名称',
  type VARCHAR(100) NOT NULL COMMENT '资源类型',
  quantity INT NOT NULL DEFAULT 0 COMMENT '数量',
  status ENUM('AVAILABLE','RESERVED','IN_USE') DEFAULT 'AVAILABLE' COMMENT '状态',
  location VARCHAR(200) COMMENT '存放位置',
  warning_threshold INT DEFAULT 5 COMMENT '库存预警值',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_resource_type (type)
) COMMENT='社区资源表';

-- 评价表
CREATE TABLE evaluation (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评价ID',
  task_id BIGINT NOT NULL COMMENT '任务ID',
  score INT NOT NULL COMMENT '评分',
  content TEXT COMMENT '评价内容',
  evaluator_id BIGINT NOT NULL COMMENT '评价人',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_evaluation_score (score),
  CONSTRAINT fk_eval_task FOREIGN KEY (task_id) REFERENCES task(id)
) COMMENT='服务评价表';

-- 关爱记录表
CREATE TABLE help_record (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
  target_id BIGINT NOT NULL COMMENT '关爱对象ID',
  task_id BIGINT NOT NULL COMMENT '任务ID',
  volunteer_id BIGINT NOT NULL COMMENT '志愿者ID',
  summary TEXT COMMENT '关爱总结',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_help_record_target FOREIGN KEY (target_id) REFERENCES help_target(id)
) COMMENT='关爱记录表';

-- 索引示例：手机号、任务状态等已在字段上建立

-- 初始化角色与权限数据（示例）
INSERT INTO sys_role (role_code, role_name, description) VALUES
 ('ROLE_ADMIN', '社区工作人员', '负责社区整体管理'),
 ('ROLE_VOL', '志愿者', '执行志愿服务任务'),
 ('ROLE_FAMILY', '关爱对象家属', '协同沟通反馈');

INSERT INTO sys_permission (perm_code, perm_name, url) VALUES
 ('dashboard:view', '查看仪表盘', '/user/home'),
 ('task:manage', '任务管理', '/task/**'),
 ('profile:edit', '编辑个人信息', '/user/profile'),
 ('resource:view', '查看资源', '/resource/**');

INSERT INTO sys_role_permission (role_id, permission_id)
SELECT r.id, p.id
FROM sys_role r
JOIN sys_permission p ON (
    (r.role_code = 'ROLE_ADMIN' AND p.perm_code IN ('dashboard:view','task:manage','profile:edit','resource:view')) OR
    (r.role_code = 'ROLE_VOL' AND p.perm_code IN ('dashboard:view','profile:edit')) OR
    (r.role_code = 'ROLE_FAMILY' AND p.perm_code IN ('dashboard:view','profile:edit'))
);

-- 初始用户（密码均为明文：admin123 / vol123 / family123，登录时会自动MD5校验）
INSERT INTO sys_user (username, password, full_name, phone, email, role_type, status)
VALUES
 ('admin01', 'admin123', '社区管理员', '13800000001', 'admin@community.cn', 'STAFF', 1),
 ('vol01', 'vol123', '志愿者A', '13800000002', 'vol01@community.cn', 'VOLUNTEER', 1),
 ('family01', 'family123', '家属张女士', '13800000003', 'family01@community.cn', 'FAMILY', 1);

INSERT INTO sys_user_role (user_id, role_id)
SELECT u.id, r.id FROM sys_user u JOIN sys_role r ON
 (u.username = 'admin01' AND r.role_code = 'ROLE_ADMIN') OR
 (u.username = 'vol01' AND r.role_code = 'ROLE_VOL') OR
 (u.username = 'family01' AND r.role_code = 'ROLE_FAMILY');

-- 关爱对象信息表
CREATE TABLE elderly_info (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  name VARCHAR(50) NOT NULL COMMENT '姓名',
  id_card VARCHAR(18) COMMENT '身份证号',
  gender ENUM('MALE','FEMALE') COMMENT '性别',
  birth_date DATE COMMENT '出生日期',
  age INT COMMENT '年龄',
  phone VARCHAR(20) COMMENT '联系电话',
  address VARCHAR(200) COMMENT '居住地址',
  health_status VARCHAR(100) COMMENT '健康状况',
  disability_level VARCHAR(20) COMMENT '残疾等级',
  living_alone TINYINT DEFAULT 0 COMMENT '是否独居：1是 0否',
  family_contact VARCHAR(50) COMMENT '家属联系人',
  family_phone VARCHAR(20) COMMENT '家属电话',
  special_needs TEXT COMMENT '特殊需求',
  care_level ENUM('LOW','MEDIUM','HIGH','URGENT') DEFAULT 'MEDIUM' COMMENT '关爱等级',
  photo_url VARCHAR(255) COMMENT '关爱对象照片URL',
  status TINYINT DEFAULT 1 COMMENT '状态：1启用 0停用',
  family_user_id BIGINT COMMENT '关联家属用户ID',
  audit_status ENUM('PENDING','APPROVED','REJECTED') DEFAULT 'APPROVED' COMMENT '审核状态：PENDING待审核 APPROVED已通过 REJECTED已拒绝',
  audit_time DATETIME COMMENT '审核时间',
  audit_by BIGINT COMMENT '审核人ID',
  audit_remark VARCHAR(200) COMMENT '审核备注',
  created_by BIGINT COMMENT '录入人ID',
  created_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_time DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  UNIQUE KEY uk_id_card (id_card),
  KEY idx_family_user_id (family_user_id),
  KEY idx_audit_status (audit_status)
) COMMENT='关爱对象信息表';

-- 初始关爱对象测试数据
INSERT INTO elderly_info (name, id_card, gender, birth_date, age, phone, address, health_status, disability_level, living_alone, family_contact, family_phone, special_needs, care_level, status, created_by)
VALUES
 ('李大爷', '110101195001011234', 'MALE', '1950-01-01', 75, '13900000001', '朝阳区幸福路1号', '高血压、糖尿病', '无', 1, '李小明', '13900000101', '需要定期测血压，每周送餐3次', 'HIGH', 1, 1),
 ('王奶奶', '110101195502021235', 'FEMALE', '1955-02-02', 70, '13900000002', '海淀区和平街2号', '关节炎', '轻度', 0, '王芳', '13900000102', '行动不便，需要陪同就医', 'MEDIUM', 1, 1),
 ('张大妈', '110101194803031236', 'FEMALE', '1948-03-03', 77, '13900000003', '东城区康乐里3号', '阿尔茨海默症早期', '中度', 1, '张强', '13900000103', '记忆力减退，需要心理辅导和定期探访', 'URGENT', 1, 1),
 ('赵老伯', '110101195204041237', 'MALE', '1952-04-04', 73, '13900000004', '西城区安定门4号', '健康良好', '无', 0, '赵丽', '13900000104', '独居关爱对象，需要定期关怀', 'LOW', 1, 1),
 ('刘大爷', '110101194905051238', 'MALE', '1949-05-05', 76, '13900000005', '丰台区方庄5号', '心脏病、高血压', '轻度', 1, '刘军', '13900000105', '需要送餐服务，按时服药提醒', 'HIGH', 1, 1);

-- 任务信息表
CREATE TABLE task_info (
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

-- 志愿者扩展信息表
CREATE TABLE volunteer_profile (
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

-- 申诉表
CREATE TABLE t_appeal (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '申诉ID',
  user_id BIGINT COMMENT '申诉用户ID',
  user_role VARCHAR(50) COMMENT '用户角色: VOLUNTEER, FAMILY',
  username VARCHAR(100) NOT NULL COMMENT '用户名',
  phone VARCHAR(20) COMMENT '手机号',
  appeal_type VARCHAR(50) COMMENT '申诉类型',
  description LONGTEXT COMMENT '详细描述',
  attachment VARCHAR(500) COMMENT '附件',
  status VARCHAR(50) DEFAULT 'PENDING' COMMENT '申诉状态: PENDING, PROCESSING, RESOLVED, REJECTED',
  response LONGTEXT COMMENT '处理回复',
  responded_by BIGINT COMMENT '处理人ID',
  responded_at DATETIME COMMENT '处理时间',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  KEY idx_user_id (user_id),
  KEY idx_status (status),
  KEY idx_user_role (user_role),
  KEY idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户申诉表';
