module ServerMethods
  extend ActiveSupport::Concern

  def eco_system_name
    application.eco_system.name
  end

  def eco_system
    application.eco_system
  end

  def build_box
    update_after_run_up( box.run_up )
  end

  def destroy_box
    box.destroy if box && box.exists?
  end

  # Warehouse instance depending on provide's warehouse
  def box
    @provider_server ||= Provider::Factory.server( self, eco_system.provider, provider )
  end

end