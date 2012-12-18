class CreateCollaborators < ActiveRecord::Migration
  def up
    create_table :collaborators do |t|
      t.references :idea
      t.references :user
      t.timestamps
    end
    execute("INSERT INTO collaborators (idea_id, user_id, created_at, updated_at) SELECT parent_id, user_id, current_timestamp, current_timestamp FROM ideas WHERE accepted AND parent_id IS NOT NULL")
  end

  def down
    drop_table :collaborators
  end
end
