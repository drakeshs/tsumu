class DatabaseGroup < Group

  embedded_in :eco_system, inverse_of: :database_groups

end
