Dir[PROJECT_ROOT.join("lib/cluster/*.rb")].each { |file| require file }

module Cluster
  class Base

    attr_accessor :ec2, :environment

    def initialize( environment_name )

      # Replce with an Strategy for multiples providers
      AWS.config({
        :access_key_id => 'AKIAJPPGBVN72RZ4LB5A',
        :secret_access_key => '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',
      })
      @environment = Cluster::Environment.new( name: environment_name )
      @ec2 = AWS::EC2.new
    end

    def applications
      @environment.config["applications"].map do |name, config|
        Cluster::Application.new(
        name: name,
        ec2: @ec2,
        config: config,
        cluster: self
        )
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
      applications.map(&:install)
    end

    def bootstrap(application, server)
      Cluster::Application.new(
        name: application,
        ec2: @ec2,
        config: @environment.config["applications"][application],
        cluster: self
      ).bootstrap(server)
    end

  end
end