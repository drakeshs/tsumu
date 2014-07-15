module Cluster
  class Cache

    attr_accessor :name

    def initialize( args = {} )
      @config = args.fetch( :config, nil)
      @stack = args.fetch( :stack, nil)
      @provider = args.fetch( :provider, nil)
    end

    def exists?
      begin
        @provider.client.describe_cache_clusters({
          cache_cluster_id: @config["name"],
          show_cache_node_info: true
          })
      rescue
        false
      end
    end

    def get
      begin
        @provider.client.describe_cache_clusters({
          cache_cluster_id: @config["name"],
          show_cache_node_info: true
          })
      rescue
        {}
      end
    end

    def create
      unless exists?
        puts "Creating Cache #{@config["name"]} in #{@config["engine"]} for #{@stack.environment.name}"
        security_group
        @provider.client.create_cache_cluster({
                  cache_cluster_id: @config["name"],
                  num_cache_nodes: @config["nodes"],
                  cache_node_type: @config["node_type"],
                  engine: @config["engine"],
                  port: @config["port"],
                  cache_security_group_names: [@config["name"]]
                })
      else
        puts "Cache #{@config["name"]} in #{@config["engine"]} for #{@stack.environment.name} already exists"
      end
    end

    def security_group
      begin
        @provider.client.describe_cache_security_groups( cache_security_group_name: @config["name"] )
      rescue
        @provider.client.create_cache_security_group({
          cache_security_group_name: @config["name"],
          description: "Security group #{@config["name"]} for #{@stack.environment.name}"
          })
      end
    end


    def status
      pry
    end

  end
end