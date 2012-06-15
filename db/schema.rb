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

ActiveRecord::Schema.define(:version => 20120615145034) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.integer  "uid",        :limit => 8
    t.string   "token"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "clips", :force => true do |t|
    t.integer  "video_id"
    t.string   "source"
    t.string   "encoding_id"
    t.string   "clip_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "pluraleyes_id"
    t.boolean  "synced",        :default => false
  end

  add_index "clips", ["video_id"], :name => "index_clips_on_video_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "video_id"
  end

  create_table "encoding_profiles", :force => true do |t|
    t.string   "profile_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "place_id"
    t.integer  "user_id"
    t.date     "date"
    t.string   "eventful_id"
    t.string   "pluraleyes_id"
    t.integer  "master_track_version"
  end

  create_table "events_performers", :id => false, :force => true do |t|
    t.integer "performer_id", :null => false
    t.integer "event_id",     :null => false
  end

  create_table "feed_items", :force => true do |t|
    t.string   "action"
    t.integer  "user_id"
    t.string   "entity_type"
    t.integer  "entity_id"
    t.integer  "context_id"
    t.string   "context_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "invitations", :force => true do |t|
    t.integer  "user_id"
    t.string   "mode"
    t.string   "invitee"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "likes", ["video_id"], :name => "index_likes_on_video_id"

  create_table "master_tracks", :force => true do |t|
    t.integer  "event_id"
    t.string   "source"
    t.integer  "version"
    t.boolean  "is_ready",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "encoder_id"
  end

  create_table "meta_infos", :force => true do |t|
    t.integer  "video_id"
    t.datetime "recorded_at"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "duration"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "rotation"
  end

  create_table "performers", :force => true do |t|
    t.string   "name"
    t.string   "picture"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "place_providers", :force => true do |t|
    t.integer  "place_id"
    t.integer  "remote_id"
    t.string   "provider"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "places", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "address"
  end

  add_index "places", ["latitude", "longitude"], :name => "index_places_on_latitude_and_longitude"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "followable_id"
    t.string   "followable_type"
  end

  create_table "review_flags", :force => true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "songs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.integer  "video_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "comment_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "timings", :force => true do |t|
    t.integer  "video_id"
    t.integer  "start_time"
    t.integer  "end_time"
    t.integer  "version"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "timings", ["video_id"], :name => "index_timings_on_video_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "username"
    t.string   "phone"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "encrypted_password",        :default => "",     :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "password_salt"
    t.string   "authentication_token"
    t.date     "dob"
    t.string   "website"
    t.text     "bio"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "avatar"
    t.string   "email_notification_status", :default => "week"
    t.string   "sex"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "points",                    :default => 0
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "video_songs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "song_id"
    t.integer  "video_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "videos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "encoding_id"
    t.integer  "status",        :default => -1
    t.integer  "last_chunk_id", :default => 0
    t.string   "uuid"
    t.string   "thumbnail"
    t.string   "clip"
  end

  add_index "videos", ["event_id"], :name => "index_videos_on_event_id"

end
