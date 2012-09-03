class AddEmailNotificationsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :email_notifications, :boolean, default: true
    execute("UPDATE users SET email_notifications = true")
  end
  def down
    remove_column :users, :email_notifications
  end
end
