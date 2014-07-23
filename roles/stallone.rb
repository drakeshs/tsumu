name "stallone"
description "Stallone role config"
run_list "recipe[ubuntu]", "recipe[application::mysql]", "recipe[application::users]", "recipe[application::deploy]", "recipe[application::ruby-1.9]", "recipe[application::nginx]", "recipe[application::javascript]"
