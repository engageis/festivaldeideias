class AddOriginalParentIdToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :original_parent_id, :integer
  end
end
