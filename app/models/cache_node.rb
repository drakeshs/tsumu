class CacheNode

  include Mongoid::Document
  field :name, type: String
  field :status, type: String
  field :port, type: String
  field :address, type: String

  embedded_in :cache, inverse_of: :nodes

end
