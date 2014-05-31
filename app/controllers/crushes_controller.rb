class CrushesController < ApplicationController
  before_action :set_crush, only: [:show, :edit, :update, :destroy]

  # GET /crushes
  # GET /crushes.json
  def index
    @crushes = Crush.all
  end

  # GET /crushes/1
  # GET /crushes/1.json
  def show
  end

  # GET /crushes/new
  def new
    @crush = Crush.new
  end

  # GET /crushes/1/edit
  def edit
  end

  # POST /crushes
  # POST /crushes.json
  def create
    @crush = Crush.new(crush_params)

    respond_to do |format|
      if @crush.save
        format.html { redirect_to @crush, notice: 'Crush was successfully created.' }
        format.json { render action: 'show', status: :created, location: @crush }
      else
        format.html { render action: 'new' }
        format.json { render json: @crush.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crushes/1
  # PATCH/PUT /crushes/1.json
  def update
    respond_to do |format|
      if @crush.update(crush_params)
        format.html { redirect_to @crush, notice: 'Crush was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @crush.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crushes/1
  # DELETE /crushes/1.json
  def destroy
    @crush.destroy
    respond_to do |format|
      format.html { redirect_to crushes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crush
      @crush = Crush.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crush_params
      params[:crush]
    end
end
