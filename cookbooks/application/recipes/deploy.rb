directory "/var/www" do
  owner "root"
  group "root"
  mode "2755"
  recursive true
end

[
  "/var/www/application",
  "/var/www/application/.ssh",
  "/var/www/application/shared",
  "/var/www/application/shared/config",
  "/var/www/application/shared/config/unicorn",
  "/var/www/application/shared/config/constants",
  "/var/www/application/log",
  "/var/www/application/log/nginx"
].each do |directory_name|
  directory  directory_name do
    owner "deploy"
    group "deploy"
    mode "2775"
    recursive true
  end
end


database_yml = "/var/www/application/shared/config/database.yml"
unless File.exists?(database_yml)
  template database_yml do
    source "database.yml.erb"
    owner "deploy"
    group "deploy"
    mode "0755"
    variables({
      host: node['application']['database']['host'],
      port: node['application']['database']['port'],
      username: node['application']['database']['username'],
      password: node['application']['database']['password'],
      database: node['application']['database']['database']
    })
  end
end

redis_yml = "/var/www/application/shared/config/constants/redis.yml"
unless File.exists?(redis_yml)
  template redis_yml do
    source "redis/redis.yml.erb"
    owner "deploy"
    group "deploy"
    mode "0755"
    variables({
      host: node['application']['cache']['host'],
      port: node['application']['cache']['port']
    })
  end
end

redis_cache_yml = "/var/www/application/shared/config/constants/redis_cache.yml"
unless File.exists?(redis_cache_yml)
  template redis_cache_yml do
    source "redis/redis_cache.yml.erb"
    owner "deploy"
    group "deploy"
    mode "0755"
    variables({
      host: node['application']['cache']['host'],
      port: node['application']['cache']['port']
    })
  end
end

redis_sessions_yml = "/var/www/application/shared/config/constants/redis_sessions.yml"
unless File.exists?(redis_sessions_yml)
  template redis_sessions_yml do
    source "redis/redis_sessions.yml.erb"
    owner "deploy"
    group "deploy"
    mode "0755"
    variables({
      host: node['application']['cache']['host'],
      port: node['application']['cache']['port']
    })
  end
end


template "/var/www/application/shared/config/unicorn/config.rb" do
  source "unicorn_config.erb"
  owner "deploy"
  group "deploy"
  mode "0755"
  variables :directory => "/var/www/application/current"
end

