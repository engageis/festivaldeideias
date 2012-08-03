class StoreAuditsTimelineData < ActiveRecord::Migration
  def up
    add_column :audits, :actual_user_id, :integer
    add_column :audits, :parent_id, :integer
    add_column :audits, :text, :text
    add_column :audits, :notification_text, :text
    Audit.all.each { |audit| audit.set_timeline_and_notifications_data! }
  end
  def down
    remove_column :audits, :actual_user_id
    remove_column :audits, :parent_id
    remove_column :audits, :text
    remove_column :audits, :notification_text
  end
end
