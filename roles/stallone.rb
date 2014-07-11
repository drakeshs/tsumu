name "stallone"
description "Stallone role config"
run_list "recipe[ubuntu]", "recipe[application::mysql]", "recipe[application]"
