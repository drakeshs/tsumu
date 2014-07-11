module Cluster
  class Application

    attr_accessor :ec2, :cluster, :config, :name

    def initialize( args = {} )
      @name = args.fetch(:name, nil)
      @ec2 = args.fetch(:ec2, nil)
      @config = args.fetch(:config, {})
      @cluster = args.fetch(:cluster, {})
    end

    def servers
      @config["servers"].times.map do |i|
        server( @name+"_"+(i+1).to_s )
      end
    end

    def servers_status
      servers.map do |server|
        if server.exists?
          { name: server.name,
            status: server.get.status ,
            ip: server.get.public_ip_address ,
            private_ip_address: server.get.private_ip_address,
            dns: server.get.dns_name,
            architecture: server.get.architecture,
          }
        else
          { name: server.name,
            status: :none,
            ip: :none,
            private_ip_address: :none,
            dns: :none,
            architecture: :none
          }
        end
      end
    end


    def install
      servers.each do |server|
        server.create
      end
    end

    def bootstrap(server)
      Cluster::Server.new( {name: server}.merge(server_config) ).bootstrap
    end

    private

    def server_config
      {
        ec2: @ec2,
        group: @cluster.group,
        key_pair: @cluster.key_pair,
        application: self
      }
    end

    def server(name)
      Cluster::Server.new( {name: name}.merge(server_config) )
    end

  end
end
