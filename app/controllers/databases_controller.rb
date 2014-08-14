class DatabasesController < ApplicationController
  before_action :get_parent
  before_action :set_database, only: [:show, :edit, :update, :destroy, :build]

  # GET /databases
  # GET /databases.json
  def index
    @databases = Database.all
  end

  # GET /databases/1
  # GET /databases/1.json
  def show
  end

  # POST /databases
  # POST /databases.json
  def create
    @parent.factory.create(:database)

    respond_to do |format|
      format.html { redirect_to @parent, notice: 'Database was successfully created.' }
      format.json { render :show, status: :created, location: @parent }
    end
  end

  # DELETE /databases/1
  # DELETE /databases/1.json
  def destroy
    DatabaseWorker.perform_async(@database.id.to_s, "destroy")
    respond_to do |format|
      format.html { redirect_to @parent, notice: 'Database was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def build
    DatabaseWorker.perform_async(@database.id.to_s, "build")
    respond_to do |format|
      format.html { redirect_to @parent }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_database
      @database = Database.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def database_params
      params.require(:database).permit(:name, :ip)
    end

    def get_parent
      parent_klasses = %w[eco_system]
      if klass = parent_klasses.detect { |pk| params[:"#{pk}_id"].present? }
        @parent = klass.camelize.constantize.find params[:"#{klass}_id"]
      end
    end
end
