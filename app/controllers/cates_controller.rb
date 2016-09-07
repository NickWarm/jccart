class CatesController < ApplicationController
  before_action :set_cate, only: [:show, :edit, :update, :destroy]

  # GET /cates
  def index
    @cates = Cate.all
  end

  # GET /cates/1
  def show
  end

  # GET /cates/new
  def new
    @cate = Cate.new
  end

  # GET /cates/1/edit
  def edit
  end

  # POST /cates
  def create
    @cate = Cate.new(cate_params)

    if @cate.save
      redirect_to @cate, notice: 'Cate was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /cates/1
  def update
    if @cate.update(cate_params)
      redirect_to @cate, notice: 'Cate was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /cates/1
  def destroy
    @cate.destroy
    redirect_to cates_url, notice: 'Cate was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cate
      @cate = Cate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def cate_params
      params[:cate]
    end
end
