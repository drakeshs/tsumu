Sidekiq.configure_server do |config|
  unless Rails.env.development?
    config.redis = { :url => 'redis://redis.example.com:7372/12', :namespace => 'mynamespace' }
  end
end
