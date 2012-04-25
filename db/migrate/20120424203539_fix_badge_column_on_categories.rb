class FixBadgeColumnOnCategories < ActiveRecord::Migration
  def change
    change_column(:idea_categories, :badge, :text, default: nil, null: true)
  end
end
