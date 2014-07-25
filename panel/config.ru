PROJECT_ROOT = Pathname.new( __dir__ ).join("..")
require PROJECT_ROOT.join("lib/stack.rb")
require "pry"
require 'dashing'

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

get '/:environment/bootstrap/:application' do
  stack = Stack::Base.new( params[:environment] )
  stack.bootstrap(  params[:application] )
end

run Sinatra::Application