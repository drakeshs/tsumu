json.array!(@load_balancers) do |load_balancer|
  json.extract! load_balancer, :id, :dns
  json.url load_balancer_url(load_balancer, format: :json)
end
