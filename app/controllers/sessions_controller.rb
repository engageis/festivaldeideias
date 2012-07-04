class SessionsController < ApplicationController
  skip_authorization_check

  before_filter :only => [:new, :connect_with_facebook] do
    session[:redirect_url] = params[:redirect_url]
  end


  def create
    redirect_url = session[:redirect_url]
    session[:redirect_url] = nil
    auth = request.env['omniauth.auth']
    session[:fb_token] = auth['credentials']['token']

    unless @auth = Service.find_from_hash(auth)
      @auth = Service.create_from_hash(auth, current_user)
    end
    self.current_user = @auth.user
    
    flash[:notice] = t('login.success')
    redirect_to redirect_url || root_path
  end

  def destroy
    flash[:notice] = t('logout.success')
    reset_session
    cookies.delete :user
    redirect_to root_path
  end

  # Preserve previous url
  def connect_with_facebook
    redirect_to '/auth/facebook'
  end

  def new
  end
end
