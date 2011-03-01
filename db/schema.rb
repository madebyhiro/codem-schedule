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

ActiveRecord::Schema.define(:version => 20110301103457) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "hosts", :force => true do |t|
    t.string   "address",                              :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "status_checked_at"
    t.integer  "total_slots",       :default => 0
    t.integer  "available_slots",   :default => 0
    t.boolean  "available",         :default => false
  end

  create_table "jobs", :force => true do |t|
    t.string   "source_file",                                                   :null => false
    t.string   "duration"
    t.integer  "filesize"
    t.string   "progress",               :limit => 6,  :default => "0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "host_id"
    t.string   "destination_file",                                              :null => false
    t.integer  "preset_id",                                                     :null => false
    t.string   "remote_jobid"
    t.string   "state",                  :limit => 25, :default => "scheduled", :null => false
    t.datetime "transcoding_started_at"
    t.datetime "completed_at"
  end

  add_index "jobs", ["host_id"], :name => "index_jobs_on_host_id"

  create_table "notifications", :force => true do |t|
    t.integer  "preset_id"
    t.string   "kind"
    t.string   "value"
    t.datetime "sent_at"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "presets", :force => true do |t|
    t.string   "name",       :null => false
    t.text     "parameters"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "state_changes", :force => true do |t|
    t.integer  "job_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
