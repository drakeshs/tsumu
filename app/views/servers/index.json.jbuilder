json.array!(@servers) do |server|
  json.extract! server, :id, :provider_id, :ip, :private_ip_address
  json.url server_url(server, format: :json)
end
