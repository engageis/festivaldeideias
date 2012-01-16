class CreateNonFacebookUsers < ActiveRecord::Migration
  def change
    create_table :non_facebook_users do |t|
      t.string :email, :null => false, :unique => true

      t.timestamps
    end
  end
end
