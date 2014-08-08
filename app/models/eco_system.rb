class EcoSystem
  include Mongoid::Document
  has_many :applications, dependent: :delete, autosave: true, inverse_of: :eco_system
  has_many :key_pairs, dependent: :delete, autosave: true,  inverse_of: :eco_system

  field :name, type: String
  field :provider, type: String
  field :provider_access_id, type: String
  field :provider_access_key, type: String
  field :image_id, type: String
  field :flavor, type: String


  rails_admin do
    configure :applications
    edit do
      field :provider
      field :provider_access_id
      field :provider_access_key
      field :image_id
      field :flavor
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
               aws_secret_access_key: provider_access_key }
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

end
