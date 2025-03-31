require 'redis'

redis_url = ENV["REDIS_URL"] || "redis://localhost:6379/1"
REDIS = Redis.new(url: redis_url)

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end 