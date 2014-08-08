module Provider
  module Aws
    class DbBox

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
            id: @record.name,
            db_name: @record.application.name,
            allocated_storage: @record.allocated_storage,
            flavor_id: @record.flavor_id,
            engine: @record.engine,
            master_username: @record.master_username,
            password: @record.master_user_password,
            port: @record.port,
            multi_az: @record.multi_az,
            publicly_accessible: @record.publicly_accessible,
            # security_group_names: @record.groups
          })
          binding.pry
          server.wait_for { sleep(1); ready? }
          server
        end
      end


    end
  end
end
