#! /bin/bash
vagrant destroy -f integration
rm -fR chef/cookbooks
cd cookbooks/integration
berks update
berks vendor ../../chef/cookbooks
cd ../..
vagrant up integration
vagrant ssh integration