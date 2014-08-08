class ServerGroupsController < ApplicationController
  before_action :set_server_group, only: [:show, :edit, :update, :destroy]

  # GET /server_groups
  # GET /server_groups.json
  def index
    @server_groups = ServerGroup.all
  end

  # GET /server_groups/1
  # GET /server_groups/1.json
  def show
  end

  # GET /server_groups/new
  def new
    @server_group = ServerGroup.new
  end

  # GET /server_groups/1/edit
  def edit
  end

  # POST /server_groups
  # POST /server_groups.json
  def create
    @server_group = ServerGroup.new(server_group_params)

    respond_to do |format|
      if @server_group.save
        format.html { redirect_to @server_group, notice: 'Server group was successfully created.' }
        format.json { render :show, status: :created, location: @server_group }
      else
        format.html { render :new }
        format.json { render json: @server_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /server_groups/1
  # PATCH/PUT /server_groups/1.json
  def update
    respond_to do |format|
      if @server_group.update(server_group_params)
        format.html { redirect_to @server_group, notice: 'Server group was successfully updated.' }
        format.json { render :show, status: :ok, location: @server_group }
      else
        format.html { render :edit }
        format.json { render json: @server_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /server_groups/1
  # DELETE /server_groups/1.json
  def destroy
    @server_group.destroy
    respond_to do |format|
      format.html { redirect_to server_groups_url, notice: 'Server group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server_group
      @server_group = ServerGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def server_group_params
      params.require(:server_group).permit(:name, :port)
    end
end
