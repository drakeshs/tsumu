class CacheGroupsController < ApplicationController
  before_action :set_cache_group, only: [:show, :edit, :update, :destroy]

  # GET /cache_groups
  # GET /cache_groups.json
  def index
    @cache_groups = CacheGroup.all
  end

  # GET /cache_groups/1
  # GET /cache_groups/1.json
  def show
  end

  # GET /cache_groups/new
  def new
    @cache_group = CacheGroup.new
  end

  # GET /cache_groups/1/edit
  def edit
  end

  # POST /cache_groups
  # POST /cache_groups.json
  def create
    @cache_group = CacheGroup.new(cache_group_params)

    respond_to do |format|
      if @cache_group.save
        format.html { redirect_to @cache_group, notice: 'Cache group was successfully created.' }
        format.json { render :show, status: :created, location: @cache_group }
      else
        format.html { render :new }
        format.json { render json: @cache_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cache_groups/1
  # PATCH/PUT /cache_groups/1.json
  def update
    respond_to do |format|
      if @cache_group.update(cache_group_params)
        format.html { redirect_to @cache_group, notice: 'Cache group was successfully updated.' }
        format.json { render :show, status: :ok, location: @cache_group }
      else
        format.html { render :edit }
        format.json { render json: @cache_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cache_groups/1
  # DELETE /cache_groups/1.json
  def destroy
    @cache_group.destroy
    respond_to do |format|
      format.html { redirect_to cache_groups_url, notice: 'Cache group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cache_group
      @cache_group = CacheGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cache_group_params
      params.require(:cache_group).permit(:name, :port)
    end
end
