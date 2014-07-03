#! /bin/bash
vagrant destroy
rm -fR chef/cookbooks
cd cookbooks/database
berks vendor ../../chef/cookbooks
cd ../..
vagrant up db