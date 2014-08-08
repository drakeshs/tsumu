class Cdn
  include Mongoid::Document
  field :dns, type: String

  belongs_to :application, inverse_of: :cdns
end
