#! /bin/bash
rm -fR chef/cookbooks
cd cookbooks/application
berks update
berks vendor ../../chef/cookbooks
cd ../..
vagrant provision ottweb
vagrant ssh ottweb
