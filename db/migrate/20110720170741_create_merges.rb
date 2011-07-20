require 'sexy_pg_constraints'

class CreateMerges < ActiveRecord::Migration
  def self.up
    create_table :merges do |t|
      t.references :idea, :null => false
      t.integer :from_id, :null => false
      t.boolean :requested, :null => false, :default => false
      t.boolean :pending, :null => false, :default => false
      t.boolean :finished, :null => false, :default => false
      t.timestamps
    end
    constrain :merges do |t|
      t.idea_id :reference => {:ideas => :id}
      t.from_id :reference => {:ideas => :id}
    end
  end

  def self.down
    drop_table :merges
  end
end

