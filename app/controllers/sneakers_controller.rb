class SneakersController < ApplicationController
  before_action :set_sneaker, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show, :index, :find]
  skip_before_action :verify_authenticity_token

  # GET /sneakers
  # GET /sneakers.json
  def index
    if request.query_parameters['view'] == 'user'
      @sneakers = Sneaker.where(user: current_user).order(created_at: :desc).paginate(page: params[:page], per_page: 36)
      respond_to do |format|
      format.html
      format.js
      end
    else
      @sneakers = Sneaker.where(approved: true).order(created_at: :desc).paginate(page: params[:page], per_page: 36)
      respond_to do |format|
      format.html
      format.js
      end
    end
  end

  # GET /unapproved
  # GET /unapproved.json
  def unapproved
    @sneakers = Sneaker.where(approved: false).order(created_at: :desc).paginate(page: params[:page], per_page: 36)
    respond_to do |format|
     format.html
     format.js
    end
  end

  # GET /sneakers/id
  def show
  end

  def find
    @sneakers = Sneaker.joins(:tags).where(approved: true).where(tags: {name: params[:name]}).paginate(:page => params[:page])
    respond_to do |format|
     format.html
     format.js
    end
  end

  # POST /sneakers
  # POST /sneakers.json
  def create
    @sneaker = current_user.sneakers.new(sneaker_params)
    @sneaker.approved = false

    respond_to do |format|
      if @sneaker.save
        format.html { redirect_to root_url, notice: 'Your sneaker was successfully uploaded.' }
        format.json { render :show, status: :created, location: @sneaker }
      else
        format.html { redirect_to root_url, alert: 'Unable to upload sneaker.' }
        format.json { render json: @sneaker, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sneakers/1
  # PATCH/PUT /sneakers/1.json
  def update
    respond_to do |format|
      if @sneaker.update(sneaker_params)
        format.html { redirect_to @sneaker, notice: 'Sneaker was successfully updated.' }
        format.json { render :show, status: :ok, location: @sneaker }
      else
        format.html { redirect_to root_url, alert: 'Unable to update sneaker.' }
        format.json { render json: @sneaker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sneakers/1
  # DELETE /sneakers/1.json
  def destroy
    @sneaker.destroy
    respond_to do |format|
      format.html { redirect_to sneakers_url, notice: 'Sneaker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_sneaker
      @sneaker = Sneaker.find(params[:id])
    end

    def sneaker_params
      params.require(:sneaker).permit(:sneaker_image)
    end

end
