class SessionsController < Devise::SessionsController

  def create
    super
    session_logger.info "User logged on: #{current_user.id}"
  end

  def destroy
    super
    session_logger.info "User logged off"
  end
  private

  def session_logger
    @@session_logger ||= Logger.new("#{Rails.root}/log/application.log")
  end

end