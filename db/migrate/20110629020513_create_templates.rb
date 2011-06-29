require 'sexy_pg_constraints'

class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.text :name, :null => false
      t.text :description
      t.text :stylesheets
      t.timestamps
    end
    constrain :templates do |t|
      t.name :not_blank => true, :unique => true
    end
  end

  def self.down
    drop_table :templates
  end
end
