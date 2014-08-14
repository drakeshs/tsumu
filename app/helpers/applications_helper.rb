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

end
