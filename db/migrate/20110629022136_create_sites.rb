require 'sexy_pg_constraints'

class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.text :name, :null => false
      t.text :host, :null => false
      t.text :port
      t.boolean :auth_gateway, :null => false, :default => false
      t.timestamps
    end
    constrain :sites do |t|
      t.name :not_blank => true, :unique => true
      t.host :not_blank => true, :unique => true
    end
  end

  def self.down
    drop_table :sites
  end
end
