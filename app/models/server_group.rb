class ServerGroup < Group

  embedded_in :eco_system, inverse_of: :server_groups

end
