Warden::Manager.before_failure do |env, opts|
    if env["action_dispatch.request.request_parameters"][:user]
      email = env["action_dispatch.request.request_parameters"][:user][:email]
      warden_logger.warn("Failed login attempt: #{email} ")
    else
      warden_logger.warn("Unauthorized Access Attempted: Redirecting to Logon")
    end
end

Warden::Manager.after_authentication do |user,auth,opts|
  warden_logger.info("User logon: #{user.username} ")
end

Warden::Manager.before_logout do |user,auth,opts|
  warden_logger.info("User logoff: #{user.username} ")
end

private
def warden_logger
  @@warden_logger ||= Logger.new("#{Rails.root}/log/application.log")
end