class AddCityStateAndCountryToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :city, :text
    add_column :ideas, :state, :text
    add_column :ideas, :country, :text
  end
end
