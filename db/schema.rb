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

ActiveRecord::Schema.define(version: 20131103184303) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: true do |t|
    t.integer  "user_id"
    t.string   "company"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["user_id"], name: "index_clients_on_user_id", using: :btree

  create_table "education_items", force: true do |t|
    t.integer  "programmer_id"
    t.string   "school_name"
    t.string   "degree_and_major"
    t.text     "description"
    t.integer  "year_started"
    t.integer  "year_finished"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "month_started"
    t.integer  "month_finished"
    t.boolean  "is_current"
  end

  add_index "education_items", ["programmer_id"], name: "index_education_items_on_programmer_id", using: :btree

  create_table "github_repos", force: true do |t|
    t.integer  "programmer_id"
    t.string   "repo_owner"
    t.string   "repo_name"
    t.boolean  "shown"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "default_branch"
    t.integer  "forks_count"
    t.integer  "stars_count"
    t.string   "language"
    t.boolean  "is_fork"
    t.text     "description"
    t.integer  "contributions"
  end

  add_index "github_repos", ["programmer_id"], name: "index_github_repos_on_programmer_id", using: :btree

  create_table "job_messages", force: true do |t|
    t.integer  "job_id"
    t.boolean  "sender_is_client"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_messages", ["job_id"], name: "index_job_messages_on_job_id", using: :btree

  create_table "jobs", force: true do |t|
    t.integer  "programmer_id"
    t.integer  "client_id"
    t.string   "state"
    t.integer  "rate"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "availability"
  end

  add_index "jobs", ["client_id"], name: "index_jobs_on_client_id", using: :btree
  add_index "jobs", ["programmer_id"], name: "index_jobs_on_programmer_id", using: :btree

  create_table "payment_infos", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "balanced_customer_uri"
  end

  add_index "payment_infos", ["user_id"], name: "index_payment_infos_on_user_id", using: :btree

  create_table "portfolio_items", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "programmer_id"
  end

  add_index "portfolio_items", ["programmer_id"], name: "index_portfolio_items_on_programmer_id", using: :btree

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
    t.string   "state"
    t.boolean  "qualified"
  end

  add_index "programmers", ["user_id"], name: "index_programmers_on_user_id", using: :btree

  create_table "programmers_skills", id: false, force: true do |t|
    t.integer  "programmer_id"
    t.integer  "skill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "month_started"
    t.integer  "month_finished"
    t.boolean  "is_current"
  end

  add_index "resume_items", ["programmer_id"], name: "index_resume_items_on_programmer_id", using: :btree

  create_table "skills", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skills", ["name"], name: "index_skills_on_name", using: :btree

  create_table "user_accounts", force: true do |t|
    t.string   "account_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "username"
    t.string   "encrypted_oauth_token"
    t.string   "encrypted_oauth_token_salt"
    t.string   "encrypted_oauth_token_iv"
  end

  add_index "user_accounts", ["user_id"], name: "index_user_accounts_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.boolean  "checked_terms"
    t.string   "country"
    t.string   "city"
    t.string   "state"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
