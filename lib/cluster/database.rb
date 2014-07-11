module Cluster
  class Database

    attr_accessor :name

    def initialize( args = {} )
      @config = args.fetch( :config, nil)
      @cluster = args.fetch( :cluster, nil)
      @provider = @cluster.database
    end

    def exists?
      @provider.db_instances[@config["name"]].exists?
    end

    def get
      @provider.db_instances[@config["name"]]
    end

    def create
      # Añadir el security group de EC2 al grupo de RDS
      unless exists?
        puts  "Creating DB #{@config["name"]} for #{@cluster.environment.name}"
        @provider.client.create_db_instance({
          db_instance_identifier: @config["name"],
          db_name: @config["database"],
          allocated_storage: @config["allocated_storage"],
          db_instance_class: @config["db_instance_class"],
          engine: @config["engine"],
          master_username: @config["master_username"],
          master_user_password: @config["master_user_password"],
          db_security_groups: @config["db_security_groups"],
          port: @config["port"],
          multi_az: @config["multi_az"],
          publicly_accessible: @config["publicly_accessible"]
        })
      else
        puts  "DB #{@config["name"]} for #{@cluster.environment.name} exists"
      end
    end



  end
end