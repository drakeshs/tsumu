include_recipe "redis::install_from_package"
include_recipe "redis::client"

# TODO install redis under port 1000