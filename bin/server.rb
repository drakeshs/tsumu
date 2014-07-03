#! /bin/bash
vagrant destroy
rm -fR chef/cookbooks
cd cookbooks/system
berks vendor ../../chef/cookbooks
cd ../..
vagrant up web