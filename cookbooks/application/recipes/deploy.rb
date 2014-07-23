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


unless File.exists?("/var/www/application/shared/config/database.yml")
  template "/var/www/application/shared/config/database.yml" do
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

unless File.exists?("/var/www/application/shared/config/constants/redis.yml")
  template "/var/www/application/shared/config/constants/redis.yml" do
    source "redis.yml.erb"
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

