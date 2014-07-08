#
# Cookbook Name:: application
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "system"
include_recipe "application::deploy"
include_recipe "application::ruby"
include_recipe "application::nginx"

package "mysql-client"
package "libmysql-ruby"
package "libmysqlclient-dev"
package "nodejs"