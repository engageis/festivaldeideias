class AddFbAdminsToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :fb_admins, :string, :default => nil
  end

  def self.down
    remove_column :sites, :fb_admins
  end
end
