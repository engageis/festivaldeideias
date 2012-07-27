class AddCommentsCountToIdeas < ActiveRecord::Migration
  def up
    add_column :ideas, :comment_count, :integer
    execute("UPDATE ideas SET comment_count = 0")
  end
  def down
    remove_column :ideas, :comment_count
  end
end
