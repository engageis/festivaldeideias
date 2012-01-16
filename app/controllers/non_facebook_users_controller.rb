# coding: utf-8

class NonFacebookUsersController < ApplicationController
  inherit_resources

  def create
    @non_facebook_user = NonFacebookUser.new(params[:non_facebook_user])
    @non_facebook_user.email.downcase!

    if NonFacebookUser.find_by_email(@non_facebook_user.email)
      flash[:notice] = t('non_facebook_user.create.success')
      return redirect_to :back
    end

    create! do |success, failure|
      success.html {
        flash[:notice] = t('non_facebook_user.create.success')
        redirect_to :back
      }
      failure.html {
        flash[:alert] = "E-mail não pode ficar em branco"
        redirect_to :back
      }
    end

  end
end
