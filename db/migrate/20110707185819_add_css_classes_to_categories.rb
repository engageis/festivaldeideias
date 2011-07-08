class AddCssClassesToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :css_classes, :text, :default => ''
  end

  def self.down
    remove_column :categories, :css_classes
  end
end
