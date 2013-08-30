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

ActiveRecord::Schema.define(version: 20130830174841) do

  create_table "education_items", force: true do |t|
    t.integer  "programmer_id"
    t.string   "school_name"
    t.string   "degree_and_major"
    t.text     "description"
    t.integer  "year_started"
    t.integer  "year_finished"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "github_repos", force: true do |t|
    t.integer  "programmer_id"
    t.string   "repo_owner"
    t.string   "repo_name"
    t.boolean  "hidden"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "default_branch"
    t.integer  "forks_count"
    t.integer  "stars_count"
    t.string   "language"
    t.boolean  "is_fork"
  end

  create_table "portfolio_items", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programmers", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.integer  "rate"
    t.string   "availability"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "onsite_status"
    t.boolean  "contract_to_hire"
    t.string   "visibility"
    t.boolean  "disabled"
  end

  create_table "resume_items", force: true do |t|
    t.integer  "programmer_id"
    t.string   "company_name"
    t.string   "title"
    t.integer  "year_started"
    t.integer  "year_finished"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "month_started"
    t.string   "month_finished"
  end

  create_table "skills", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_accounts", force: true do |t|
    t.string   "account_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "oauth_token"
    t.string   "username"
  end

  add_index "user_accounts", ["account_id", "type"], name: "index_user_accounts_on_account_id_and_type", unique: true

  create_table "user_skills", force: true do |t|
    t.integer  "user_id"
    t.integer  "skill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.boolean  "checked_terms"
    t.string   "country"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
