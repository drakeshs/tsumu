
user_name = "deploy"
user_home = "/home/deploy"

user user_name do
  shell "/bin/bash"
  home user_home
end

[
  user_home,
  "#{user_home}/.ssh"
].each do |directory_name|
  directory  directory_name do
    owner user_name
    group user_name
    mode "2775"
    recursive true
  end
end

template "/#{user_home}/.profile" do
  source "users/profile.erb"
  owner user_name
  group user_name
  mode '0600'
  variables :environment => node.environment
end


ssh_keys =  if node.environment == "local"
              data_bag('users').inject([]) do |memory, user|
                user_info = data_bag_item( "users", user )
                memory << user_info["ssh"]["public"]
              end
            else
              data_bag('users').inject([]) do |memory, user|
                user_info = Chef::EncryptedDataBagItem.load( "users", user )
                memory << user_info["ssh"]["public"]
              end
            end


template "#{user_home}/.ssh/authorized_keys" do
  source "authorized_keys.erb"
  owner user_name
  group user_name
  mode "0600"
  variables :ssh_keys => ssh_keys
end


github =  if node.environment == "local"
            data_bag_item('users','github')
          else
            Chef::EncryptedDataBagItem.load( "users", "github" )
          end

template "#{user_home}/.ssh/id_rsa" do
  source "text.erb"
  owner user_name
  group user_name
  mode "0600"
  variables :content => github["ssh"]["key"].join("\n")
end

template "#{user_home}/.ssh/id_rsa.pub" do
  source "text.erb"
  owner user_name
  group user_name
  mode "0755"
  variables :content => github["ssh"]["public"]
end