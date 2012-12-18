class CreateCollaborations < ActiveRecord::Migration
  def change
    create_table :collaborations do |t|
      t.references :idea
      t.references :user
      t.integer :parent_id
      t.text :description

      t.timestamps
    end
    add_index :collaborations, :idea_id
    add_index :collaborations, :user_id
  end
end
