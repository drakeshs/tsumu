class Server
  include Mongoid::Document

  field :name, type: String
  field :ip, type: String
  field :private_ip_address, type: String
  field :dns, type: String

  belongs_to :application, inverse_of: :servers

  before_destroy :destroy_server

  rails_admin do

    list do
      field :eco_system_name
      field :application
      field :ip
    end

    show do
      field :eco_system_name
      field :application
      field :name
      field :ip
      field :private_ip_address
      field :dns
      field :created_at
    end

    show do
    end

    edit do
      field :application
      # field :ip
      # field :private_ip_address
      # field :dns
      # field :created_at
    end

  end

  state_machine :state, :initial => :creating do

    event :build do
      transition :creating => :ran_up
    end

    event :bootstrap do
      transition :ran_up => :bootstraped
    end

    event :verify do
      transition :bootstraped => :verified
    end

  end

  def eco_system_name
    application.eco_system.name
  end

  def eco_system
    application.eco_system
  end

  def provider
    eco_system.fog_provider.compute
  end

  def get
    provider.servers.get(name)
    rescue
    nil
  end

  def exists?
    !get.nil?
  end

  def destroy_server
    get.destroy
  end

  def run_up
    unless exists?
      server = provider.servers.create({
        flavor_id: application.safe_flavor,
        image_id: application.safe_image_id,
        # groups: @groups,
        # key_name: @application.stack.key_pair.get.name,
        tags: { name: @name, group: application.name, eco_system: application.eco_system.name  }
        })
      server.wait_for { sleep(1); ready? }
      update_after_run_up( server )
    end
  end

  def update_after_run_up( server )
    update_attributes(  name: server.id,
                        ip: server.public_ip_address,
                        private_ip_address: server.private_ip_address,
                        dns: server.dns_name )
  end


end
