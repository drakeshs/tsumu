class ServerGroup < Group

  belongs_to :application, inverse_of: :application

end
