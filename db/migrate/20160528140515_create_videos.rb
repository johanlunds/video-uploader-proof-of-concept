class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :path
      t.string :url

      t.timestamps
    end
  end
end
