json.array!(@server_groups) do |server_group|
  json.extract! server_group, :id, :name, :port
  json.url server_group_url(server_group, format: :json)
end
