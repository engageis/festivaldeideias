class AddImageToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :image, :text
  end

  def self.down
    remove_column :sites, :image
  end
end
