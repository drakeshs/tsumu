# -*- mode: ruby -*-
# vi: set ft=ruby :
# This is a Vagrant configuration file. It can be used to set up and manage
# virtual machines on your local system or in the cloud. See http://downloads.vagrantup.com/
# for downloads and installation instructions, and see http://docs.vagrantup.com/v2/
# for more information and configuring and using Vagrant.

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  config.omnibus.chef_version = :latest

  config.vm.box = "opscode_ubuntu-13.10"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-13.10_chef-provisionerless.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # port 8080 on the virtual machine is forwarded to port 9090 on the host.
  # This will allow the virtual machine to communicate of the common proxy port 8080.
  # config.vm.network :forwarded_port, guest: 8080, host: 9090

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", type: "dhcp"
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #

  ##########################################################################
  ## Local development instances with Chef Client under staging environment
  ##########################################################################

  config.vm.define "ottweb" do |ottweb|
    ottweb.vm.hostname = "ottweb"
    ottweb.vm.provision :chef_client do |chef|
      chef.chef_server_url = "https://api.opscode.com/organizations/qwinixchef"
      chef.validation_client_name = "qwinixchef-validator"
      chef.validation_key_path = ".chef/qwinixchef-validator.pem"
      chef.encrypted_data_bag_secret_key_path = "#{ENV['HOME']}/Workserver/sumito/.chef/encrypted_data_bag_secret"
      chef.add_role "ottweb"
      chef.environment = "staging"
    end
  end

  config.vm.define "web" do |web|
    web.vm.hostname = "webserver"
    web.vm.provision :chef_client do |chef|
      chef.chef_server_url = "https://api.opscode.com/organizations/qwinixchef"
      chef.validation_client_name = "qwinixchef-validator"
      chef.validation_key_path = ".chef/qwinixchef-validator.pem"
      chef.encrypted_data_bag_secret_key_path = "#{ENV['HOME']}/Workserver/sumito/.chef/encrypted_data_bag_secret"
      chef.add_role "stallone"
      chef.environment = "staging"
    end
  end

  ##########################################################################
  ## Local development instances with Chef Solo
  ##########################################################################

  config.vm.define "ottweb" do |ottweb|
    ottweb.vm.hostname = "ottweb"
    ottweb.vm.network "private_network", ip: "172.28.128.2"
    ottweb.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.environments_path = "environments"
      chef.roles_path = "roles"
      chef.data_bags_path = "data_bags"
      chef.add_role "ottweb"
      chef.environment = "local"
      chef.encrypted_data_bag_secret_key_path = "#{ENV['HOME']}/Workserver/sumito/.chef/encrypted_data_bag_secret"
    end
  end

  config.vm.define "stallone" do |stallone|
    stallone.vm.hostname = "stallone"
    stallone.vm.network "private_network", ip: "172.28.128.3"
    stallone.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.environments_path = "environments"
      chef.roles_path = "roles"
      chef.data_bags_path = "data_bags"
      chef.add_role "stallone"
      chef.environment = "local"
      chef.encrypted_data_bag_secret_key_path = "#{ENV['HOME']}/Workserver/sumito/.chef/encrypted_data_bag_secret"
    end
  end

  config.vm.define "db" do |db|
    db.vm.hostname = "database"
    db.vm.network "private_network", ip: "172.28.128.4"
    db.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "chef/cookbooks"
      chef.roles_path = "roles"
      chef.data_bags_path = "data_bags"
      chef.add_role "database"
      chef.encrypted_data_bag_secret_key_path = "#{ENV['HOME']}/Workserver/sumito/.chef/encrypted_data_bag_secret"
    end
  end



end
