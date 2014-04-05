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

ActiveRecord::Schema.define(version: 20140307050336) do

  create_table "comments", force: true do |t|
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "poi_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "approved"
    t.integer  "User_id"
    t.string   "name"
  end

  add_index "comments", ["User_id"], name: "index_comments_on_User_id"
  add_index "comments", ["poi_id"], name: "index_comments_on_poi_id"

  create_table "images", force: true do |t|
    t.integer  "poi_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "poi_image_file_name"
    t.string   "poi_image_content_type"
    t.integer  "poi_image_file_size"
    t.datetime "poi_image_updated_at"
    t.integer  "user_id"
  end

  add_index "images", ["poi_id"], name: "index_images_on_poi_id"
  add_index "images", ["user_id"], name: "index_images_on_user_id"

  create_table "pois", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.text     "description"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "pois", ["user_id"], name: "index_pois_on_user_id"

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",               default: "",     null: false
    t.string   "encrypted_password",  default: "",     null: false
    t.datetime "remember_created_at"
    t.string   "role",                default: "user", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "verified",            default: false
    t.string   "about_me"
    t.string   "private_web_url"
    t.string   "first_name",          default: "",     null: false
    t.string   "last_name",           default: "",     null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "provider"
    t.string   "uid"
    t.text     "requestedRole"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
