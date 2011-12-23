class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :user_id, :null => false
      t.text :provider, :null => false
      t.text :uid, :null => false

      t.timestamps
    end
    add_foreign_key :services, :users
  end
end
