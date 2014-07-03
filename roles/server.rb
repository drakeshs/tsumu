name "server"
description "basic server config"
run_list "recipe[apt]","recipe[system]"
