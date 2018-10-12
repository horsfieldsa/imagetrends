class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:index]
  skip_before_action :verify_authenticity_token
  
  # GET /tags
  # GET /tags.json
  def index
    @tags_distinct = Tag.group(:name).joins(:sneaker).where(:sneakers => {:approved => true})
  end

  private
    def set_tag
      @tag = Tag.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:sneaker_id, :name)
    end
    
end