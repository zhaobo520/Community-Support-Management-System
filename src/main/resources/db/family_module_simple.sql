-- Simple version without comments
USE community_help;

-- Create service_record table
CREATE TABLE IF NOT EXISTS service_record (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  task_id BIGINT NOT NULL,
  volunteer_id BIGINT NOT NULL,
  elderly_id BIGINT,
  family_user_id BIGINT NOT NULL,
  service_date DATETIME NOT NULL,
  service_content TEXT,
  service_duration INT DEFAULT 0,
  service_photos VARCHAR(500),
  service_notes TEXT,
  family_feedback TEXT,
  rating INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_task (task_id),
  INDEX idx_volunteer (volunteer_id),
  INDEX idx_family (family_user_id),
  INDEX idx_date (service_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create care_plan table
CREATE TABLE IF NOT EXISTS care_plan (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  family_user_id BIGINT NOT NULL,
  elderly_id BIGINT,
  plan_name VARCHAR(200) NOT NULL,
  description TEXT,
  service_type VARCHAR(100),
  service_frequency VARCHAR(100),
  start_date DATE,
  end_date DATE,
  status VARCHAR(20) DEFAULT 'ACTIVE',
  assigned_volunteer_id BIGINT,
  total_services INT DEFAULT 0,
  completed_services INT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by BIGINT,
  INDEX idx_family_user (family_user_id),
  INDEX idx_volunteer (assigned_volunteer_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create feedback table
CREATE TABLE IF NOT EXISTS feedback (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  family_user_id BIGINT NOT NULL,
  task_id BIGINT,
  volunteer_id BIGINT,
  feedback_type VARCHAR(20) NOT NULL,
  title VARCHAR(200),
  content TEXT NOT NULL,
  rating INT,
  status VARCHAR(20) DEFAULT 'PENDING',
  response TEXT,
  responded_by BIGINT,
  responded_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_family (family_user_id),
  INDEX idx_type (feedback_type),
  INDEX idx_status (status),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert test data
INSERT INTO service_record (task_id, volunteer_id, family_user_id, service_date, service_content, service_duration, rating) 
VALUES (1, 2, 3, '2025-11-15 14:00:00', 'Daily care assistance', 120, 5);

INSERT INTO service_record (task_id, volunteer_id, family_user_id, service_date, service_content, service_duration, rating) 
VALUES (2, 2, 3, '2025-11-13 10:00:00', 'Psychological counseling', 90, 5);

INSERT INTO service_record (task_id, volunteer_id, family_user_id, service_date, service_content, service_duration, rating) 
VALUES (3, 2, 3, '2025-11-10 09:00:00', 'Hospital visit assistance', 180, 4);

INSERT INTO care_plan (family_user_id, plan_name, description, service_type, service_frequency, start_date, end_date, status, assigned_volunteer_id, total_services, completed_services) 
VALUES (3, 'November Care Plan', 'Daily care and health services', 'Daily Care,Health', '3 times per week', '2025-11-01', '2025-11-30', 'ACTIVE', 2, 12, 3);

INSERT INTO feedback (family_user_id, task_id, volunteer_id, feedback_type, title, content, rating, status) 
VALUES (3, 1, 2, 'RATING', 'Very satisfied', 'Great service', 5, 'RESOLVED');
