class TrendsController < ApplicationController

  # GET /trends
  def index
    @top_images = Image.select('images.*, count(favorites.id) as favorites_count').joins(:favorites).group('images.id').
    having('count(favorites.id) > 0').order('count(favorites.id) DESC').limit(8)
  end

end
