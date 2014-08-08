class CdnsController < ApplicationController
  before_action :set_cdn, only: [:show, :edit, :update, :destroy]

  # GET /cdns
  # GET /cdns.json
  def index
    @cdns = Cdn.all
  end

  # GET /cdns/1
  # GET /cdns/1.json
  def show
  end

  # GET /cdns/new
  def new
    @cdn = Cdn.new
  end

  # GET /cdns/1/edit
  def edit
  end

  # POST /cdns
  # POST /cdns.json
  def create
    @cdn = Cdn.new(cdn_params)

    respond_to do |format|
      if @cdn.save
        format.html { redirect_to @cdn, notice: 'Cdn was successfully created.' }
        format.json { render :show, status: :created, location: @cdn }
      else
        format.html { render :new }
        format.json { render json: @cdn.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cdns/1
  # PATCH/PUT /cdns/1.json
  def update
    respond_to do |format|
      if @cdn.update(cdn_params)
        format.html { redirect_to @cdn, notice: 'Cdn was successfully updated.' }
        format.json { render :show, status: :ok, location: @cdn }
      else
        format.html { render :edit }
        format.json { render json: @cdn.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cdns/1
  # DELETE /cdns/1.json
  def destroy
    @cdn.destroy
    respond_to do |format|
      format.html { redirect_to cdns_url, notice: 'Cdn was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cdn
      @cdn = Cdn.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cdn_params
      params.require(:cdn).permit(:dns)
    end
end
