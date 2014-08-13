class Application
  include Mongoid::Document
  belongs_to :eco_system, inverse_of: :applications
  has_many :servers, dependent: :delete, autosave: true,  inverse_of: :application
  has_many :mongo_servers, dependent: :delete, autosave: true,  inverse_of: :application

  has_many :cdns, dependent: :delete, autosave: true,  inverse_of: :application
  has_many :load_balancers, dependent: :delete, autosave: true,  inverse_of: :application

  # has_many :databases, dependent: :delete, autosave: true,  inverse_of: :application
  # has_many :caches, dependent: :delete, autosave: true,  inverse_of: :application

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
      field :eco_system
    end
    list do
      field :name
      field :eco_system
      field :flavor
      field :image_id
    end

  end


  def safe_image_id
    self.image_id.nil? ? eco_system.image_id : self.image_id
  end

  def safe_flavor
    self.flavor.nil? ? eco_system.flavor : self.flavor
  end

  def clone
    system "cd #{Rails.root.join("workspace")} && git clone #{github} #{name}"
  end

  def deploy
    system "cd #{Rails.root.join("workspace", name)} && bundle install && cap #{eco_system.rails_environment} deploy"
  end

end
