class Application
  include Mongoid::Document
  belongs_to :eco_system
  has_many :servers, dependent: :delete, autosave: true

  field :name, type: String
  field :environment, type: String
  field :github, type: String

  field :image_id, type: String
  field :flavor, type: String


  def safe_image_id
    self.image_id.nil? ? eco_system.image_id : self.image_id
  end

  def safe_flavor
    self.flavor.nil? ? eco_system.flavor : self.flavor
  end

end
