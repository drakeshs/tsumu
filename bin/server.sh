#! /bin/bash
vagrant destroy
rm -fR chef/cookbooks
cd cookbooks/system
berks update
berks vendor ../../chef/cookbooks
cd ../..
vagrant up web