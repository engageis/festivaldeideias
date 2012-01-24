class AddCategoryIdToIdeas < ActiveRecord::Migration
  def up
    add_column :ideas, :category_id, :integer, :null => false

    add_foreign_key :ideas, :idea_categories, :column => :category_id
  end

  def down
    remove_column :ideas, :category_id
  end
end
