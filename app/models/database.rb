class Database
  include Mongoid::Document
  field :name, type: String, default: (0...10).map{ (65 + rand(26)).chr }.join.downcase
  field :dns, type: String
  field :allocated_storage, type: Integer,  default: 5
  field :flavor_id, type: String
  field :engine, type: String, default: "mysql"
  field :database_name, type: String
  field :master_username, type: String
  field :master_user_password, type: String
  field :port, type: String
  field :multi_az, type: Boolean, default: false
  field :publicly_accessible, type: Boolean, default: false
  field :database_groups_name, type: Array

  belongs_to :eco_system, inverse_of: :caches

  before_destroy :destroy_box

  state_machine :state, :initial => :creating do

    event :build do
      transition :creating => :building
    end

    event :built do
      transition :building => :ran_up
    end

    event :verify do
      transition :ran_up => :verified
    end
  end

  def build_job
    build_box
    built!
  end

  def provider
    eco_system.warehouse.database
  end

  def update_after_run_up( server )
    update_attributes(  name: server.id,
                        port: server.endpoint["Port"],
                        dns: server.endpoint["Address"]
                       )
  end

  include ServerMethods

end
