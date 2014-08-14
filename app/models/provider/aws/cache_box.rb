module Provider
  module Aws
    class CacheBox

      def initialize( record, provider )
        @record = record
        @provider = provider
      end

      def get
        @provider.clusters.get(@record.name)
      rescue
        nil
      end

      def exists?
        get.present?
      end

      def run_up
        unless exists?
          cache = @provider.clusters.create({
            id: @record.name,
            nodes: @record.total_nodes,
            node_type: @record.node_type,
            engine: @record.engine,
            port: @record.port,
            # security_groups: [group.id]
          })
          cache.wait_for { sleep(1); ready? }
          cache
        else
          get
        end
      end

      def destroy
        if get && ["available", "failed", "incompatible-parameters", "incompatible-network", "restore-failed"].include?(get.status)
          get.destroy
        end
      end

      # def authorize_group
      #   group.authorize_ec2_group( @stack.cache_group.name )
      # end

    end
  end
end