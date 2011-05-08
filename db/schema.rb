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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110508124047) do

  create_table "hosts", :force => true do |t|
    t.string   "name",                               :null => false
    t.string   "url",                                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "available",       :default => false
    t.integer  "total_slots",     :default => 0
    t.integer  "available_slots", :default => 0
  end

  create_table "jobs", :force => true do |t|
    t.string   "source_file",            :null => false
    t.string   "destination_file",       :null => false
    t.integer  "preset_id",              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                  :null => false
    t.string   "remote_job_id"
    t.datetime "transcoding_started_at"
    t.integer  "host_id"
    t.string   "callback_url"
    t.string   "message"
    t.float    "progress"
    t.integer  "duration"
    t.integer  "filesize"
    t.datetime "completed_at"
  end

  add_index "jobs", ["state"], :name => "index_jobs_on_state"

  create_table "notifications", :force => true do |t|
    t.integer  "job_id"
    t.string   "type"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.datetime "notified_at"
  end

  add_index "notifications", ["job_id"], :name => "index_notifications_on_job_id"

  create_table "presets", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "parameters", :null => false
  end

  add_index "presets", ["name"], :name => "index_presets_on_name"

  create_table "state_changes", :force => true do |t|
    t.integer  "job_id"
    t.string   "state"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "state_changes", ["job_id"], :name => "index_state_changes_on_job_id"

end
