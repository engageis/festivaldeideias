class RemoveNotNullFromIdeas < ActiveRecord::Migration
  def up
  	change_column :ideas, :headline, :text, :null => true
  end

  def down
  	change_column :ideas, :headline, :text, :null => false
  end
end
