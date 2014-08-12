class EcoSystem
  include Mongoid::Document
  has_many :applications, dependent: :delete, autosave: true, inverse_of: :eco_system
  has_many :key_pairs, dependent: :delete, autosave: true,  inverse_of: :eco_system
  has_many :caches, dependent: :delete, autosave: true,  inverse_of: :eco_system
  has_many :databases, dependent: :delete, autosave: true,  inverse_of: :eco_system
  embeds_one :subnet, inverse_of: :eco_system, class_name: "Subnet", cascade_callbacks: true

  embeds_many :server_groups, inverse_of: :eco_system, class_name: "ServerGroup", cascade_callbacks: true
  embeds_many :cache_groups, inverse_of: :eco_system, class_name: "CacheGroup", cascade_callbacks: true
  embeds_many :database_groups, inverse_of: :eco_system, class_name: "DatabaseGroup", cascade_callbacks: true

  field :name, type: String
  field :provider, type: String
  field :provider_access_id, type: String
  field :provider_access_key, type: String
  field :region, type: String
  field :vpc, type: String
  field :rails_environment, type: String
  field :public_subnet, type: Boolean, default: false

  accepts_nested_attributes_for :subnet
  accepts_nested_attributes_for :server_groups
  accepts_nested_attributes_for :cache_groups
  accepts_nested_attributes_for :database_groups

  rails_admin do
    configure :applications
    edit do
      field :rails_environment, :string
      field :provider, :string
      field :provider_access_id, :string
      field :provider_access_key, :string
      field :region, :string
      field :vpc, :string
      field :subnet
      field :server_groups
      field :cache_groups
      field :database_groups
    end

    list do
      field :name
      field :provider
      field :vpc
      field :subnet do
        pretty_value{ value.box_id }
      end
    end

  end

  def warehouse
    if provider == "aws"
      init_key = { :provider => provider }
      keys = { aws_access_key_id: provider_access_id,
               aws_secret_access_key: provider_access_key,
               region: region }
      @provider = OpenStruct.new({
        compute: Fog::Compute.new( init_key.merge( keys )),
        database: Fog::AWS::RDS.new( keys ),
        cache: Fog::AWS::Elasticache.new( keys ),
        balancer: Fog::AWS::ELB.new( keys ),
        cdn: Fog::CDN.new(init_key.merge( keys ))
      })
    else
      raise "well not developed yet"
    end
  end

  def self.build_subnets
    all.each_with_index do |eco_system, index|
      Subnet.create(
        eco_system: eco_system,
        name: eco_system.name,
        vpc_id: first.vpc ,
        cidr_block: "172.30.#{index+2}.0/24",
        availability_zone: eco_system.region<<"a",
        map_public_ip_on_launch: Rails.env.development?,
        )
    end
  end


  def self.groups
    all.each_with_index do |eco_system, index|
      ServerGroup.create(
        eco_system: eco_system,
        name: "ssh_http_#{eco_system.name}",
        ports: [22,80]
        )
    end
    all.each_with_index do |eco_system, index|
      DatabaseGroup.create(
        eco_system: eco_system,
        name: "mysql_#{eco_system.name}",
        ports: [3306]
        )
    end
    self.not.where(name:"deploy").each_with_index do |eco_system, index|
      CacheGroup.create(
        eco_system: eco_system,
        name: "redis_#{eco_system.name}",
        ports: [10000]
        )
    end
    where(name:"deploy").each_with_index do |eco_system, index|
      CacheGroup.create(
        eco_system: eco_system,
        name: "redis_canonical_#{eco_system.name}",
        ports: [6379]
        )
    end
    EcoSystem.all.map do |es|
      es.server_groups.map(&:build!)
      es.database_groups.map(&:build!)
      es.cache_groups.map(&:build!)
    end
  end

end
