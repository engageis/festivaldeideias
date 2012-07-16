class UsersController < ApplicationController

  load_and_authorize_resource

  inherit_resources
  actions :show

  respond_to :json, :html

  def update_notification
    return unless current_user
    current_user.update_attribute(:notifications_read_at, Time.now)
    return render nothing: true
  end
  
  def notifications
  end

  protected

  def current_ability
    @current_ability ||= current_user ? UserAbility.new(current_user) : GuestAbility.new
  end

end
