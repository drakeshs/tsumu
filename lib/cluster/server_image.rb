module Cluster
  class ServerImage
    def initialize( name, ec2 )
      @name = name
      @ec2 = ec2
    end

    def get
      @ec2.images[@name]
    end
  end
end