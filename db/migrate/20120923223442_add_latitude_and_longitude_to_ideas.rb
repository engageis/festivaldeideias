class AddLatitudeAndLongitudeToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :latitude, :float
    add_column :ideas, :longitude, :float
  end
end
