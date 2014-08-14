class EcoSystem
  module Components
    class Factory

      def initialize( eco_system )
        @eco_system = eco_system
      end

      def create( instance_type, attributes={} )
        raise "Unsupported factory for #{instance_type}" unless [:database, :cache].include?(instance_type)
        instance = Object.const_get( instance_type.to_s.capitalize ).new
        instance.eco_system = @eco_system
        instance.attributes = preload_config( instance_type ).merge( attributes )
        instance.name = "#{instance.engine}-#{@eco_system.name}"
        instance.attributes = attributes
        instance.save
        instance
      end

      private

        def preload_config( instance_type )
          YAML::load_file(Rails.root.join("config/stack.yml"))["preload_config"][instance_type.to_s]
        end

    end
  end
end