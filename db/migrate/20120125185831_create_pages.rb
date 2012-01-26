class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, :null => false, :unique => true
      t.text :body, :null => false

      t.timestamps
    end

    add_index :pages, :title
  end
end
