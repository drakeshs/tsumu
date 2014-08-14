unless Rails.env.development?
  redis = YAML::load_file(Rails.root.join("config/redis_sidekiq.yml"))
  Sidekiq.configure_server do |config|
      config.redis = { :url => "redis://#{redis["server"]}:#{redis["port"]}", :namespace => 'sidekiq' }
  end
end
