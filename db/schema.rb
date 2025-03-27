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

ActiveRecord::Schema[8.0].define(version: 2025_03_27_132847) do
  create_table "enterprises", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guides", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "visibility"
    t.string "slug"
    t.integer "owner_id", null: false
    t.integer "enterprise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_guides_on_enterprise_id"
    t.index ["owner_id"], name: "index_guides_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password"
    t.integer "role"
    t.integer "enterprise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_users_on_enterprise_id"
  end

  add_foreign_key "guides", "enterprises"
  add_foreign_key "guides", "owners"
  add_foreign_key "users", "enterprises"
end
