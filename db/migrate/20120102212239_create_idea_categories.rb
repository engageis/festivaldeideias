class CreateIdeaCategories < ActiveRecord::Migration
  def up
    create_table :idea_categories do |t|
      t.text :name, :null => false
      t.text :description, :null => false
      t.text :badge
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def down
    drop_table :idea_categories
  end
end
