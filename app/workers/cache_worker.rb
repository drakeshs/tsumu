class CacheWorker
  include Sidekiq::Worker

  def perform(server_id, action)
    case action
      when "build"
        server = Cache.find(server_id)
        server.build!
        server.build_job
      when "destroy"
        Cache.find(server_id).destroy!
    end
  end
end