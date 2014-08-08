json.array!(@cdns) do |cdn|
  json.extract! cdn, :id, :dns
  json.url cdn_url(cdn, format: :json)
end
