module Cluster
  class Server
    attr_accessor :name

    def initialize( args={} )
      @name = args.fetch(:name, "")
      @ec2 = args.fetch(:ec2, "")
      @group = args.fetch(:group, nil)
      @status = ""
      @key_pair = args.fetch(:key_pair, nil)
      @application = args.fetch(:application, nil)
    end

    def get
      @server ||= @ec2.instances.with_tag("name", @name).with_tag("group", @group.id ).select{|server| server.status != :terminated}.first
    end

    def exists?
      @ec2.instances.with_tag("name", @name).with_tag("group", @group.id ).any?{|server| server.status != :terminated}
    end

    def create
      unless exists?
        puts "Creating instance #{@name} "
        instance = image.run_instance(:key_pair => @key_pair,
                                      :security_groups => @group)
        puts "Launching #{@name} #{instance.id}, status: #{instance.status}"
        while instance.status == :pending
          puts "."
          sleep 10
        end
        puts "Launched instance #{instance.id}, status: #{instance.status}"
        instance.tag("name", value: @name)
        instance.tag("group", value: @group.id)
      end
    end

    def delete

    end

    def status

    end

    def bootstrap
      system "knife bootstrap #{get.public_ip_address} -x ubuntu -i keys/#{@group.id}.pem -r 'role[#{@application.name}]' --secret-file .chef/encrypted_data_bag_secret --sudo -E #{@application.cluster.environment.name}"
    end

    def image
      Cluster::ServerImage.new("ami-018c9568", @ec2).get
    end

  end
end

