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
      puts "Creating servers for application #{@name}"
      servers.inject([]) do |threads,server|
        threads << Thread.new do
          server.add_group( @stack.db_group.get.name ) if config["database"]
          server.add_group( @stack.cache_group.get.name ) if config["cache"]
          server.create unless server.exists?
          sleep(1) while server.status[:status] != "running"
        end
      end.map(&:join)
    end

    def destroy
      servers.inject([]) do |threads,server|
        threads << Thread.new do
          server.destroy
          sleep(1) while server.status[:status] != :none
        end
      end.map(&:join)
    end

    def bootstrap(server)
      raise "==>  Database Server is not ready" if @config["database"] && !@stack.database.exists?
      args = {}
      args[:database] = @stack.database if @config["database"]
      server(server).bootstrap( args )
    end

    def servers_status
      servers.map &:status
    end

    def ready?
      servers_status.none?{|s| s[:status] != "running" }
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
