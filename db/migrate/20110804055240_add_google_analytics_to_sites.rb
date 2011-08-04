class AddGoogleAnalyticsToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :google_analytics, :string, :default => ''
  end

  def self.down
    remove_column :sites, :google_analytics
  end
end
