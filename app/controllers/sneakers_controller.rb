class SneakersController < ApplicationController
  before_action :set_sneaker, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show, :index, :find]
  skip_before_action :verify_authenticity_token

  # GET /sneakers
  # GET /sneakers.json
  def index
    if request.query_parameters['view'] == 'user'
      if current_user
        image_logger.info("Loading user images for user: #{current_user.id} Page: #{params[:page]}")
      end
      @sneakers = Sneaker.where(user: current_user).order(created_at: :desc).paginate(page: params[:page], per_page: 36)

      respond_to do |format|
      format.html
      format.js
      end
    elsif request.query_parameters['view'] == 'favorites'
      if current_user
        image_logger.info("Loading favorite images for user: #{current_user.id} Page: #{params[:page]}")
      end

      @sneakers = Sneaker.where(user: current_user).order(created_at: :desc).paginate(page: params[:page], per_page: 36)
            
      respond_to do |format|
      format.html
      format.js
      end
    else
      if current_user
        image_logger.info("Loading all images for user: #{current_user.id} Page: #{params[:page]}")
      end

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

    if Favorite.where("user_id = ? AND sneaker_id = ?", current_user.id, @sneaker.id).count > 0
      @favorited = true
      @favorite = Favorite.find_by_user_id_and_sneaker_id(current_user.id, @sneaker.id)
    else
      @favorited = false
    end

    image_logger.info("Showing Details for Image: #{@sneaker.id}")
  end

  def find
    image_logger.info("Loading images with tag: #{params[:name]}")
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
    @sneaker.approved = true
    image_logger.info("User uploaded new image: #{current_user.id}")

    respond_to do |format|
      if @sneaker.save
        image_logger.info("Successfully created new image #{@sneaker.id}")
        format.html { redirect_to @sneaker, notice: 'Your image was successfully uploaded.' }
        format.json { render :show, status: :created, location: @sneaker }
      else
        image_logger.error("Error creating new image #{@sneaker}")
        format.html { redirect_to root_url, alert: 'Unable to upload image.' }
        format.json { render json: @sneaker, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sneakers/1
  # PATCH/PUT /sneakers/1.json
  def update
    respond_to do |format|
      if @sneaker.update(sneaker_params)
        image_logger.info("Successfully updated image #{@sneaker.id}")
        format.html { redirect_to @sneaker, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @sneaker }
      else
        image_logger.error("Error updating image #{@sneaker}")
        format.html { redirect_to root_url, alert: 'Unable to update image.' }
        format.json { render json: @sneaker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sneakers/1
  # DELETE /sneakers/1.json
  def destroy
    image_logger.info("Attempting to delete image #{@sneaker.id}")
    @sneaker.destroy
    respond_to do |format|
      format.html { redirect_to sneakers_url, notice: 'Image was successfully destroyed.' }
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

    def image_logger
      @@image_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end
