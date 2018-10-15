class RegistrationsController < Devise::RegistrationsController


    def create
      super
      registration_logger.info "Attempting create new user."
    end

    def update
      super
      registration_logger.info "Attempting to update user profile."
    end

    private
  
    def sign_up_params
      params.require(:user).permit(:email, :username, :password, :password_confirmation)
    end
  
    def account_update_params
      params.require(:user).permit(:email, :username, :password, :password_confirmation, :current_password)
    end
  
    def registration_logger
      @@registration_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

  end