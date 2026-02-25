# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_25_203100) do
  create_table "app_settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "mail_from_email", null: false
    t.string "owner_email", null: false
    t.string "smtp_address"
    t.string "smtp_authentication"
    t.string "smtp_domain"
    t.boolean "smtp_enable_starttls", default: true, null: false
    t.string "smtp_password"
    t.integer "smtp_port"
    t.string "smtp_username"
    t.datetime "updated_at", null: false
  end

  create_table "landing_pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "cta_body"
    t.string "cta_title"
    t.text "hero_subtitle", null: false
    t.string "hero_title", null: false
    t.text "intro"
    t.string "meta_description", null: false
    t.text "problem_points"
    t.string "problem_title", null: false
    t.boolean "published", default: true, null: false
    t.string "slug", null: false
    t.text "solution_points"
    t.string "solution_title", null: false
    t.string "target_keyword"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["published"], name: "index_landing_pages_on_published"
    t.index ["slug"], name: "index_landing_pages_on_slug", unique: true
  end

  create_table "leads", force: :cascade do |t|
    t.string "company"
    t.datetime "created_at", null: false
    t.text "current_tools"
    t.string "email", null: false
    t.text "message"
    t.integer "monthly_spend"
    t.string "name", null: false
    t.string "source_page"
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_leads_on_created_at"
    t.index ["email"], name: "index_leads_on_email"
  end

  create_table "visits", force: :cascade do |t|
    t.boolean "bot", default: false, null: false
    t.datetime "created_at", null: false
    t.string "http_method", null: false
    t.string "ip_address", null: false
    t.datetime "occurred_at", null: false
    t.string "path", null: false
    t.text "referer"
    t.datetime "updated_at", null: false
    t.text "user_agent"
    t.string "visitor_key", null: false
    t.index ["bot"], name: "index_visits_on_bot"
    t.index ["occurred_at", "visitor_key"], name: "index_visits_on_occurred_at_and_visitor_key"
    t.index ["occurred_at"], name: "index_visits_on_occurred_at"
    t.index ["path"], name: "index_visits_on_path"
    t.index ["visitor_key"], name: "index_visits_on_visitor_key"
  end
end
