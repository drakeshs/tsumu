class KeyPairsController < ApplicationController
  before_action :set_key_pair, only: [:show, :edit, :update, :destroy]

  # GET /key_pairs
  # GET /key_pairs.json
  def index
    @key_pairs = KeyPair.all
  end

  # GET /key_pairs/1
  # GET /key_pairs/1.json
  def show
  end

  # GET /key_pairs/new
  def new
    @key_pair = KeyPair.new
  end

  # GET /key_pairs/1/edit
  def edit
  end

  # POST /key_pairs
  # POST /key_pairs.json
  def create
    @key_pair = KeyPair.new(key_pair_params)

    respond_to do |format|
      if @key_pair.save
        format.html { redirect_to @key_pair, notice: 'Key pair was successfully created.' }
        format.json { render :show, status: :created, location: @key_pair }
      else
        format.html { render :new }
        format.json { render json: @key_pair.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /key_pairs/1
  # PATCH/PUT /key_pairs/1.json
  def update
    respond_to do |format|
      if @key_pair.update(key_pair_params)
        format.html { redirect_to @key_pair, notice: 'Key pair was successfully updated.' }
        format.json { render :show, status: :ok, location: @key_pair }
      else
        format.html { render :edit }
        format.json { render json: @key_pair.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /key_pairs/1
  # DELETE /key_pairs/1.json
  def destroy
    @key_pair.destroy
    respond_to do |format|
      format.html { redirect_to key_pairs_url, notice: 'Key pair was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_key_pair
      @key_pair = KeyPair.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def key_pair_params
      params.require(:key_pair).permit(:name, :key, :pub)
    end
end
