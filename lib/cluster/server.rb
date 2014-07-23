module Cluster
  class Server
    attr_accessor :name

    def initialize( args={} )
      @name = args.fetch(:name, "")
      @provider = args.fetch(:provider, "")
      @application = args.fetch(:application, nil)
      @groups =  [ @application.stack.group.get.name ]
    end

    def get
      @provider.servers.all({ "tag:name" => @name, "tag:group" => @application.stack.group.get.name }).select{ |server| ["pending", "running"].include?(server.state) }.first
    end

    def exists?
      return false if @application.stack.group.get.nil?
      @provider.servers.all({ "tag:name" => @name, "tag:group" => @application.stack.group.get.name }).any?{ |server| ["pending", "running"].include?(server.state) }
    end

    def create
      unless exists?
        puts "Creating server #{@name} "
        server = @provider.servers.create({
          flavor_id: @application.config["flavor"],
          image_id: @application.config["image_id"],
          groups: @groups,
          key_name: @application.stack.key_pair.get.name,
          tags: { name: @name, group: @application.stack.group.get.name  }
          })
        puts "Launching #{@name} #{server.id}, status: #{server.state}"
        while server.state == :pending
          puts "."
          sleep 10
        end
        puts "Launched server #{server.id}, status: #{server.state}"
      else
        puts "Server #{get.id} is already running"
      end
    end

    def destroy
      # FIXME Also destroy the chef node
      get.destroy if exists?
    end

    def status
      if exists?
        server = get
        { application: @application.name,
          id: server.id,
          name: server.tags["name"],
          status: server.state ,
          ip: server.public_ip_address ,
          private_ip_address: server.private_ip_address,
          dns: server.dns_name,
          # architecture: server.architecture,
          # flavor: server.flavor,
          # key_name: server.key_name,
          groups: server.groups.join(", ")
        }
      else
        { application: @application.name,
          id: :none,
          name: :none,
          status: :none,
          ip: :none,
          private_ip_address: :none,
          dns: :none,
          # architecture: :none,
          # flavor: :none,
          # key_name: :none,
          groups: :none
        }
      end
    end

    def bootstrap( args = {} )
      require "json"
      attributes={ }
      if (database= args.fetch(:database, false))
        status = database.status
        attributes.merge!({
          "application" => {
            "database" => {
              "host" => status[:dns].to_s,
              "port" => status[:port].to_s,
              "username" => database.config["master_username"],
              "password" => database.config["master_user_password"],
              "database" => status[:db_name].to_s
              }
            }
          })
      end
      attributes = "--json-attributes '#{attributes.to_json}'" if attributes.any?
      system "knife bootstrap #{get.public_ip_address} -x ubuntu -i keys/#{@application.stack.group.get.name}.pem -r 'role[#{@application.name}]' --secret-file .chef/encrypted_data_bag_secret --sudo -E #{@application.stack.environment.name} #{attributes}"
    end

    def add_group( group_name )
      @groups << group_name
    end

  end
end

