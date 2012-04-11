class UsersController < InheritedResources::Base
  respond_to :json, :html
  def update_notification
    return unless current_user
    current_user.update_attribute(:notifications_read_at, Time.now)
    return render nothing: true
  end
end
