module Cluster
  class Group

    attr_accessor :name

    def initialize( name, provider )
      @name = name
      @provider = provider
    end

    def exists?
      !get.nil?
    end

    def get
      @provider.security_groups.get(@name)
    end

    def create
      unless exists?
        group = @provider.security_groups.create( name: @name, description: @name )
        group.authorize_port_range( 22..22, ip_protocol: :tcp )
        group.authorize_port_range( 80..80, ip_protocol: :tcp )
      end
      get
    end


    def destroy
      get.destroy
    end

  end
end