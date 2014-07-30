module Stack
  class Cache

    attr_accessor :name

    def initialize( args = {} )
      @config = args.fetch( :config, nil)
      @stack = args.fetch( :stack, nil)
      @provider = args.fetch( :provider, nil)
    end

    def get
      @provider.clusters.get(@config["name"])
    end

    def exists?
      !@provider.clusters.get(@config["name"]).nil?
    end

    def create
      if !exists? && !@stack.cache_group.get.nil?
        puts "Creating Cache #{@config["name"]} in #{@config["engine"]} for #{@stack.environment.name}"
        unless group
          create_group
          authorize_group
        end
        @provider.clusters.create({
          id: @config["name"],
          nodes: @config["nodes"],
          node_type: @config["node_type"],
          engine: @config["engine"],
          port: @config["port"],
          security_groups: [group.id]
        })
        # stop untill ready
      else
        puts "Cache #{@config["name"]} in #{@config["engine"]} for #{@stack.environment.name} already exists"
      end
    end

    def group
      @provider.security_groups.get( @stack.cache_group.name )
    end

    def create_group
      unless group
        @provider.security_groups.create( id: @stack.cache_group.name, description: @stack.cache_group.name )
      end
    end

    def destroy
      if get && ["available", "failed", "incompatible-parameters", "incompatible-network", "restore-failed"].include?(get.status)
        get.destroy
        group.destroy
      end
      rescue
    end

    def authorize_group
      group.authorize_ec2_group( @stack.cache_group.name )
    end

    def status
      if exists?
        server = get
        server.nodes.map do |node|
          {
            id: server.id,
            status: server.status,
            node: node["CacheNodeId"],
            node_status: node["CacheNodeStatus"],
            port: node["Port"],
            address: node["Address"]
          }
        end
      else
        [{
          id: :none,
          status: :none,
          node: :none,
          node_status: :none,
          port: :none,
          address: :none
        }]
      end
    end

  end
end