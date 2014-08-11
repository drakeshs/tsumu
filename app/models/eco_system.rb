class EcoSystem
  include Mongoid::Document
  has_many :applications, dependent: :delete, autosave: true, inverse_of: :eco_system
  has_many :key_pairs, dependent: :delete, autosave: true,  inverse_of: :eco_system
  has_many :caches, dependent: :delete, autosave: true,  inverse_of: :eco_system
  has_many :databases, dependent: :delete, autosave: true,  inverse_of: :eco_system

  field :name, type: String
  field :provider, type: String
  field :provider_access_id, type: String
  field :provider_access_key, type: String
  field :aws_region, type: String
  field :aws_zone, type: String
  field :region, type: String
  field :vpc, type: String
  field :subnet, type: String


  rails_admin do
    configure :applications
    edit do
      field :provider, :string
      field :provider_access_id, :string
      field :provider_access_key, :string
      field :aws_region, :string
      field :aws_zone, :string
      field :vpc, :string
      field :subnet, :string
    end

    list do
      field :name
      field :provider
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

  def self.subnets
    all.each_with_index do |eco_system, index|
      subnet = eco_system.warehouse.compute.subnets.create(
                  vpc_id:eco_system.warehouse.compute.vpcs.first.id,
                  cidr_block:"172.30.#{index}.0/24",
                  availability_zone: "us-east-1a",
                  tag_set: {name: eco_system.name},
                  map_public_ip_on_launch: Rails.env.development?
                  )
      eco_system.subnet = subnet.subnet_id
      eco_system.vpc = eco_system.warehouse.compute.vpcs.first.id
      eco_system.save
    end
  end

end
