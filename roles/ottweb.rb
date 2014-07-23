name "ottweb"
description "Ottweb config"
run_list "recipe[ubuntu]", "recipe[application::users]", "recipe[application::deploy]", "recipe[application::ruby-2.1]", "recipe[application::nginx]", "recipe[application::javascript]"
