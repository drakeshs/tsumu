class KeyPair
  include Mongoid::Document
  field :name, type: String
  field :key, type: String
  field :pub, type: String

  belongs_to :eco_system, inverse_of: :key_pairs

end
