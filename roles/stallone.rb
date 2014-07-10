name "server"
description "basic server config"
run_list "recipe[ubuntu]", "recipe[application::mysql]", "recipe[application]"
