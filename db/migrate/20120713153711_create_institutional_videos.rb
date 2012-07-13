class CreateInstitutionalVideos < ActiveRecord::Migration
  def change
    create_table :institutional_videos do |t|
      t.string :video_url
      t.boolean :visible, :default => false

      t.timestamps
    end
  end
end
