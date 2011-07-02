require 'sexy_pg_constraints'

class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.references :site, :null => false
      t.text :name, :null => false
      t.text :title
      t.text :href, :null => false
      t.boolean :header, :null => false, :default => false
      t.timestamps
    end
    constrain :links do |t|
      t.name :not_blank => true
      t.href :not_blank => true
      t.site_id :reference => {:sites => :id}
    end
  end

  def self.down
    drop_table :links
  end
end
