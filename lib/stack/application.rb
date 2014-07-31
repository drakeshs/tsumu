module Stack
  class Application

    attr_accessor :config, :name, :stack, :servers, :load_balancer

    def initialize( args = {} )
      @name = args.fetch(:name, nil)
      @provider = args.fetch(:provider, nil)
      @balancer = args.fetch(:balancer, nil)
      @cdn = args.fetch(:cdn, nil)
      @config = Config.new( args.fetch(:config, {}) )
      @stack = args.fetch(:stack, {})
    end

    def servers
      @config["servers"].times.map do |i|
        get_server( @name+"_"+(i+1).to_s )
      end
    end

    def balanced?
      @config.balanced?
    end


    def database?
      raise "==>  Database Server is not ready" if @config.database? && !@stack.database.exists?
      @config.database?
    end

    def cache?
      raise "==>  Cache Server is not ready" if @config.cache? && !@stack.cache.exists?
      @config.cache?
    end

    def build
      Stack::Scripts::ApplicationBuilder.new(self)
    end

    def destroy
      Stack::Scripts::ApplicationDestroyer.new(self)
    end

    def bootstrap()
      args = {}
      args[:database] = @stack.database if database?
      args[:cache] = @stack.cache if cache?
      servers.inject([]) do |threads,i_server|
        threads << Thread.new do
          p "Bootstrapping #{i_server.name} for application #{@name}"
          i_server.bootstrap( args )
        end
      end.map(&:join)
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

      class Config

        extend Forwardable

        def_delegator :@config, :[]

        def initialize(config)
          @config = config
        end

        def balanced?
          @config["servers"].to_i > 1
        end

        def database?
          @config.has_key?("database") && @config["database"]
        end

        def cache?
          @config.has_key?("cache") && @config["cache"]
        end

        def cdn?
          @config.has_key?("cdn") && @config["cdn"]
        end

      end
  end
end
