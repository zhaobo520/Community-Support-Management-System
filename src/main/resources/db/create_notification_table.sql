-- 创建通知消息表
USE community_help;

CREATE TABLE IF NOT EXISTS notification (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '通知ID',
  user_id BIGINT NOT NULL COMMENT '接收用户ID',
  title VARCHAR(100) NOT NULL COMMENT '通知标题',
  content TEXT NOT NULL COMMENT '通知内容',
  type VARCHAR(20) NOT NULL COMMENT '通知类型：DEMAND_REVIEW(需求审核),TASK_ASSIGN(任务分配),TASK_COMPLETE(任务完成),TASK_APPROVE(任务评价),SYSTEM(系统消息)',
  related_type VARCHAR(20) COMMENT '关联类型：DEMAND(需求),TASK(任务)',
  related_id BIGINT COMMENT '关联ID',
  is_read TINYINT DEFAULT 0 COMMENT '是否已读：0未读，1已读',
  read_time DATETIME COMMENT '阅读时间',
  created_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  
  INDEX idx_user_id (user_id),
  INDEX idx_is_read (is_read),
  INDEX idx_created_time (created_time),
  CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知消息表';

-- 初始化一些测试数据（可选）
-- INSERT INTO notification (user_id, title, content, type, related_type, related_id) 
-- VALUES (1, '欢迎使用', '欢迎使用社区关爱系统！', 'SYSTEM', NULL, NULL);
