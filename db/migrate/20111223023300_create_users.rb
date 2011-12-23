class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.text :name, :null => false
      t.text :email, :null => false

      t.timestamps
    end
    add_index :users, :email, :unique => true
  end

  def down
    drop_table :users
  end
end
