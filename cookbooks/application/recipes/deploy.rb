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
  end
end


template "/var/www/application/shared/config/unicorn/#{node.chef_environment}.rb" do
  source "unicorn_config.erb"
  owner "deploy"
  group "deploy"
  mode "0755"
  variables :directory => "/var/www/application/current"
end

