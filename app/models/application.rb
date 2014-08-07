class Application
  include Mongoid::Document

  field :name, type: String
  field :environment, type: String

end
