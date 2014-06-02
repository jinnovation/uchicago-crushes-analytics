class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /postes
  # GET /postes.json
  def index
    @postes = Post.all
  end

  # GET /postes/1
  # GET /postes/1.json
  def show
  end

  # GET /postes/new
  def new
    @post = Post.new
  end

  # GET /postes/1/edit
  def edit
  end

  # POST /postes
  # POST /postes.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /postes/1
  # PATCH/PUT /postes/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /postes/1
  # DELETE /postes/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to postes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params[:post]
    end
end
