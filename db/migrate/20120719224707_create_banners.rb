class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.string :link_text, null: false
      t.string :link_url, null: false
      t.string :image_url, null: false
      t.boolean :visible, default: false

      t.timestamps
    end
  end
end
