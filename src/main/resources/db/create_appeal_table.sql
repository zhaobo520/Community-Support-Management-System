-- 创建申诉表
CREATE TABLE IF NOT EXISTS t_appeal (
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
