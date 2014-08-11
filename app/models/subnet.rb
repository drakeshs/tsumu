class Subnet
  include Mongoid::Document

  field :box_id, type: String
  field :name, type: String
  field :vpc_id, type: String
  field :cidr_block, type: String
  field :availability_zone, type: String
  field :tag_set, type: String
  field :map_public_ip_on_launch, type: Boolean


  before_destroy :destroy_box
  embedded_in :eco_system, inverse_of: :subnet


  def provider
    eco_system.warehouse.compute
  end

  def update_after_run_up( server )
    update_attributes( box_id: server.identity.to_s )
  end

  def build!
    build_box
  end


  include ServerMethods

end
