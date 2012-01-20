class CreateIdeas < ActiveRecord::Migration
  def up
    create_table :ideas do |t|
      t.integer :user_id, :null => false
      t.integer :parent_id
      t.text    :title, :null => false
      t.text    :headline, :null => false
      t.text    :description, :null => false
      t.boolean :featured, :null => false, :default => false
      t.boolean :recommend, :null => false, :default => false
      t.integer :likes, :null => false, :default => 0
      t.integer :position, :null => false, :default => 0
      t.timestamps
    end
    add_foreign_key :ideas, :users
    add_foreign_key :ideas, :ideas, :column => :parent_id
  end

  def down
    drop_table :ideas
  end
end
