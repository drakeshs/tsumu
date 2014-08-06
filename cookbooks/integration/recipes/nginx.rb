include_recipe "nginx"

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action   :stop
end

template "/etc/nginx/sites-available/integration" do
  source "nginx.erb"
  mode 0750
  owner "root"
  group "root"
end

nginx_site 'integration' do
  enable true
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action   :start
end