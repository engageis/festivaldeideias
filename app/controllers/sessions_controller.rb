class SessionsController < ApplicationController

  skip_authorization_check
  def create
    auth = request.env['omniauth.auth']
    logger.info(auth)

    unless @auth = Service.find_from_hash(auth)
      @auth = Service.create_from_hash(auth, current_user)
    end
    self.current_user = @auth.user

    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
