name "database"
description "Basic Database Node"
run_list "recipe[database::redis]"
