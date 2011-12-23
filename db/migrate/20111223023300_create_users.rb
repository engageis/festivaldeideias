class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.text :name, :null => false
      t.text :email, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
