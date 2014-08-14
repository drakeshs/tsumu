class DatabaseWorker
  include Sidekiq::Worker

  def perform(server_id, action)
    case action
      when "build"
        server = Database.find(server_id)
        server.build!
        server.build_job
      when "destroy"
        Database.find(server_id).destroy!
    end
  end
end