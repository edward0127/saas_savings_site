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

ActiveRecord::Schema[8.1].define(version: 2026_02_24_070326) do
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
end
