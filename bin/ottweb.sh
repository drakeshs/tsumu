#! /bin/bash
vagrant destroy -f ottweb
rm -fR chef/cookbooks
cd cookbooks/application
berks update
berks vendor ../../chef/cookbooks
cd ../..
vagrant up ottweb
vagrant ssh ottweb