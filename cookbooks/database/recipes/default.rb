include_recipe "mysql"
include_recipe "database"

connection_info = { :host => "localhost",
                    :username => 'root',
                    :password => "1234567890"
                  }

mysql_service 'default' do
  version '5.1'
  port '3307'
  data_dir '/data'
  allow_remote_root true
  remove_anonymous_users false
  remove_test_database false
  server_root_password '1234567890'
  server_repl_password '1234567890'
  action :create
end


# mysql_database "stallone" do
#   connection connection_info
#   action :create
# end

# mysql_database_user "stallone" do
#   connection connection_info
#   password "stallone"
#   database_name "stallone"
#   host site["db_host"]
#   privileges [:all]
#   action :create
# end

# mysql_database_user site["db_user"] do
#   connection connection_info
#   database_name site["db_name"]
#   host "localhost"
#   privileges [:all]
#   action :grant
# end