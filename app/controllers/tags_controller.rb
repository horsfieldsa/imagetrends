class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:index]
  skip_before_action :verify_authenticity_token
  
  # GET /tags
  # GET /tags.json
  def index
    @tags_distinct = Tag.select("name, source").group("name, source")
    tag_logger.info("Loading a list of distinct Tags: #{@tags_distinct.length}")
  end

  private
    def set_tag
      @tag = Tag.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:image_id, :name)
    end
    
    def tag_logger
      @@tag_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end