json.array!(@key_pairs) do |key_pair|
  json.extract! key_pair, :id, :name, :key, :pub
  json.url key_pair_url(key_pair, format: :json)
end
