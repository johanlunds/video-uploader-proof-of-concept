# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160528153702) do

  create_table "video_uploads", force: :cascade do |t|
    t.text     "presigned_post"
    t.string   "uuid",                                null: false
    t.string   "status",              default: "new", null: false
    t.string   "transcoder_job_id"
    t.text     "transcoder_job_data"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["uuid"], name: "index_video_uploads_on_uuid", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.integer  "video_upload_id",                 null: false
    t.string   "title"
    t.string   "status",          default: "new", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

end
