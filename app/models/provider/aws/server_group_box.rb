module Provider
  module Aws
    class ServerGroupBox

      def initialize( record, provider )
        @record = record
        @provider = provider
      end

      def exists?
        !@provider.security_groups.get(@record.name).nil?
      end

      def get
        @provider.security_groups.get(@record.name)
      rescue
        nil
      end

      def run_up
        unless exists?
          group = @provider.security_groups.create(
            name: @record.name,
            description: @record.name,
            vpc_id: @record.eco_system.vpc )
          @record.ports.each do |port|
            group.authorize_port_range( port..port, ip_protocol: :tcp )
          end
          group
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