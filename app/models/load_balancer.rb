class LoadBalancer
  include Mongoid::Document
  field :dns, type: String

  belongs_to :application, inverse_of: :load_balancers

end
