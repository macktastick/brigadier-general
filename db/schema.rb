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

ActiveRecord::Schema.define(version: 20180319020341) do

  create_table "alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "post_id"
    t.integer "observation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "threshold_type"
  end

  create_table "bot_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "email"
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bot_votes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "bot_user_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bot_user_id"], name: "index_bot_votes_on_bot_user_id"
    t.index ["post_id"], name: "index_bot_votes_on_post_id"
  end

  create_table "links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "post_id"
    t.string "origin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_links_on_post_id"
  end

  create_table "observations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "post_id"
    t.integer "up_votes"
    t.integer "down_votes"
    t.integer "comment_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "reddit_id"
    t.string "title", limit: 512
    t.string "permalink"
    t.bigint "subreddit_id"
    t.boolean "notified"
    t.integer "remote_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "status"
    t.index ["subreddit_id"], name: "index_posts_on_subreddit_id"
  end

  create_table "subreddits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name"
    t.string "notify"
    t.integer "post_monitoring_period"
    t.boolean "coarse_filter_enabled"
    t.integer "coarse_filter_period"
    t.integer "coarse_filter_up_vote_threshold"
    t.integer "coarse_filter_comment_threshold"
    t.boolean "medium_filter_enabled"
    t.integer "medium_filter_period"
    t.integer "medium_filter_up_vote_threshold"
    t.integer "medium_filter_comment_threshold"
    t.boolean "fine_filter_enabled"
    t.integer "fine_filter_period"
    t.integer "fine_filter_up_vote_threshold"
    t.integer "fine_filter_comment_threshold"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bot_votes", "bot_users"
  add_foreign_key "bot_votes", "posts"
  add_foreign_key "links", "posts"
end
