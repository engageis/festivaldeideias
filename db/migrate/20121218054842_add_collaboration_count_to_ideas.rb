class AddCollaborationCountToIdeas < ActiveRecord::Migration
  def up
    add_column :ideas, :collaboration_count, :integer, default: 0
  end
  def down
    remove_column :ideas, :collaboration_count
  end
end
