
directory "/var/www/application" do
  owner "deploy"
  group "deploy"
  mode "2775"
  recursive true
end

user "deploy" do
  shell "/bin/bash"
  home "/var/www/application"
end

directory "/var/www/application/.ssh" do
  owner "root"
  group "root"
  mode "2755"
  recursive true
end

# ssh_keys = data_bag('users').inject([]) do |memory, user|
#   user_info = data_bag_item( "users", user )
#   memory << user_info["ssh"]["public"]
# end

ssh_keys = [Chef::EncryptedDataBagItem.load("users", "josetonyp")["ssh"]["pub"]]

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
  variables :content => Chef::EncryptedDataBagItem.load( "users", "github" )["ssh"]["key"]
end

template "/var/www/application/.ssh/id_rsa.pub" do
  source "text.erb"
  owner "deploy"
  group "deploy"
  mode "0755"
  variables :content => Chef::EncryptedDataBagItem.load( "users", "github" )["ssh"]["public"]
end

directory "/var/www/application/shared/config/unicorn" do
  owner "deploy"
  group "deploy"
  mode "2775"
  recursive true
end

unless File.exists?("/var/www/application/shared/config/database.yml")
  template "/var/www/application/shared/config/database.yml" do
    source "database.yml.erb"
    owner "deploy"
    group "deploy"
    mode "0755"
  end
end


template "/var/www/application/shared/config/unicorn/config.rb" do
  source "unicorn_config.erb"
  owner "deploy"
  group "deploy"
  mode "0755"
  variables :directory => "/var/www/application/current"
end

directory "/var/www/application/log/nginx" do
  owner "deploy"
  group "deploy"
  mode "2775"
  recursive true
end

