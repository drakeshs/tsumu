user "deploy" do
  shell "/bin/bash"
  home "/var/www/application"
end

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





# ssh_keys = data_bag('users').inject([]) do |memory, user|
#   user_info = data_bag_item( "users", user )
#   memory << user_info["ssh"]["public"]
# end

ssh_keys = [Chef::EncryptedDataBagItem.load("users", "josetonyp")["ssh"]["public"]]

template "/var/www/application/.ssh/authorized_keys" do
  source "authorized_keys.erb"
  owner "deploy"
  group "deploy"
  mode "0600"
  variables :ssh_keys => ssh_keys
end

template "/var/www/application/.ssh/id_rsa" do
  source "text.erb"
  owner "deploy"
  group "deploy"
  mode "0600"
  variables :content => Chef::EncryptedDataBagItem.load( "users", "github" )["ssh"]["key"].join("\n")
end

template "/var/www/application/.ssh/id_rsa.pub" do
  source "text.erb"
  owner "deploy"
  group "deploy"
  mode "0755"
  variables :content => Chef::EncryptedDataBagItem.load( "users", "github" )["ssh"]["public"]
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

