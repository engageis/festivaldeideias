class AddTwitterToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :twitter, :text, :default => nil
  end

  def self.down
    remove_column :sites, :twitter
  end
end
