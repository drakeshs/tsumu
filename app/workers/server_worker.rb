# app/workers/hard_worker.rb
class ServerWorker
  include Sidekiq::Worker

  def perform(server_id, action)
    case action
      when "build"
        Server.find(server_id).build!
      when "bootstrap"
        server = Server.find(server_id)
        server.bootstrap!
        server.bootstrap_job
      when "provision"
        Server.find(server_id).provision!
      when "destroy"
        Server.find(server_id).destroy!
    end
  end
end