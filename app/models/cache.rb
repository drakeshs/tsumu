class Cache
  include Mongoid::Document
  field :name, type: String
  field :ip, type: String

  belongs_to :application, inverse_of: :cache

end
