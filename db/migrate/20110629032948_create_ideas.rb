require 'sexy_pg_constraints'

class CreateIdeas < ActiveRecord::Migration
  def self.up
    create_table :ideas do |t|
      t.references :site, :null => false
      t.integer :parent_id
      t.references :user, :null => false
      t.references :category, :null => false
      t.text :title, :null => false
      t.text :headline, :null => false
      t.timestamps
    end
    constrain :ideas do |t|
      t.title :not_blank => true
      t.headline :not_blank => true, :length_within => 1..140
      t.site_id :reference => {:sites => :id}
      t.user_id :reference => {:users => :id}
      t.category_id :reference => {:categories => :id}
      t.parent_id :reference => {:ideas => :id}
    end
  end

  def self.down
    drop_table :ideas
  end
end
