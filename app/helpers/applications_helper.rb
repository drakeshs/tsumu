module ApplicationsHelper


  def get_model_color(server)

    case server
      when Cache # is subclass of Server
        "bg-green"
      when Database # is subclass of Server
        "bg-blue"
      when MongoServer # is subclass of Server
        "bg-blue"
      when Server
        "bg-purple"
    end

  end


  def header_eco_system_class(eco_system)
    is_active_current_eco_system?(eco_system) ? "active" : ""
  end

  def is_active_current_eco_system?( eco_system )
    action_name == "show" && controller_name == "eco_systems" && params["id"] == eco_system.id.to_s
  end
end
