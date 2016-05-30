class CreateVideoUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :video_uploads do |t|
      t.text :presigned_post
      t.string :uuid, index: { unique: true }, null: false
      t.string :status, null: false, default: 'new'

      t.string :transcoder_job_id
      t.string :transcoder_job_status
      t.text :transcoder_job_data

      t.timestamps
    end
  end
end
