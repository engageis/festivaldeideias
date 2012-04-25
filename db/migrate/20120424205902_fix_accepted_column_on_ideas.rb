class FixAcceptedColumnOnIdeas < ActiveRecord::Migration
  def change
    change_column :ideas, :accepted, :boolean, default: nil
  end
end
