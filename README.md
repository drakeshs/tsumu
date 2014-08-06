Sumito
===============

Sumito is a vendor agnostic cluster environment creator.


##### Keys Folder
-------------------

This folder will hold the keys for accessing to running application instances and will need to be provided from someone from the team once the application is already deployed.

You can expect to have one key per environment deployed with the patter in the name:

dish-env-(env name).pem



##### Berkshelf
-------------------
Is used to manage every recipe, please read documentation [Berkshelf](http://berkshelf.com/)



##### Vagrant
-------------------

There is a Vagrant file to instanciate the development environment for testing the recipes. It works under Chef Solo and Chef Client and tries to replicate the finaly deployment infraestructure.

OttWeb

Stallone <=> (DB(Mysql) && Cache(Redis))


Knife Configuration
-------------------
Knife is the [command line interface](http://docs.opscode.com/knife.html) for Chef. The chef-repo contains a .chef directory (which is a hidden directory by default) in which the Knife configuration file (knife.rb) is located. This file contains configuration settings for the chef-repo.

The knife.rb file is automatically created by the starter kit. This file can be customized to support configuration settings used by [cloud provider options](http://docs.opscode.com/plugin_knife.html) and custom [knife plugins](http://docs.opscode.com/plugin_knife_custom.html).

Also located inside the .chef directory are .pem files, which contain private keys used to authenticate requests made to the Chef server. The USERNAME.pem file contains a private key unique to the user (and should never be shared with anyone). The ORGANIZATION-validator.pem file contains a private key that is global to the entire organization (and is used by all nodes and workstations that send requests to the Chef server).

More information about knife.rb configuration options can be found in [the documentation for knife](http://docs.opscode.com/config_rb_knife.html).

Cookbooks
---------

Cookbooks:
- System: Install basic server update for ubuntu
- Application: Install a basic ruby unicorn nginx application
- Database: Install mysql and redis


A cookbook is the fundamental unit of configuration and policy distribution.
Cookbooks are managed by [Berkshelf](http://berkshelf.com/) and uploaded to the chef server directly.

Environments
-----

Chef environments are different from RoR environments but are following the same convention so an Chef staging env should install an application under RoR environment.


Roles
-----
Roles provide logical grouping of cookbooks and other roles. A sample role can be found at `roles/starter.rb`.

There is basic roles for every application in the cluster:
- ottweb
- stallone
- database

Getting Started
-------------------------
Now that you have the chef-repo ready to go, check out [Learn Chef](https://learnchef.opscode.com/quickstart/workstation-setup/) to proceed with your workstation setup. If you have any questions about Chef you can always ask [our support team](https://www.opscode.com/support/tickets/new) for a helping hand.


Maintenance
-------------------------

This project was created by:

Jose Antonio Pio Gil japgil@qwinixtech.com
