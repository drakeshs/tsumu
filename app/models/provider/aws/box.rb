module Provider
  module Aws
    class Box

      def initialize( record, provider )
        @record = record
        @provider = provider
      end

      def get
        @provider.servers.get(@id)
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
          server = @provider.servers.create({
            flavor_id: @record.application.safe_flavor,
            image_id: @record.application.safe_image_id,
            # groups: @groups,
            # key_name: @@record.application.stack.key_pair.get.name,
            tags: { name: @name, group: @record.application.name, eco_system: @record.eco_system_name  }
            })
          server.wait_for { sleep(1); ready? }
        end
      end


    end
  end
end
