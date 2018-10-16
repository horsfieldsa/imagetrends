class TrendsController < ApplicationController

  # GET /trends
  def index
    tag_logger.info("Loading trends view.")


    @top_sneakers = Sneaker.select('sneakers.*, count(favorites.id) as favorites_count').joins(:favorites).group('sneakers.id').
    having('count(favorites.id) > 0').order('count(favorites.id) DESC').limit(8)
  end

  def tag_logger
    @@tag_logger ||= Logger.new("#{Rails.root}/log/application.log")
  end

end
