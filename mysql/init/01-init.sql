-- MySQL 初始化脚本
-- 此文件在容器首次启动时自动执行

-- 创建示例数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS `dev` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用 dev 数据库
USE `dev`;

-- 创建示例表
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入示例数据
INSERT INTO `users` (`username`, `email`) VALUES
('admin', 'admin@example.com'),
('user1', 'user1@example.com'),
('user2', 'user2@example.com')
ON DUPLICATE KEY UPDATE `username` = VALUES(`username`);

-- 创建示例表
CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入示例数据
INSERT INTO `products` (`name`, `price`, `stock`) VALUES
('Product A', 99.99, 100),
('Product B', 199.99, 50),
('Product C', 299.99, 30)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- 显示初始化完成信息
SELECT 'MySQL initialization completed successfully!' AS message;