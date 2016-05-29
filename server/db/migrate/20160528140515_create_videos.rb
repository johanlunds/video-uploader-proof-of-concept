class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.integer :video_upload_id, null: false
      t.string :title
      t.string :status, null: false, default: 'new'

      t.timestamps
    end
  end
end
