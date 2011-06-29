require 'sexy_pg_constraints'

class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.references :site, :null => false
      t.text :name, :null => false
      t.text :badge, :null => false
      t.timestamps
    end
    constrain :categories do |t|
      t.name :not_blank => true
      t.badge :not_blank => true
      t[:site_id, :name].all :unique => true
    end
  end

  def self.down
    drop_table :categories
  end
end
