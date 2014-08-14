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
        get.present?
      end

      def destroy
        get.destroy
      end

      def run_up
        unless exists?
          unless group
            create_group
            authorize_group
          end
          server = @provider.servers.create({
            id: @record.name,
            db_name: @record.database_name,
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
          server.wait_for { sleep(1); ready? }
          server
        else
          get
        end
      end

      def group
        @provider.security_groups.get( "#{@record.name}_group" )
      end

      def create_group
        unless group
          @provider.security_groups.create( id: "#{@record.name}_group", description: "#{@record.name}_group" )
        end
      end

      def authorize_group
        group.authorize_ec2_security_group( @record.eco_system.cache_groups.first.name )
      end

    end
  end
end
