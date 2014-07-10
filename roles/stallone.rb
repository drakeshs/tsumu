name "server"
description "basic server config"
run_list "recipe[system]", "recipe[application::mysql]", "recipe[application]"
