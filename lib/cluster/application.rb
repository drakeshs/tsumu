module Cluster
  class Application

    attr_accessor :config, :name, :stack

    def initialize( args = {} )
      @name = args.fetch(:name, nil)
      @provider = args.fetch(:provider, nil)
      @balancer = args.fetch(:balancer, nil)
      @config = args.fetch(:config, {})
      @stack = args.fetch(:stack, {})
    end

    def servers
      @config["servers"].times.map do |i|
        get_server( @name+"_"+(i+1).to_s )
      end
    end

    def create
      puts "Creating servers for application #{@name}"
      if !load_balancer.exists? && @config["servers"].to_i > 1
        load_balancer.create
        load_balancer.add_security_group(@stack.group.get.name)
      end
      servers.inject([]) do |threads,server|
        threads << Thread.new do
          unless server.exists?
            server.add_group( @stack.db_group.get.name ) if @config["database"]
            server.add_group( @stack.cache_group.get.name ) if @config["cache"]
            server.create
            sleep(1) while server.status[:status] != "running"
            load_balancer.add_instance( server.get.id ) if @config["servers"].to_i > 1
          end
        end
      end.map(&:join)
    end

    def destroy
      servers.inject([]) do |threads,server|
        threads << Thread.new do
          if server.exists?
            server.destroy
            sleep(1) while server.status[:status] != :none
          end
        end
      end.map(&:join)
      load_balancer.destroy if load_balancer.exists?
    end

    def bootstrap(server = nil )
      raise "==>  Database Server is not ready" if @config["database"] && !@stack.database.exists?
      raise "==>  Cache Server is not ready" if @config["cache"] && !@stack.cache.exists?
      args = {}
      args[:database] = @stack.database if @config["database"]
      args[:cache] = @stack.cache if @config["cache"]
      if server.nil?
        servers.inject([]) do |threads,i_server|
          threads << Thread.new do
            i_server.bootstrap( args )
          end
        end.map(&:join)
      else
        get_server(server).bootstrap( args )
      end
    end

    def servers_status
      servers.map &:status
    end

    def ready?
      servers_status.none?{|s| s[:status] != "running" }
    end

    def load_balancer
      @load_balancer ||= Cluster::LoadBalancer.new( name: @name, stack: @stack, balancer: @balancer )
    end

    # def assets_volume
    #   @provider.volumes.create( device: "/dev/sda1", size: 8 , availability_zone: "us-east-1a" )
    # end

    private

    def server_config
      {
        provider: @provider,
        application: self
      }
    end

    def get_server(name)
      Cluster::Server.new( {name: name}.merge(server_config) )
    end

  end
end
