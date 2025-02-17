Rails.application.config.emergency_banner_redis_client = Redis.new(
  url: ENV["EMERGENCY_BANNER_REDIS_URL"],
  reconnect_attempts: [15, 30, 45, 60],
)
