class ServersController < ApplicationController
  before_action :get_parent
  before_action :set_server, only: [:show, :edit, :update, :destroy, :build, :bootstrap, :provision]

  # GET /servers
  # GET /servers.json
  def index
    @servers = Server.all
  end

  # GET /servers/1
  # GET /servers/1.json
  def show
  end

  # GET /servers/new
  def new
    @server = Server.new
  end

  # GET /servers/1/edit
  def edit
  end

  # POST /servers
  # POST /servers.json
  def create
    @server = Server.new(application: @parent, groups_name: @parent.eco_system.server_groups.map(&:box_id) )

    respond_to do |format|
      if @server.save
        format.html { redirect_to @parent.eco_system, notice: 'Server was successfully created.' }
        format.json { render :show, status: :created, location: @server }
      else
        format.html { render :new }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1
  # DELETE /servers/1.json
  def destroy
    ServerWorker.perform_async(@server.id.to_s, "destroy")
    respond_to do |format|
      format.html { redirect_to @parent.eco_system }
      format.json { head :no_content }
    end
  end


  def build
    ServerWorker.perform_async(@server.id.to_s, "build")
    respond_to do |format|
      format.html { redirect_to @parent.eco_system }
      format.json { head :no_content }
    end
  end

  def bootstrap
    ServerWorker.perform_async(@server.id.to_s, "bootstrap")
    respond_to do |format|
      format.html { redirect_to @parent.eco_system }
      format.json { head :no_content }
    end
  end

  def provision
    ServerWorker.perform_async(@server.id.to_s, "provision")
    respond_to do |format|
      format.html { redirect_to @parent.eco_system }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server
      @server = Server.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def server_params
      params.require(:server).permit(:provider_id, :ip, :private_ip_address)
    end

    def get_parent
      parent_klasses = %w[application]
      if klass = parent_klasses.detect { |pk| params[:"#{pk}_id"].present? }
        @parent = klass.camelize.constantize.find params[:"#{klass}_id"]
      end
    end

end
