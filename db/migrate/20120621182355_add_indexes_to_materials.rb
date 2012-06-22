class AddIndexesToMaterials < ActiveRecord::Migration
  def change
    add_index :ideas, :title, name: "title_idx"
    add_index :ideas, :user_id, name: "user_id_idx"
    add_index :ideas, :parent_id, name: "parent_id_idx"
    add_index :ideas, :category_id, name: "category_id_idx"
  end
end
