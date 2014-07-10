#! /bin/bash
vagrant destroy -f stallone
rm -fR chef/cookbooks
cd cookbooks/application
berks update
berks vendor ../../chef/cookbooks
cd ../..
vagrant up stallone
vagrant ssh stallone