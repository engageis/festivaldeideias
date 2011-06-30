class CreateSitesUsersHabtmTable < ActiveRecord::Migration
  def self.up
    create_table :admins_sites, :id => false do |t|
      t.references :site, :user
    end
  end

  def self.down
    drop_table :admins_sites
  end
end
