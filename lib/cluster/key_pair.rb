module Cluster
  class KeyPair
    def initialize( name, ec2 )
      @name = name
      @ec2 = ec2
    end

    def exists?
      @ec2.key_pairs[@name].exists?
    end

    def get
      unless @ec2.key_pairs[@name].exists?
        key_pair = @ec2.key_pairs.create(@name)
        File.open(PROJECT_ROOT.join("keys/#{@name}.pem"), "w") do |file|
          file << key_pair.private_key
        end
      end
      @ec2.key_pairs[@name]
    end
  end
end