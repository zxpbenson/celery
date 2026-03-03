-- Redis 初始化脚本
-- 此文件用于在 Redis 启动后执行初始化命令

-- 设置一些示例键值对
redis.call('SET', 'app:status', 'running')
redis.call('SET', 'app:version', '1.0.0')
redis.call('SET', 'app:created_at', os.date())

-- 创建一个示例列表
redis.call('LPUSH', 'queue:tasks', 'task1', 'task2', 'task3')

-- 创建一个示例集合
redis.call('SADD', 'users:online', 'user1', 'user2', 'user3')

-- 创建一个示例哈希
redis.call('HSET', 'config:database', 'host', 'mysql', 'port', '3306', 'database', 'dev')

-- 创建一个示例有序集合
redis.call('ZADD', 'leaderboard', 100, 'player1', 85, 'player2', 95, 'player3')

-- 设置过期时间
redis.call('EXPIRE', 'app:status', 86400) -- 24小时

-- 显示初始化完成信息
print("Redis initialization completed successfully!")