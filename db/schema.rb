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

ActiveRecord::Schema[7.1].define(version: 2025_03_31_172500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.string "text"
    t.boolean "correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "enterprises", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guide_feedbacks", force: :cascade do |t|
    t.bigint "guide_id", null: false
    t.bigint "user_id", null: false
    t.integer "stars"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "time_saved", default: 0
    t.index ["guide_id"], name: "index_guide_feedbacks_on_guide_id"
    t.index ["user_id"], name: "index_guide_feedbacks_on_user_id"
  end

  create_table "guides", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "visibility"
    t.string "slug"
    t.bigint "owner_id", null: false
    t.bigint "enterprise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_guides_on_enterprise_id"
    t.index ["owner_id"], name: "index_guides_on_owner_id"
  end

  create_table "interactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "guide_id"
    t.string "action_type", null: false
    t.string "element_type", null: false
    t.string "element_selector", null: false
    t.text "element_text"
    t.string "screenshot_url"
    t.datetime "timestamp", null: false
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id", "created_at"], name: "index_interactions_on_guide_id_and_created_at"
    t.index ["guide_id"], name: "index_interactions_on_guide_id"
    t.index ["user_id", "created_at"], name: "index_interactions_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_interactions_on_user_id"
  end

  create_table "parcours", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "enterprise_id", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_parcours_on_enterprise_id"
    t.index ["owner_id"], name: "index_parcours_on_owner_id"
  end

  create_table "parcours_guides", force: :cascade do |t|
    t.bigint "parcours_id", null: false
    t.bigint "guide_id", null: false
    t.integer "order_in_parcours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id"], name: "index_parcours_guides_on_guide_id"
    t.index ["parcours_id"], name: "index_parcours_guides_on_parcours_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "quiz_id", null: false
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.bigint "guide_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id"], name: "index_quizzes_on_guide_id"
  end

  create_table "service_requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "description"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_service_requests_on_user_id"
  end

  create_table "steps", force: :cascade do |t|
    t.bigint "guide_id", null: false
    t.integer "step_order"
    t.text "instruction_text"
    t.string "screenshot_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "element_selector"
    t.string "element_type"
    t.text "element_text"
    t.json "coordinates"
    t.json "scroll_position"
    t.datetime "timestamp"
    t.json "browser_info"
    t.json "device_info"
    t.string "visual_indicator"
    t.text "description"
    t.text "additional_text"
    t.index ["element_type"], name: "index_steps_on_element_type"
    t.index ["guide_id"], name: "index_steps_on_guide_id"
    t.index ["timestamp"], name: "index_steps_on_timestamp"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password"
    t.integer "role"
    t.bigint "enterprise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "service"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["enterprise_id"], name: "index_users_on_enterprise_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "guide_feedbacks", "guides"
  add_foreign_key "guide_feedbacks", "users"
  add_foreign_key "guides", "enterprises"
  add_foreign_key "guides", "users", column: "owner_id"
  add_foreign_key "interactions", "guides"
  add_foreign_key "interactions", "users"
  add_foreign_key "parcours", "enterprises"
  add_foreign_key "parcours", "users", column: "owner_id"
  add_foreign_key "parcours_guides", "guides"
  add_foreign_key "parcours_guides", "parcours", column: "parcours_id"
  add_foreign_key "questions", "quizzes"
  add_foreign_key "quizzes", "guides"
  add_foreign_key "service_requests", "users"
  add_foreign_key "steps", "guides"
  add_foreign_key "users", "enterprises"
end
