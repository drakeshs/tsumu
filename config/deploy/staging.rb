# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{deploy@54.164.37.110}
role :web, %w{deploy@54.164.37.110}
role :db,  %w{deploy@54.164.37.110}

set :branch, "master"
set :rails_env, 'staging'

server '54.164.37.110', user: 'deploy', roles: %w{web app}