class EcoSystem
  include Mongoid::Document
  has_many :applications, dependent: :delete, autosave: true, inverse_of: :eco_system
  has_many :key_pairs, dependent: :delete, autosave: true,  inverse_of: :eco_system
  has_many :caches, dependent: :delete, autosave: true,  inverse_of: :eco_system
  has_many :databases, dependent: :delete, autosave: true,  inverse_of: :eco_system
  embeds_one :subnet, inverse_of: :eco_system, class_name: "Subnet", cascade_callbacks: true

  field :name, type: String
  field :provider, type: String
  field :provider_access_id, type: String
  field :provider_access_key, type: String
  field :region, type: String
  field :vpc, type: String
  field :public_subnet, type: Boolean, default: false

  accepts_nested_attributes_for :subnet

  rails_admin do
    configure :applications
    edit do
      field :provider, :string
      field :provider_access_id, :string
      field :provider_access_key, :string
      field :region, :string
      field :vpc, :string
      field :subnet
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

end
