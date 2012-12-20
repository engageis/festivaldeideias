class AddMigratedCommentsToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :migrated_comments, :boolean, default: false
  end
end
