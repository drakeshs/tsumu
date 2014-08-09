class KeyPair
  include Mongoid::Document
  field :name, type: String
  field :key, type: String
  field :pub, type: String

  belongs_to :eco_system, inverse_of: :key_pairs

  before_destroy :destroy_box

  def build!
    build_box
  end

  def provider
    eco_system.warehouse.compute
  end

  def update_after_run_up( server )
    update_attributes(  name: server.name,
                        key: server.private_key )
  end

  include ServerMethods
end
