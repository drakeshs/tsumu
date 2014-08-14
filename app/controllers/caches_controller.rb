class CachesController < ApplicationController
  before_action :get_parent
  before_action :set_cach, only: [:show, :edit, :update, :destroy, :build]

  # GET /caches
  # GET /caches.json
  def index
    @caches = Cache.all
  end

  # GET /caches/1
  # GET /caches/1.json
  def show
  end

  # POST /caches
  # POST /caches.json
  def create

    cache = @parent.factory.create(:cache)

    respond_to do |format|
      format.html { redirect_to @parent, notice: 'Cache was successfully created.' }
      format.json { render :show, status: :created, location: cache }
    end

  end

  # DELETE /caches/1
  # DELETE /caches/1.json
  def destroy
    CacheWorker.perform_async(@cach.id.to_s, "destroy")
    respond_to do |format|
      format.html { redirect_to @parent, notice: 'Cache was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def build
    CacheWorker.perform_async(@cach.id.to_s, "build")
    respond_to do |format|
      format.html { redirect_to @parent }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cach
      @cach = Cache.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cach_params
      params.require(:cach).permit(:name, :ip)
    end

    def get_parent
      parent_klasses = %w[eco_system]
      if klass = parent_klasses.detect { |pk| params[:"#{pk}_id"].present? }
        @parent = klass.camelize.constantize.find params[:"#{klass}_id"]
      end
    end
end
