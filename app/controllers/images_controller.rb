class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show, :index, :find]
  skip_before_action :verify_authenticity_token

  # GET /images
  # GET /images.json
  def index
    if request.query_parameters['view'] == 'user'
      image_logger.info("Loading all images for User: #{!current_user.nil? ? current_user.username : 'No User'} Page: #{!params[:page].nil? ? params[:page] : '1'}")
      @images = Image.where(user: current_user).order(created_at: :desc).paginate(page: params[:page])

      respond_to do |format|
      format.html
      format.js
      end
    elsif request.query_parameters['view'] == 'favorites'
      image_logger.info("Loading all images for User: #{!current_user.nil? ? current_user.username : 'No User'} Page: #{!params[:page].nil? ? params[:page] : '1'}")
      @images = Image.where(user: current_user).order(created_at: :desc).paginate(page: params[:page])
            
      respond_to do |format|
      format.html
      format.js
      end
    else
      image_logger.info("Loading all images for User: #{!current_user.nil? ? current_user.username : 'No User'} Page: #{!params[:page].nil? ? params[:page] : '1'}")
      @recommended = Image.where(user: current_user).limit(4)
      @images = Image.order(created_at: :desc).paginate(page: params[:page])
      respond_to do |format|
      format.html
      format.js
      end
    end
  end

  # GET /images/id
  def show

    if current_user

      event = {
        type: 'useritem',
        ITEM_ID: @image.id,
        USER_ID: current_user.id,
        EVENT_TYPE: 'click',
        EVENT_VALUE: @image.id,
        TIMESTAMP: Time.now.to_i
      }

      EventRecordJob.perform_async(event)

      if Favorite.where("user_id = ? AND image_id = ?", current_user.id, @image.id).count > 0
        @favorited = true
        @favorite = Favorite.find_by_user_id_and_image_id(current_user.id, @image.id)
      else
        @favorited = false
      end
    end

    image_logger.info("Showing details for Image: #{@image.id} User: #{!current_user.nil? ? current_user.username : 'No User'}")
  end

  def find
    image_logger.info("Loading images with Tag: #{params[:name]}")
    @images = Image.joins(:tags).where(tags: {name: params[:name]}).paginate(:page => params[:page])
    respond_to do |format|
     format.html
     format.js
    end
  end

  # POST /images
  # POST /images.json
  def create
    @image = current_user.images.new(image_params)
    image_logger.info("Image uploaded started: #{current_user.username}")

    respond_to do |format|
      if @image.save
        image_logger.info("Image upload successful: User #{current_user.username} Image: #{@image.id}")
        format.html { redirect_to @image, notice: 'Your image was successfully uploaded.' }
        format.json { render :show, status: :created, location: @image }
      else
        image_logger.error("Image upload failed: User #{current_user.username}")
        format.html { redirect_to root_url, alert: 'Unable to upload image.' }
        format.json { render json: @image, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        image_logger.info("Successfully updated Image: #{@image.id}")
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        image_logger.error("Error updating Image: #{@image}")
        format.html { redirect_to root_url, alert: 'Unable to update image.' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    authorize! :delete, @image
    image_logger.info("Attempting to delete Image: #{@image.id}")
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_image
      @image = Image.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:image_image)
    end

    def image_logger
      @@image_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end
