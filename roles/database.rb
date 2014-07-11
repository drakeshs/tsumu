name "database"
description "Basic Database Node"
run_list "recipe[ubuntu]", "recipe[database::redis]"
