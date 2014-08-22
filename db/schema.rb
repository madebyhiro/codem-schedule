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

ActiveRecord::Schema.define(version: 20140822153109) do

  create_table "deliveries", force: true do |t|
    t.integer  "notification_id", null: false
    t.string   "state",           null: false
    t.datetime "notified_at",     null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "state_change_id"
  end

  add_index "deliveries", ["notification_id"], name: "index_deliveries_on_notification_id", using: :btree
  add_index "deliveries", ["state_change_id"], name: "index_deliveries_on_state_change_id", using: :btree

  create_table "hosts", force: true do |t|
    t.string   "name",                              null: false
    t.string   "url",                               null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "available",         default: false
    t.integer  "total_slots",       default: 0
    t.integer  "available_slots",   default: 0
    t.datetime "status_updated_at"
  end

  add_index "hosts", ["name"], name: "index_hosts_on_name", using: :btree

  create_table "jobs", force: true do |t|
    t.string   "source_file",                                             null: false
    t.string   "destination_file",                                        null: false
    t.integer  "preset_id",                                               null: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "state"
    t.string   "remote_job_id"
    t.datetime "transcoding_started_at"
    t.integer  "host_id"
    t.text     "message",                limit: 16777215
    t.float    "progress"
    t.integer  "duration"
    t.string   "filesize"
    t.datetime "completed_at"
    t.text     "arguments"
    t.boolean  "locked",                                  default: false
    t.integer  "priority",               limit: 3
    t.text     "thumbnails"
    t.string   "playlist"
    t.text     "segments"
  end

  add_index "jobs", ["completed_at"], name: "index_jobs_on_completed_at", using: :btree
  add_index "jobs", ["created_at"], name: "index_jobs_on_created_at", using: :btree
  add_index "jobs", ["source_file"], name: "index_jobs_on_source_file", using: :btree
  add_index "jobs", ["state"], name: "index_jobs_on_state", using: :btree
  add_index "jobs", ["transcoding_started_at"], name: "index_jobs_on_transcoding_started_at", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "job_id"
    t.string   "type"
    t.string   "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "state"
    t.datetime "notified_at"
  end

  add_index "notifications", ["job_id"], name: "index_notifications_on_job_id", using: :btree

  create_table "presets", force: true do |t|
    t.string   "name",              null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "parameters"
    t.text     "thumbnail_options"
    t.text     "segments_options"
  end

  add_index "presets", ["name"], name: "index_presets_on_name", using: :btree

  create_table "state_changes", force: true do |t|
    t.integer  "job_id"
    t.string   "state"
    t.text     "message",     limit: 16777215
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.float    "notified_at"
    t.integer  "position"
  end

  add_index "state_changes", ["job_id"], name: "index_state_changes_on_job_id", using: :btree
  add_index "state_changes", ["notified_at"], name: "index_state_changes_on_notified_at", using: :btree
  add_index "state_changes", ["position"], name: "index_state_changes_on_position", using: :btree

end
