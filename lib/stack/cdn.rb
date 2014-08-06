module Stack
  class Cdn

    attr_reader :name

    def initialize( args = {} )
      @name = args.fetch( :name, nil)
      @application = args.fetch( :application, nil)
      @provider = args.fetch( :provider, nil)
    end

    def get
      @provider.distributions.select{ |cdn| cdn.custom_origin["DNSName"] == @application.load_balancer.status[:dns] }.first
    end

    def exists?
      @provider.distributions.select{ |cdn| cdn.custom_origin["DNSName"] == @application.load_balancer.status[:dns] }.count > 0
    end

    def create
      unless exists?
        cdn = @provider.distributions.new(
          :custom_origin => {
            'DNSName'               => @application.load_balancer.status[:dns],
            'OriginProtocolPolicy'  => 'http-only'
          },
          :enabled => true
        )
        cdn.wait_for { ready? }
      end
      get
    end

    def destroy
      get.destroy
    end

    def status
      get.status
    end

  end
end