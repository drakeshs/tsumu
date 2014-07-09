#
# Cookbook Name:: system
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
template "/etc/environment" do
  source "text.erb"
  owner "root"
  group "root"
  mode "0755"
  variables content: "LC_ALL=en_US.UTF-8\nLANG=en_US.UTF-8\n"
end

include_recipe "apt"

package "aptitude"
package "build-essential"
package "libreadline6-dev"
package "libyaml-dev"
package "libsqlite3-dev"
package "sqlite3"
package "libxml2-dev"
package "libxslt1-dev"
package "autoconf"
package "libgdbm-dev"
package "libncurses5-dev"
package "automake"
package "libtool"
package "bison"
package "pkg-config"
package "libffi-dev"
package 'vim-nox'
package 'nmap'
package 'htop'
package 'tree'
package 'telnet'
package 'pv'
package 'screen'
package 'git-core'
package 'seek'




