class AddDeadLineToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :deadline, :date
  end

  def self.down
    remove_column :sites, :deadline
  end
end
