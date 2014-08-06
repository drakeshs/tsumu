node.default['jenkins']['master']['install_method'] = 'package'
include_recipe "jenkins::master"


jenkins_plugin 'git'
jenkins_plugin 'github'

jenkins_command 'safe-restart'