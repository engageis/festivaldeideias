class FixBannerDescription < ActiveRecord::Migration
  def change
    change_column :banners, :description, :text, null: false
  end
end
