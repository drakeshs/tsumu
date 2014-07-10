name "database"
description "Basic Database Node"
run_list "recipe[system]" "recipe[database::redis]"
