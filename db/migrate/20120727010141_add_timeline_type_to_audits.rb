class AddTimelineTypeToAudits < ActiveRecord::Migration
  def change
    add_column :audits, :timeline_type, :string
  end
end
