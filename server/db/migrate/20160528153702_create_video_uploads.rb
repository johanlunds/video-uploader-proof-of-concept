class CreateVideoUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :video_uploads do |t|
      t.text :policy

      t.timestamps
    end
  end
end
