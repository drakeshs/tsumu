class Group
  include Mongoid::Document
  field :name, type: String
  field :box_id, type: String
  field :ports, type: Array

  before_destroy :destroy_box


  def provider
    eco_system.warehouse.compute
  end

  def update_after_run_up( server )
    update_attributes( box_id: server.group_id.to_s )
  end

  def build!
    build_box
  end


  include ServerMethods

end
