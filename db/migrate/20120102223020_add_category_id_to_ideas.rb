class AddCategoryIdToIdeas < ActiveRecord::Migration
  def up
    add_column :ideas, :category_id, :integer, :null => false, :default => 0
  end

  def down
    remove_column :ideas, :category_id
  end
end
