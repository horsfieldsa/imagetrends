class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  before_action :create_image
  before_action :log_action

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
    application_logger.warn("Access Denied - Action: #{params[:action]} Controller: #{params[:controller]} Event: #{exception.message}")
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to main_app.root_url, :alert => "Sorry, we could not find what you are looking for."
    application_logger.warn("Record Not Found - Action: #{params[:action]} Controller: #{params[:controller]} Event: #{exception.message}")
  end

  rescue_from StandardError do |exception|
    redirect_to main_app.root_url, :alert => "An unknown error occured."
    application_logger.error("Unknown Error - Action: #{params[:action]} Controller: #{params[:controller]} Event: #{exception.message}")
  end

  private

  def create_image
    @new_image = Image.new
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
