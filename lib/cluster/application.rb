module Cluster
  class Application

    attr_accessor :config, :name, :stack

    def initialize( args = {} )
      @name = args.fetch(:name, nil)
      @provider = args.fetch(:provider, nil)
      @config = args.fetch(:config, {})
      @stack = args.fetch(:stack, {})
    end

    def servers
      @config["servers"].times.map do |i|
        server( @name+"_"+(i+1).to_s )
      end
    end

    def create
      servers.each do |server|
        server.create
      end
    end

    def destroy
      servers.each do |server|
        server.destroy
      end
    end

    def bootstrap(server)
      server(name).bootstrap
    end

    def servers_status
      servers.map &:status
    end


    private

    def server_config
      {
        provider: @provider,
        application: self
      }
    end

    def server(name)
      Cluster::Server.new( {name: name}.merge(server_config) )
    end

  end
end
