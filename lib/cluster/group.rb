module Cluster
  class Group

    attr_accessor :name

    def initialize( name, ec2 )
      @name = name
      @ec2 = ec2
    end

    def exists?
      @ec2.security_groups.any?{|g| g.name == @name}
    end

    def get
      unless exists?
        group = ec2.security_groups.create(@name)
        group.authorize_ingress(:tcp, 22, "0.0.0.0/0")
        group.authorize_ingress(:http, 80, "0.0.0.0/0")
      end
      @ec2.security_groups[@name]
    end
  end
end