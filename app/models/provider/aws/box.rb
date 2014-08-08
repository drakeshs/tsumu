module Provider
  module Aws
    class Box

      def initialize( record, provider )
        @record = record
        @provider = provider
      end

      def get
        @provider.servers.get(@record.name)
        rescue
        nil
      end

      def exists?
        !get.nil?
      end

      def destroy
        get.destroy
      end

      def run_up
        unless exists?
          server = @provider.servers.new({
            flavor_id: @record.application.safe_flavor,
            image_id: @record.application.safe_image_id,
            vpc_id: @record.eco_system.vpc,
            subnet_id: @record.eco_system.subnet,
            # groups: @groups,
            # key_name: @@record.application.stack.key_pair.get.name,
            tags: { group: @record.application.name, eco_system: @record.eco_system_name  }
            })
          server.save
          server.wait_for { sleep(1); ready? }
          server
        end
      end


    end
  end
end
