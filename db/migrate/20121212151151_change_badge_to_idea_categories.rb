class ChangeBadgeToIdeaCategories < ActiveRecord::Migration
  def up
    remove_column :idea_categories, :badge
    add_column :idea_categories, :badge, :oid
    add_column :idea_categories, :pin, :oid
  end
  def down
    remove_column :idea_categories, :badge
    remove_column :idea_categories, :pin
    add_column :idea_categories, :badge, :text
  end
end
