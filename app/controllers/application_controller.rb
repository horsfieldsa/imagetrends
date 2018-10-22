class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  before_action :create_sneaker
  before_action :log_action

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
    application_logger.warn("Access Denied - Action: #{params[:action]} Controller: #{params[:controller]} Event: #{exception.message}")
  end

  private

  def create_sneaker
    @new_sneaker = Sneaker.new
  end

  def log_action
    if current_user
      application_logger.info("Navigation Event - Action: #{params[:action]} Controller: #{params[:controller]} User: #{current_user.username}")
    else
      application_logger.info("Navigation Event - Action: #{params[:action]} Controller: #{params[:controller]} User: Not Logged On")
    end
  end

  def application_logger
    @@application_logger ||= Logger.new("#{Rails.root}/log/application.log")
  end

end
