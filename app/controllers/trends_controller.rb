class TrendsController < ApplicationController

  # GET /trends
  def index
    @top_sneakers = Sneaker.select('sneakers.*, count(favorites.id) as favorites_count').joins(:favorites).group('sneakers.id').
    having('count(favorites.id) > 0').order('count(favorites.id) DESC').limit(8)
  end

end
