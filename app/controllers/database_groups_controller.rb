class DatabaseGroupsController < ApplicationController
  before_action :set_database_group, only: [:show, :edit, :update, :destroy]

  # GET /database_groups
  # GET /database_groups.json
  def index
    @database_groups = DatabaseGroup.all
  end

  # GET /database_groups/1
  # GET /database_groups/1.json
  def show
  end

  # GET /database_groups/new
  def new
    @database_group = DatabaseGroup.new
  end

  # GET /database_groups/1/edit
  def edit
  end

  # POST /database_groups
  # POST /database_groups.json
  def create
    @database_group = DatabaseGroup.new(database_group_params)

    respond_to do |format|
      if @database_group.save
        format.html { redirect_to @database_group, notice: 'Database group was successfully created.' }
        format.json { render :show, status: :created, location: @database_group }
      else
        format.html { render :new }
        format.json { render json: @database_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /database_groups/1
  # PATCH/PUT /database_groups/1.json
  def update
    respond_to do |format|
      if @database_group.update(database_group_params)
        format.html { redirect_to @database_group, notice: 'Database group was successfully updated.' }
        format.json { render :show, status: :ok, location: @database_group }
      else
        format.html { render :edit }
        format.json { render json: @database_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /database_groups/1
  # DELETE /database_groups/1.json
  def destroy
    @database_group.destroy
    respond_to do |format|
      format.html { redirect_to database_groups_url, notice: 'Database group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_database_group
      @database_group = DatabaseGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def database_group_params
      params.require(:database_group).permit(:name, :port)
    end
end
