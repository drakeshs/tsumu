module Stack
  class Application

    attr_accessor :config, :name, :stack, :servers, :load_balancer

    def initialize( args = {} )
      @name = args.fetch(:name, nil)
      @provider = args.fetch(:provider, nil)
      @balancer = args.fetch(:balancer, nil)
      @cdn = args.fetch(:cdn, nil)
      @config = args.fetch(:config, {})
      @stack = args.fetch(:stack, {})
    end

    def servers
      @config["servers"].times.map do |i|
        get_server( @name+"_"+(i+1).to_s )
      end
    end

    def balanced?
      @config["servers"].to_i > 1
    end

    def build
      Stack::Scripts::ApplicationBuilder.new(self)
    end

    def destroy
      Stack::Scripts::ApplicationDestroyer.new(self)
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
      servers.map(&:status)
    end

    def ready?
      servers_status.none?{|s| s[:status] != "running" }
    end

    def load_balancer
      @load_balancer ||= Stack::LoadBalancer.new( name: @name, stack: @stack, balancer: @balancer )
    end

    def cdn
      @cdn ||= Stack::Cdn.new( name: @name, stack: @stack, provider: @cdn )
    end

    private

      def server_config
        {
          provider: @provider,
          application: self
        }
      end

      def get_server(name)
        Stack::Server.new( {name: name}.merge(server_config) )
      end

  end
end
