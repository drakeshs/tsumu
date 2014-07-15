module Cluster
  class Database

    attr_accessor :name

    def initialize( args = {} )
      @config = args.fetch( :config, nil)
      @stack = args.fetch( :stack, nil)
      @provider = args.fetch( :provider, nil)
    end

    def exists?
      @provider.servers.get(@config["name"])
    end

    def get( force = false )
      unless force
        @server ||= @provider.servers.get(@config["name"])
      else
        @server = @provider.servers.get(@config["name"])
      end
    end

    def create
      if !exists? && !@stack.group.get.nil?
        puts  "Creating DB #{@config["name"]} for #{@stack.environment.name}"
        create_group
        authorize_group
        binding.pry
        @provider.servers.create({
          id: @config["name"],
          db_name: @config["database"],
          allocated_storage: @config["allocated_storage"],
          flavor_id: @config["db_instance_class"],
          engine: @config["engine"],
          master_username: @config["master_username"],
          password: @config["master_user_password"],
          port: @config["port"],
          multi_az: @config["multi_az"],
          publicly_accessible: @config["publicly_accessible"]
        })
        get
      else
        puts  "DB #{@config["name"]} for #{@stack.environment.name} exists"
      end
    end

    def destroy
      group.destroy if group
      get.destroy if get(true) && get.state != "deleting"
    end

    def group
      @provider.security_groups.get( @stack.group.name )
    end

    def create_group
      unless group
        @provider.security_groups.create( id: @stack.group.name, description: @stack.group.name )
      end
    end

    def authorize_group
      group.authorize_ec2_security_group( @stack.group.name )
    end

    def status
      if exists?
        server = get
        {
          status: server.state,
          db_name: server.db_name,
          port: server.endpoint["Port"],
          dns: server.endpoint["Address"]
        }
      else
        {
          status: :none,
          db_name: :none,
          port: :none,
          dns: :none
        }
      end
    end

  end
end