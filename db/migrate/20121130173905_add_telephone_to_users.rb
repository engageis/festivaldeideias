class AddTelephoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :telephone, :text
  end
end
