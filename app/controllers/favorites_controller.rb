class FavoritesController < ApplicationController
  before_action :set_favorite, only: [:destroy]

  # POST /favorites
  # POST /favorites.json
  def create
    @favorite = Favorite.new(favorite_params)

    respond_to do |format|
      if @favorite.save
        format.html { redirect_to @favorite.image}
        format.json { render :show, status: :created, location: @favorite }
      else
        format.html { redirect_to @favorite.image, notice: 'Unable to mark image as a favorite.' }
        format.json { render json: @favorite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favorites/1
  # DELETE /favorites/1.json
  def destroy
    @image = @favorite.image
    @favorite.destroy
    respond_to do |format|
      format.html { redirect_to @image }
      format.json { head :no_content }
    end
  end

  private

    def set_favorite
      @favorite = Favorite.find(params[:id])
    end

    def favorite_params
      params.require(:favorite).permit(:image_id, :user_id)
    end
end
