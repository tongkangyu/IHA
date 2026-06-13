CREATE DATABASE IF NOT EXISTS health_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE health_db;

CREATE TABLE IF NOT EXISTS t_user (
    user_id VARCHAR(32) PRIMARY KEY,
    mobile VARCHAR(20) NOT NULL UNIQUE,
    password_hash VARCHAR(128) NOT NULL,
    nickname VARCHAR(32),
    role VARCHAR(16) DEFAULT 'USER',
    status INT DEFAULT 1,
    avatar_url VARCHAR(64),
    gender VARCHAR(8),
    birthday DATE,
    height INT,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    INDEX idx_mobile (mobile)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_device (
    device_id VARCHAR(32) PRIMARY KEY,
    owner_id VARCHAR(32) NOT NULL,
    device_name VARCHAR(64) NOT NULL,
    device_type VARCHAR(32),
    vendor VARCHAR(32),
    protocol VARCHAR(16),
    online_status INT DEFAULT 0,
    last_sync_time DATETIME,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    INDEX idx_owner_id (owner_id),
    INDEX idx_online_status (online_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_health_record (
    record_id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) NOT NULL,
    device_id VARCHAR(32),
    metric_type VARCHAR(32) NOT NULL,
    metric_value DECIMAL(10,2) NOT NULL,
    metric_unit VARCHAR(16),
    collect_time DATETIME NOT NULL,
    abnormal_flag INT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    INDEX idx_user_id (user_id),
    INDEX idx_metric_type (metric_type),
    INDEX idx_collect_time (collect_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_environment_record (
    record_id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) NOT NULL,
    device_id VARCHAR(32),
    env_type VARCHAR(32) NOT NULL,
    env_value DECIMAL(10,2) NOT NULL,
    env_unit VARCHAR(16),
    collect_time DATETIME NOT NULL,
    location_tag VARCHAR(32),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    INDEX idx_user_id (user_id),
    INDEX idx_env_type (env_type),
    INDEX idx_collect_time (collect_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_authorization (
    policy_id VARCHAR(32) PRIMARY KEY,
    owner_id VARCHAR(32) NOT NULL,
    target_id VARCHAR(32) NOT NULL,
    target_role VARCHAR(16),
    data_scope TEXT,
    start_time DATETIME,
    end_time DATETIME,
    status VARCHAR(16) DEFAULT 'ACTIVE',
    purpose VARCHAR(64),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    INDEX idx_owner_id (owner_id),
    INDEX idx_target_id (target_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_consultation (
    consultation_id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) NOT NULL,
    doctor_id VARCHAR(32) NOT NULL,
    chief_complaint TEXT,
    status VARCHAR(16) DEFAULT 'PENDING',
    grant_id VARCHAR(32),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    advice_summary TEXT,
    deleted INT DEFAULT 0,
    INDEX idx_user_id (user_id),
    INDEX idx_doctor_id (doctor_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_weekly_report (
    report_id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) NOT NULL,
    week_start DATE NOT NULL,
    week_end DATE NOT NULL,
    summary_json TEXT,
    insight_text TEXT,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    INDEX idx_user_id (user_id),
    INDEX idx_week_start (week_start)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_automation_rule (
    rule_id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) NOT NULL,
    rule_name VARCHAR(64) NOT NULL,
    trigger_condition TEXT,
    action_definition TEXT,
    status VARCHAR(16) DEFAULT 'ACTIVE',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_habit (
    habit_id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) NOT NULL,
    name VARCHAR(64) NOT NULL,
    icon VARCHAR(8) DEFAULT 'H',
    frequency VARCHAR(16) DEFAULT 'DAILY',
    streak INT DEFAULT 0,
    completed_today INT DEFAULT 0,
    target_time VARCHAR(16),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_badge (
    badge_id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) NOT NULL,
    name VARCHAR(64) NOT NULL,
    description VARCHAR(128),
    icon VARCHAR(8) DEFAULT 'B',
    status VARCHAR(16) DEFAULT 'LOCKED',
    progress INT DEFAULT 0,
    target INT DEFAULT 100,
    earned_time DATETIME,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_challenge (
    challenge_id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) NOT NULL,
    name VARCHAR(64) NOT NULL,
    description VARCHAR(128),
    status VARCHAR(16) DEFAULT 'ACTIVE',
    progress INT DEFAULT 0,
    target INT DEFAULT 100,
    days_remaining INT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_course (
    course_id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) NOT NULL,
    name VARCHAR(64) NOT NULL,
    category VARCHAR(32),
    total_lessons INT DEFAULT 0,
    completed_lessons INT DEFAULT 0,
    status VARCHAR(16) DEFAULT 'ACTIVE',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_order (
    order_id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) NOT NULL,
    product_name VARCHAR(64) NOT NULL,
    price DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(16) DEFAULT 'PENDING',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
