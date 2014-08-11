module Provider
  module Aws
    class SubnetBox

      def initialize( record, provider )
        @record = record
        @provider = provider
      end

      def exists?
        !@provider.subnets.get(@name).nil?
      end

      def get
        @provider.subnets.get(@name)
      end

      def run_up
        unless exists?
          subnet = @provider.subnets.create(
            vpc_id: @record.vpc_id,
            cidr_block: @record.cidr_block,
            availability_zone: @record.availability_zone
                )
          subnet.wait_for{ sleep(1); ready? }
          subnet
        else
          get
        end
      end


      def destroy
        get.destroy
      end

    end
  end
end