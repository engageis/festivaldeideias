class AddNotificationsReadAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notifications_read_at, :timestamp
  end
end
