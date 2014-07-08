include_recipe "nginx"

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action   :stop
end

template "/etc/nginx/sites-available/application" do
  source "nginx.erb"
  mode 0750
  owner "root"
  group "root"
  variables({
    subdomain: "staging"
  })
end

nginx_site 'application' do
  enable true
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action   :start
end