class Application
  include Mongoid::Document
  belongs_to :eco_system
  has_many :servers, dependent: :delete, autosave: true,  inverse_of: :application

  field :name, type: String
  field :environment, type: String
  field :github, type: String

  field :image_id, type: String
  field :flavor, type: String

  field :server_roles, type: String

  rails_admin do
    edit do
      field :name
      field :environment, :string
      field :github
      field :image_id, :string
      field :flavor, :string
      field :server_roles, :string
    end
    list do
      field :eco_system
      field :name
      field :servers
    end

  end

  def safe_image_id
    self.image_id.nil? ? eco_system.image_id : self.image_id
  end

  def safe_flavor
    self.flavor.nil? ? eco_system.flavor : self.flavor
  end

end
