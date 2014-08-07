class Application
  include Mongoid::Document
  belongs_to :eco_system

  field :name, type: String
  field :environment, type: String
  field :github, type: String

end
