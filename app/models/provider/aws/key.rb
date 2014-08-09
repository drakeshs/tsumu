module Provider
  module Aws
    class Key

      def initialize( record, provider )
        @record = record
        @name = "#{@record.eco_system.name}-dish-network"
        @provider = provider
      end

      def exists?
        !@provider.key_pairs.get(@name).nil?
      end

      def get
        @provider.key_pairs.get(@name)
      end

      def run_up
        unless exists?
          key_pair = @provider.key_pairs.create( name: @name )
          File.open(Rails.root.join("keys/#{@name}.pem"), "w") do |file|
            file << key_pair.private_key
          end
          File.chmod(0644, Rails.root.join("keys/#{@name}.pem"))
          key_pair
        else
          get
        end
      end


      def destroy
        File.delete(Rails.root.join("keys/#{@name}.pem"))
        get.destroy
      end

    end
  end
end