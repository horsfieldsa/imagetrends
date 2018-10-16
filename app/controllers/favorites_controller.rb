class FavoritesController < ApplicationController
  before_action :set_favorite, only: [:destroy]

  # POST /favorites
  # POST /favorites.json
  def create
    @favorite = Favorite.new(favorite_params)

    respond_to do |format|
      if @favorite.save
        format.html { redirect_to @favorite.sneaker, notice: 'This image has been marked as a favorite.' }
        format.json { render :show, status: :created, location: @favorite }
      else
        format.html { redirect_to @favorite.sneaker, notice: 'Unable to mark image as a favorite.' }
        format.json { render json: @favorite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favorites/1
  # DELETE /favorites/1.json
  def destroy
    @sneaker = @favorite.sneaker
    @favorite.destroy
    respond_to do |format|
      format.html { redirect_to @sneaker, notice: 'This image has been removed as a favorite' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite
      @favorite = Favorite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favorite_params
      params.require(:favorite).permit(:sneaker_id, :user_id)
    end
end
