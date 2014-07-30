module Stack
  class Cdn

    attr_accessor :name

    def initialize( args = {} )
      @name = args.fetch( :name, nil)
      @stack = args.fetch( :stack, nil)
      @provider = args.fetch( :provider, nil)
    end

    def get

    end

    def exists?

    end

    def create
      binding.pry
      distribution = @provider.distributions.create( :custom_origin => {
            'DNSName'               => 'www.example.com',
            'OriginProtocolPolicy'  => 'match-viewer'
          }, :enabled => true
      )

      distribution.wait_for { ready? }
    end

    def destroy

    end

    def status

    end



  end
end