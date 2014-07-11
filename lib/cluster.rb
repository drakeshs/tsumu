Dir[PROJECT_ROOT.join("lib/cluster/*.rb")].each { |file| require file }

module Cluster
  class Base

    attr_accessor :ec2, :environment, :database, :cache

    def initialize( environment_name )

      # Replce with an Strategy for multiples providers
      AWS.config({
        :access_key_id => 'AKIAJPPGBVN72RZ4LB5A',
        :secret_access_key => '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',
      })
      @environment = Cluster::Environment.new( name: environment_name )
      @ec2 = AWS::EC2.new
      @cache = @environment.config["database"].any? ? AWS::ElastiCache.new : nil
      @database = @environment.config["cache"].any? ? AWS::RDS.new : nil
    end

    def applications
      @environment.config["applications"].map do |name, config|
        get_application(name)
      end
    end

    def status
      extend Hirb::Console
      p "Servers for '#{@environment.name}' "
      table(
        applications.map(&:servers_status).flatten,
        fields: [
                  :name,
                  :architecture,
                  :status,
                  :ip,
                  :private_ip_address,
                  :dns
                ],
        :unicode => true
        )
    end

    def create
      if @cache
        cache = Cluster::Cache.new(
          config: @environment.config["cache"],
          cluster: self
        )
        cache.create
      end
      if @database
        db = Cluster::Database.new(
          config: @environment.config["database"],
          cluster: self
        )
        db.create
      end
      applications.map(&:install)
    end

    def bootstrap(application_name, server)
      get_application(application_name).bootstrap(server)
    end


    private

    def get_application(application_name)
      Cluster::Application.new(
        name: application_name,
        ec2: @ec2,
        config: @environment.config["applications"][application_name],
        cluster: self
      )
    end

    def group
      Cluster::Group.new( environment.group_name, @ec2 ).get
    end

    def key_pair
      Cluster::KeyPair.new( environment.group_name, @ec2 ).get
    end




  end
end