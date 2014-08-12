module Stack
  class Group

    attr_accessor :name

    def initialize( name, provider, ports=[22] )
      @name = name
      @provider = provider
      @ports = ports
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
        @record.ports.each do |port|
          group.authorize_port_range( port..port, ip_protocol: :tcp )
        end
      end
      get
    end

    def destroy
      get.destroy if exists?
    end

  end
end