class AddTokboxSessionToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :tokbox_session, :string
  end
end
