class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :idea_id
      t.string :text
      t.integer :user_id

      t.timestamps
    end
  end
end
