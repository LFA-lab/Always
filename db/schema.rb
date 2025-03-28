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

ActiveRecord::Schema[8.0].define(version: 2025_03_28_112502) do
  create_table "answers", force: :cascade do |t|
    t.integer "question_id", null: false
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
    t.integer "guide_id", null: false
    t.integer "user_id", null: false
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
    t.integer "owner_id", null: false
    t.integer "enterprise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_guides_on_enterprise_id"
    t.index ["owner_id"], name: "index_guides_on_owner_id"
  end

  create_table "parcours", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "enterprise_id", null: false
    t.integer "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_parcours_on_enterprise_id"
    t.index ["owner_id"], name: "index_parcours_on_owner_id"
  end

  create_table "parcours_guides", force: :cascade do |t|
    t.integer "parcours_id", null: false
    t.integer "guide_id", null: false
    t.integer "order_in_parcours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id"], name: "index_parcours_guides_on_guide_id"
    t.index ["parcours_id"], name: "index_parcours_guides_on_parcours_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "quiz_id", null: false
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.integer "guide_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id"], name: "index_quizzes_on_guide_id"
  end

  create_table "service_requests", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "description"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_service_requests_on_user_id"
  end

  create_table "steps", force: :cascade do |t|
    t.integer "guide_id", null: false
    t.integer "step_order"
    t.text "instruction_text"
    t.string "screenshot_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "visual_indicator"
    t.text "description"
    t.text "additional_text"
    t.index ["guide_id"], name: "index_steps_on_guide_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password"
    t.integer "role"
    t.integer "enterprise_id", null: false
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

  add_foreign_key "answers", "questions"
  add_foreign_key "guide_feedbacks", "guides"
  add_foreign_key "guide_feedbacks", "users"
  add_foreign_key "guides", "enterprises"
  add_foreign_key "guides", "users", column: "owner_id"
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
