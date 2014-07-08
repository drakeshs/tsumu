#! /bin/bash
vagrant destroy -f web
rm -fR chef/cookbooks
cd cookbooks/application
berks update
berks vendor ../../chef/cookbooks
cd ../..
vagrant up web
vagrant ssh web