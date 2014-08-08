json.array!(@caches) do |cach|
  json.extract! cach, :id, :name, :ip
  json.url cach_url(cach, format: :json)
end
