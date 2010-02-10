# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100209073536) do

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genders", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monologues", :force => true do |t|
    t.integer  "play_id"
    t.string   "location"
    t.string   "first_line"
    t.text     "body"
    t.integer  "gender_id"
    t.string   "character"
    t.string   "style"
    t.string   "pdf_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "body_link"
    t.integer  "intercut"
  end

  create_table "plays", :force => true do |t|
    t.integer  "author_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "classification"
  end

end
