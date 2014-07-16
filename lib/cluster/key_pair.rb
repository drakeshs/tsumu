module Cluster
  class KeyPair
    def initialize( name, provider )
      @name = name
      @provider = provider
    end

    def exists?
      !@provider.key_pairs.get(@name).nil?
    end

    def get
      @provider.key_pairs.get(@name)
    end

    def create
      unless exists?
        key_pair = @provider.key_pairs.create( name: @name )
        File.open(PROJECT_ROOT.join("keys/#{@name}.pem"), "w") do |file|
          file << key_pair.private_key
        end
        File.chmod(0644, PROJECT_ROOT.join("keys/#{@name}.pem"))
      end
      get
    end


    def destroy
      get.destroy
      File.delete(PROJECT_ROOT.join("keys/#{@name}.pem"))
    end

    def status

    end
  end
end