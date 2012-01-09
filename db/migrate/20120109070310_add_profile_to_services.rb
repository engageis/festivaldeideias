class AddProfileToServices < ActiveRecord::Migration
  def change
    add_column :services, :profile, :text, :default => :null
  end
end
