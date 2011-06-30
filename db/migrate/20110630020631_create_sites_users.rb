class CreateSitesUsers < ActiveRecord::Migration
  def self.up
    create_table :sites_users, :id => false do |t|
      t.references :site, :user
    end
    constrain :sites_users do |t|
      t.site_id :reference => {:sites => :id}
      t.user_id :reference => {:users => :id}
    end
    add_index :sites_users, [:site_id, :user_id]
  end

  def self.down
    drop_table :sites_users
  end
end
