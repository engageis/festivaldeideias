class DeleteOldCollaborations < ActiveRecord::Migration
  def up
    execute("DELETE FROM ideas WHERE parent_id IS NOT NULL")
  end

  def down
    # Sorry
  end
end
