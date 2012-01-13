class SessionsController < ApplicationController

  skip_authorization_check
  def create
    redirect_url = session[:redirect_url]
    session[:redirect_url] = nil
    auth = request.env['omniauth.auth']
    logger.info(auth)

    unless @auth = Service.find_from_hash(auth)
      @auth = Service.create_from_hash(auth, current_user)
    end
    self.current_user = @auth.user
    session[:user_image] = auth['user_info']['image']
    redirect_to redirect_url || root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  # WARNING: Gambiarra!!!
  # Para saber para onde voltar quando
  # for feito o login com o facebook.
  # Se alguém souber melhor, sinta-se à vontade.
  def connect_with_facebook
    session[:redirect_url] = params[:redirect_url]
    redirect_to '/auth/facebook'
  end
end
