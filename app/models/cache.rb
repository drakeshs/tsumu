class Cache
  include Mongoid::Document
  field :name, type: String
  field :dns, type: String
  field :node_type, type: String
  field :engine, type: String
  field :nodes, type: Integer
  field :port, type: String

  belongs_to :eco_system, inverse_of: :caches

end
