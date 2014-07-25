module Cluster
  class LoadBalancer

    attr_accessor :name

    def initialize( args = {} )
      @name = args.fetch( :name, nil)
      @stack = args.fetch( :stack, nil)
      @balancer = args.fetch( :balancer, nil)
    end

    def get
      @balancer.load_balancers.get(@name)
    end

    def exists?
      !get.nil?
    end


    def create
      @balancer.load_balancers.create({
        security_groups:[@stack.group.get.name],
        id: @name,
        availability_zones: ["us-east-1a", "us-east-1b", "us-east-1d"]
        })
      get
    end

    def destroy
      get.destroy
    end

    def status
      if exists?
        server = get
        {
          name: server.id,
          dns: server.dns_name,
          instances: server.instances,
          security_groups: server.security_groups
        }
      else
        {
          name: :none,
          dns: :none,
          instances: :none,
          security_groups: :none
        }
      end
    end

    def add_instance( instance_id )
      get.register_instances(instance_id)
    end

    def add_security_group( gruop_name )
      balancer = get
      balancer.security_groups << gruop_name
      balancer.save
    end

  end
end