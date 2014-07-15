module Cluster
  class Server
    attr_accessor :name

    def initialize( args={} )
      @name = args.fetch(:name, "")
      @provider = args.fetch(:provider, "")
      @application = args.fetch(:application, nil)
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
          image_id: image_id,
          groups: [@application.stack.group.get.name],
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

    def bootstrap
      binding.pry
      system "knife bootstrap #{get.public_ip_address} -x ubuntu -i keys/#{@application.stack.group.get.name}.pem -r 'role[#{@application.name}]' --secret-file .chef/encrypted_data_bag_secret --sudo -E #{@application.stack.environment.name}"
    end

    def image_id
      "ami-018c9568"
    end

  end
end

