class AddAcceptedToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :accepted, :boolean, :default => false, :null => false
  end
end
