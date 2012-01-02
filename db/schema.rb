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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120102223020) do

  create_table "idea_categories", :force => true do |t|
    t.text     "name",                         :null => false
    t.text     "badge",                        :null => false
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ideas", :force => true do |t|
    t.integer  "user_id",                             :null => false
    t.integer  "parent_id"
    t.text     "title",                               :null => false
    t.text     "headline",                            :null => false
    t.text     "description",                         :null => false
    t.boolean  "featured",         :default => false, :null => false
    t.boolean  "recommend",        :default => false, :null => false
    t.integer  "likes",            :default => 0,     :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "idea_category_id", :default => 0
  end

  create_table "services", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.text     "provider",   :null => false
    t.text     "uid",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.text     "name",       :null => false
    t.text     "email",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "ideas", "ideas", :name => "ideas_parent_id_fk", :column => "parent_id"
  add_foreign_key "ideas", "users", :name => "ideas_user_id_fk"

  add_foreign_key "services", "users", :name => "services_user_id_fk"

end
