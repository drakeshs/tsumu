json.array!(@cache_groups) do |cache_group|
  json.extract! cache_group, :id, :name, :port
  json.url cache_group_url(cache_group, format: :json)
end
