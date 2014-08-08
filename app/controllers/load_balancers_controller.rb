class LoadBalancersController < ApplicationController
  before_action :set_load_balancer, only: [:show, :edit, :update, :destroy]

  # GET /load_balancers
  # GET /load_balancers.json
  def index
    @load_balancers = LoadBalancer.all
  end

  # GET /load_balancers/1
  # GET /load_balancers/1.json
  def show
  end

  # GET /load_balancers/new
  def new
    @load_balancer = LoadBalancer.new
  end

  # GET /load_balancers/1/edit
  def edit
  end

  # POST /load_balancers
  # POST /load_balancers.json
  def create
    @load_balancer = LoadBalancer.new(load_balancer_params)

    respond_to do |format|
      if @load_balancer.save
        format.html { redirect_to @load_balancer, notice: 'Load balancer was successfully created.' }
        format.json { render :show, status: :created, location: @load_balancer }
      else
        format.html { render :new }
        format.json { render json: @load_balancer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /load_balancers/1
  # PATCH/PUT /load_balancers/1.json
  def update
    respond_to do |format|
      if @load_balancer.update(load_balancer_params)
        format.html { redirect_to @load_balancer, notice: 'Load balancer was successfully updated.' }
        format.json { render :show, status: :ok, location: @load_balancer }
      else
        format.html { render :edit }
        format.json { render json: @load_balancer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /load_balancers/1
  # DELETE /load_balancers/1.json
  def destroy
    @load_balancer.destroy
    respond_to do |format|
      format.html { redirect_to load_balancers_url, notice: 'Load balancer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_load_balancer
      @load_balancer = LoadBalancer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def load_balancer_params
      params.require(:load_balancer).permit(:dns)
    end
end
