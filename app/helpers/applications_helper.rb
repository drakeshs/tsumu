module ApplicationsHelper


  def get_model_color(server)
    case server
      when MongoServer # is subclass of Server
        "bg-blue"
      when Server
        "bg-purple"
    end
  end

end
