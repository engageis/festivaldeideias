require 'sexy_pg_constraints'

class CreateIdeas < ActiveRecord::Migration
  def self.up
    create_table :ideas do |t|
      t.references :site, :null => false
      t.integer :parent_id
      t.references :user, :null => false
      t.references :category, :null => false
      t.references :template, :null => false
      t.text :title, :null => false
      t.text :headline, :null => false
      t.boolean :featured, :null => false, :default => false
      t.boolean :recommended, :null => false, :default => false
      t.integer :likes, :null => false, :default => 0
      t.integer :order
      t.timestamps
    end
    constrain :ideas do |t|
      t.title :not_blank => true
      t.headline :not_blank => true, :length_within => 1..140
      t.site_id :reference => {:sites => :id}
      t.user_id :reference => {:users => :id}
      t.category_id :reference => {:categories => :id}
      t.template_id :reference => {:templates => :id}
      t.parent_id :reference => {:ideas => :id}
    end
  end

  def self.down
    drop_table :ideas
  end
end
