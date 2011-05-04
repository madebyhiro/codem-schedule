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

ActiveRecord::Schema.define(:version => 20110504100112) do

  create_table "hosts", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "url",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.string   "source_file",      :null => false
    t.string   "destination_file", :null => false
    t.integer  "preset_id",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",            :null => false
  end

  add_index "jobs", ["state"], :name => "index_jobs_on_state"

  create_table "presets", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "parameters", :null => false
  end

  add_index "presets", ["name"], :name => "index_presets_on_name"

end
