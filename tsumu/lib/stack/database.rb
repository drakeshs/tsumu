

module Stack
  class Database

    attr_accessor :name, :config

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
      if !exists? && !@stack.db_group.get.nil?
        puts  "Creating DB #{@config["name"]} for #{@stack.environment.name}"
        unless group
          create_group
          authorize_group
        end
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
          publicly_accessible: @config["publicly_accessible"],
          security_group_names: [group.id]
        })
        sleep(1) while status[:status] != "available"
        puts  "DB Created #{@config["name"]} for #{@stack.environment.name}!"
        get
      else
        puts  "DB #{@config["name"]} for #{@stack.environment.name} exists"
      end
    end

    def destroy
      puts "Destroy Database"
      get.destroy unless get(true).nil?
      sleep(3) while !get(true).nil?
      group.destroy if group
    end

    # Use DB gruop name
    def group
      @provider.security_groups.get( @stack.db_group.name )
    end

    def create_group
      unless group
        @provider.security_groups.create( id: @stack.db_group.name, description: @stack.db_group.name )
      end
    end

    def authorize_group
      group.authorize_ec2_security_group( @stack.db_group.name )
    end

    def status
      if exists?
        server = get(true)
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