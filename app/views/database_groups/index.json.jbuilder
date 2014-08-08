json.array!(@database_groups) do |database_group|
  json.extract! database_group, :id, :name, :port
  json.url database_group_url(database_group, format: :json)
end
