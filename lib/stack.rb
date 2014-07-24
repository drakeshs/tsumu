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

    def create
      group.create unless group.exists?
      db_group.create unless db_group.exists?
      cache_group.create unless cache_group.exists?
      key_pair.create unless key_pair.exists?
      database.create unless database.exists?
      cache.create unless cache.exists?
      applications.inject([]) do |threads,application|
        threads << Thread.new do
          application.create
          sleep(1) while !application.ready?
        end
      end.map(&:join)
      puts "Application created... enjoy"
    end

    def reinstall
      applications.each do |app|
        app.destroy
        app.create
      end
    end


    def destroy
      applications.each do |app|
        app.destroy
      end
      database.destroy
      cache.destroy
      group.destroy if group.exists?
      db_group.create if db_group.exists?
      cache_group.create if cache_group.exists?
      key_pair.destroy if key_pair.exists?
      puts "Application destroyed... :( come back soon"
    end


    def applications
      @environment.config["applications"].map do |name, config|
        get_application(name)
      end
    end

    def bootstrap(application_name, server)
      get_application(application_name).bootstrap(server)
    end

    def group
      @group ||= Cluster::Group.new( @environment.group_name, @provider.compute, [22,80] )
    end

    def db_group
      @db_group ||= Cluster::Group.new( @environment.db_group_name, @provider.compute, [3306] )
    end

    def cache_group
      @cache_group ||= Cluster::Group.new( @environment.cache_group_name, @provider.compute, [10000] )
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


    def get_application(application_name)
      Cluster::Application.new(
        name: application_name,
        provider: @provider.compute,
        config: @environment.config["applications"][application_name],
        stack: self
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






  end
end