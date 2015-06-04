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

ActiveRecord::Schema.define(version: 20150604191219) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applicants", force: :cascade do |t|
    t.boolean  "compAccept"
    t.boolean  "userAccept"
    t.integer  "job_posting_id"
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "company_id"
    t.boolean  "compreject",     default: false
    t.boolean  "userreject",     default: false
  end

  add_index "applicants", ["job_posting_id", "created_at"], name: "index_applicants_on_job_posting_id_and_created_at", using: :btree
  add_index "applicants", ["job_posting_id"], name: "index_applicants_on_job_posting_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "location"
    t.integer  "size"
    t.text     "description"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated"
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "picture"
    t.string   "website"
    t.string   "province"
    t.integer  "matchcount",        default: 0
    t.integer  "offercount",        default: 0
    t.integer  "totalalerts",       default: 0
  end

  add_index "companies", ["email"], name: "index_companies_on_email", unique: true, using: :btree

  create_table "job_postings", force: :cascade do |t|
    t.string   "title"
    t.string   "location"
    t.text     "description"
    t.integer  "company_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "views"
    t.string   "province"
    t.string   "type"
    t.string   "sector"
    t.integer  "hours"
    t.string   "length"
    t.boolean  "userreject"
    t.boolean  "companyreject"
    t.integer  "matchcount",    default: 0
    t.integer  "offercount",    default: 0
  end

  add_index "job_postings", ["company_id", "created_at"], name: "index_job_postings_on_company_id_and_created_at", using: :btree
  add_index "job_postings", ["company_id"], name: "index_job_postings_on_company_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "location"
    t.text     "experience"
    t.text     "accomplishment"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated"
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "picture"
    t.string   "resume"
    t.string   "province"
    t.string   "profession"
    t.string   "sector"
    t.integer  "years"
    t.string   "lastname"
    t.integer  "matchcount",        default: 0
    t.integer  "offercount",        default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "applicants", "job_postings"
  add_foreign_key "job_postings", "companies"
end
