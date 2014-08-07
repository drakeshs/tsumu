json.array!(@eco_systems) do |eco_system|
  json.extract! eco_system, :id, :name
  json.url eco_system_url(eco_system, format: :json)
end
