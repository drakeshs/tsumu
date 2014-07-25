# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  stack = Stack::Base.new( "staging" )

  status = stack.database.status

  send_event('database_server', status )


  status = stack.cache.status
  send_event('cache_server', { cache_nodes: status })

  send_event('application_server_stallone', application_status( stack , "stallone" ))

  send_event('application_server_ottweb', application_status( stack , "ottweb" ))

end


def application_status( stack , name )
  app = stack.get_application(name)
  status = app.servers_status
  load_balancer = app.load_balancer.nil? ? false : app.load_balancer.get.dns_name
  { environment: stack.environment.name , load_balancer: load_balancer, application_nodes: status }
end