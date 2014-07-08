#! /bin/bash
vagrant destroy -f db
rm -fR chef/cookbooks
cd cookbooks/database
berks update
berks vendor ../../chef/cookbooks
cd ../..
vagrant up db
vagrant ssh db