class Cache
  include Mongoid::Document
  field :name, type: String
  field :dns, type: String
  field :node_type, type: String
  field :engine, type: String
  field :total_nodes, type: Integer
  field :port, type: String
  field :cache_groups_name, type: Array

  belongs_to :eco_system, inverse_of: :caches
  embeds_many :nodes, inverse_of: :cache, class_name: "CacheNode", cascade_callbacks: true

  before_destroy :destroy_box
  before_destroy :destroy_nodes

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
    eco_system.warehouse.cache
  end

  def update_after_run_up( server )
    update_attributes(  name: server.id,
                        status: server.status,
                       )
    server.nodes.each do |node|
      CacheNode.create( cache: self,
                        node: node["CacheNodeId"],
                        node_status: node["CacheNodeStatus"],
                        port: node["Port"],
                        address: node["Address"])

    end
  end

  include ServerMethods

  private

    def destroy_nodes
      nodes.destroy_all
    end
end
