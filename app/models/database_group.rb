class DatabaseGroup < Group

  belongs_to :database, inverse_of: :database_groups

end
