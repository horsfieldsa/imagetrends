class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  before_action :create_sneaker

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end

  private

  def create_sneaker
    @sneaker = Sneaker.new
  end
end
