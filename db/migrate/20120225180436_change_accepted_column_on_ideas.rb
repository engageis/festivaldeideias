class ChangeAcceptedColumnOnIdeas < ActiveRecord::Migration
  def change
    change_column :ideas, :accepted, :boolean, :null => true, :default => nil
  end
end
