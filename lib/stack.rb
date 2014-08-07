require 'fog'
Dir.glob(PROJECT_ROOT.join("lib","stack", "**", "*")).each { |file| require file if File.file?(file) }

module Stack
  class Base
    TEST = false
    attr_accessor :provider, :environment

    def initialize( environment_name, strategy = :aws )
      @environment = Stack::Environment.new( name: environment_name )
      get_provider(strategy)
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
      p "Database Security Group for '#{@environment.name}' "
      table(
        db_group.get,
        fields: [
                  :group_id,
                  :name,
                  :ip_permissions
                ],
        :unicode => true
        )
      p "Cache Security Group for '#{@environment.name}' "
      table(
        cache_group.get,
        fields: [
                  :group_id,
                  :name,
                  :ip_permissions
                ],
        :unicode => true
        )
      p "Database Server for '#{@environment.name}' "
      table( [database.status], :unicode => true )
      p "Cache Server for '#{@environment.name}' "
      table( cache.status, :unicode => true )
      p "Servers Applications for '#{@environment.name}' "
      table( applications.map(&:servers_status).flatten, fields: [:application,:name,:id,:status,:ip,:private_ip_address,:dns,:groups ], :unicode => true )
    end

    def reinstall
      applications.each do |app|
        app.destroy
        app.create
      end
      ensure
        @environment.save
    end


    def applications
      @environment.config["applications"].map do |name, config|
        get_application(name)
      end
    end

    def group
      @group ||= Stack::Group.new( @environment.group_name, @provider.compute, [22,80] )
    end

    def db_group
      @db_group ||= Stack::Group.new( @environment.db_group_name, @provider.compute, [3306] )
    end

    def cache_group
      @cache_group ||= Stack::Group.new( @environment.cache_group_name, @provider.compute, [10000] )
    end

    def key_pair
      @key_pair ||= Stack::KeyPair.new( @environment.group_name, @provider.compute )
    end


    def database
      @database ||= Stack::Database.new(
          config: @environment.config["database"],
          stack: self,
          provider: @provider.database
        )
    end

    def cache
      @cache ||= Stack::Cache.new(
          config: @environment.config["cache"],
          stack: self,
          provider: @provider.cache
        )
    end


    def get_application(application_name)
      Stack::Application.new(
        name: application_name,
        provider: @provider.compute,
        balancer: @provider.balancer,
        cdn: @provider.cdn,
        config: @environment.config["applications"][application_name],
        stack: self
      )
    end

    private

    def get_provider(strategy = :aws)
      keys = YAML::load_file(PROJECT_ROOT.join("config/#{strategy}.yml"))[@environment.name]
      keys = Hash[keys.map{ |k, v| ["aws_#{k.to_sym}", v] }]
      @provider = OpenStruct.new({
          compute: Fog::Compute.new( { :provider => strategy.to_s.upcase }.merge( keys )),
          database: Fog::AWS::RDS.new( keys ),
          cache: Fog::AWS::Elasticache.new( keys ),
          balancer: Fog::AWS::ELB.new( keys ),
          cdn: Fog::CDN.new({ :provider => strategy.to_s.upcase }.merge( keys ))
        })
    end






  end
end