
redis = YAML::load_file(Rails.root.join("config/redis_sidekiq.yml"))
Sidekiq.configure_server do |config|
  unless Rails.env.development?
    config.redis = { :url => "redis://#{redis["server"]}:#{redis["port"]}", :namespace => 'sidekiq' }
  end
end
