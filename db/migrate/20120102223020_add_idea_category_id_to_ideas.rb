class AddIdeaCategoryIdToIdeas < ActiveRecord::Migration
  def up
    add_column :ideas, :idea_category_id, :integer, :null => false, :default => 0
  end

  def down
    remove_column :ideas, :idea_category_id
  end
end
