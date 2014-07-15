require 'fog'
Dir[PROJECT_ROOT.join("lib/cluster/*.rb")].each { |file| require file }

module Stack
  class Base

    attr_accessor :provider, :environment

    def initialize( environment_name, strategy = :aws )
      @environment = Cluster::Environment.new( name: environment_name )
      provider(strategy)
    end


    def status
      extend Hirb::Console
      p "Security Group for '#{@environment.name}' "
      table(
        group.get,
        fields: [
                  :group_id,
                  :name,
                  :ip_permissions
                ],
        :unicode => true
        )
      p "Database Server for '#{@environment.name}' "
      table( [database.status], :unicode => true )
      p "Servers Applications for '#{@environment.name}' "
      table( applications.map(&:servers_status).flatten, fields: [:application,:name,:id,:status,:ip,:private_ip_address,:dns,:groups ], :unicode => true )
    end

    def create
      group.create
      key_pair.create
      database.create
      # cache.create
      applications.each do |app|
        app.create
      end
    end

    def destroy
      applications.each do |app|
        app.destroy
      end
      database.destroy
      # cache.destroy
      group.destroy if group.get
      key_pair.destroy if key_pair.get
    end


    def applications
      @environment.config["applications"].map do |name, config|
        get_application(name)
      end
    end

    def group
      @group ||= Cluster::Group.new( @environment.group_name, @provider.compute )
    end

    def key_pair
      @key_pair ||= Cluster::KeyPair.new( @environment.group_name, @provider.compute )
    end


    def database
      @database ||= Cluster::Database.new(
          config: @environment.config["database"],
          stack: self,
          provider: @provider.database
        )
    end

    def cache
      @cache ||= Cluster::Cache.new(
          config: @environment.config["cache"],
          stack: self,
          provider: @provider.cache
        )
    end


    private

    def provider(strategy = :aws)
      keys = YAML::load_file(PROJECT_ROOT.join("config/#{strategy}.yml"))[@environment.name]
      keys = Hash[keys.map{ |k, v| ["aws_#{k.to_sym}", v] }]
      @provider = OpenStruct.new({
          compute: Fog::Compute.new( { :provider => strategy.to_s.upcase }.merge( keys )),
          database: Fog::AWS::RDS.new( keys ),
          cache: Fog::AWS::Elasticache.new( keys )
        })
    end

    def get_application(application_name)
      Cluster::Application.new(
        name: application_name,
        provider: @provider.compute,
        config: @environment.config["applications"][application_name],
        stack: self
      )
    end





  end
end