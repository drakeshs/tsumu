name "integration"
description "Inegration Server"
run_list "recipe[ubuntu]", "recipe[integration::jenkins]"
