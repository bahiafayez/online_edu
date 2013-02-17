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

ActiveRecord::Schema.define(:version => 20130217091012) do

  create_table "active_admin_comments", :force => true do |t|
    t.string    "resource_id",   :null => false
    t.string    "resource_type", :null => false
    t.integer   "author_id"
    t.string    "author_type"
    t.text      "body"
    t.timestamp "created_at",    :null => false
    t.timestamp "updated_at",    :null => false
    t.string    "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string    "email",                  :default => "", :null => false
    t.string    "encrypted_password",     :default => "", :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",          :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at",                             :null => false
    t.timestamp "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "announcements", :force => true do |t|
    t.text      "announcement"
    t.timestamp "date"
    t.integer   "course_id"
    t.integer   "user_id"
    t.timestamp "created_at",   :null => false
    t.timestamp "updated_at",   :null => false
  end

  add_index "announcements", ["course_id"], :name => "index_announcements_on_course_id"
  add_index "announcements", ["user_id"], :name => "index_announcements_on_user_id"

  create_table "answers", :force => true do |t|
    t.integer   "question_id"
    t.text      "content"
    t.boolean   "correct"
    t.timestamp "created_at",  :null => false
    t.timestamp "updated_at",  :null => false
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "backs", :force => true do |t|
    t.integer   "lecture_id"
    t.integer   "course_id"
    t.integer   "user_id"
    t.float     "time"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "backs", ["course_id"], :name => "index_backs_on_course_id"
  add_index "backs", ["lecture_id"], :name => "index_backs_on_lecture_id"
  add_index "backs", ["user_id"], :name => "index_backs_on_user_id"

  create_table "confuseds", :force => true do |t|
    t.integer   "user_id"
    t.integer   "course_id"
    t.integer   "lecture_id"
    t.float     "time"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "confuseds", ["course_id"], :name => "index_confuseds_on_course_id"
  add_index "confuseds", ["lecture_id"], :name => "index_confuseds_on_lecture_id"
  add_index "confuseds", ["user_id"], :name => "index_confuseds_on_user_id"

  create_table "courses", :force => true do |t|
    t.string    "short_name"
    t.string    "name"
    t.date      "start_date"
    t.integer   "duration"
    t.text      "description"
    t.text      "prerequisites"
    t.integer   "user_id"
    t.timestamp "created_at",        :null => false
    t.timestamp "updated_at",        :null => false
    t.string    "time_zone"
    t.string    "unique_identifier"
  end

  add_index "courses", ["unique_identifier"], :name => "index_courses_on_unique_identifier", :unique => true
  add_index "courses", ["user_id"], :name => "index_courses_on_user_id"

  create_table "enrollments", :force => true do |t|
    t.integer   "user_id"
    t.integer   "course_id"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "enrollments", ["course_id"], :name => "index_enrollments_on_course_id"
  add_index "enrollments", ["user_id"], :name => "index_enrollments_on_user_id"

  create_table "evaluations", :force => true do |t|
    t.integer   "user_id"
    t.integer   "course_id"
    t.integer   "group_id"
    t.integer   "lecture_id"
    t.text      "evaluation"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "evaluations", ["course_id"], :name => "index_evaluations_on_course_id"
  add_index "evaluations", ["group_id"], :name => "index_evaluations_on_group_id"
  add_index "evaluations", ["lecture_id"], :name => "index_evaluations_on_lecture_id"
  add_index "evaluations", ["user_id"], :name => "index_evaluations_on_user_id"

  create_table "events", :force => true do |t|
    t.string    "name"
    t.timestamp "start_at"
    t.timestamp "end_at"
    t.string    "color"
    t.boolean   "all_day"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
    t.integer   "group_id"
    t.integer   "quiz_id"
    t.integer   "lecture_id"
    t.integer   "course_id"
  end

  add_index "events", ["course_id"], :name => "index_events_on_course_id"
  add_index "events", ["group_id"], :name => "index_events_on_group_id"
  add_index "events", ["lecture_id"], :name => "index_events_on_lecture_id"
  add_index "events", ["quiz_id"], :name => "index_events_on_quiz_id"

  create_table "free_answers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "quiz_id"
    t.integer  "question_id"
    t.text     "answer"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "course_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.date     "appearance_time"
    t.integer  "position"
    t.date     "due_date"
  end

  add_index "groups", ["course_id"], :name => "index_groups_on_course_id"

  create_table "lecture_questions", :force => true do |t|
    t.integer   "user_id"
    t.integer   "course_id"
    t.integer   "lecture_id"
    t.float     "time"
    t.text      "question"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "lecture_questions", ["course_id"], :name => "index_lecture_questions_on_course_id"
  add_index "lecture_questions", ["lecture_id"], :name => "index_lecture_questions_on_lecture_id"
  add_index "lecture_questions", ["user_id"], :name => "index_lecture_questions_on_user_id"

  create_table "lecture_views", :force => true do |t|
    t.integer   "user_id"
    t.integer   "lecture_id"
    t.integer   "course_id"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
    t.integer   "percent"
  end

  add_index "lecture_views", ["course_id"], :name => "index_lecture_views_on_course_id"
  add_index "lecture_views", ["lecture_id"], :name => "index_lecture_views_on_lecture_id"
  add_index "lecture_views", ["user_id"], :name => "index_lecture_views_on_user_id"

  create_table "lectures", :force => true do |t|
    t.integer  "course_id"
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "group_id"
    t.date     "appearance_time"
    t.date     "due_date"
    t.float    "duration"
    t.string   "slides"
    t.boolean  "appearance_time_module"
    t.boolean  "due_date_module"
    t.integer  "position"
  end

  add_index "lectures", ["course_id"], :name => "index_lectures_on_course_id"
  add_index "lectures", ["group_id"], :name => "index_lectures_on_group_id"

  create_table "online_answers", :force => true do |t|
    t.integer   "online_quiz_id"
    t.string    "answer",         :default => ""
    t.float     "xcoor"
    t.float     "ycoor"
    t.timestamp "created_at",                     :null => false
    t.timestamp "updated_at",                     :null => false
    t.boolean   "correct"
    t.text      "explanation",    :default => ""
  end

  add_index "online_answers", ["online_quiz_id"], :name => "index_online_answers_on_online_quiz_id"

  create_table "online_quiz_grades", :force => true do |t|
    t.integer   "user_id"
    t.integer   "online_quiz_id"
    t.integer   "online_answer_id"
    t.float     "grade"
    t.timestamp "created_at",       :null => false
    t.timestamp "updated_at",       :null => false
    t.integer   "lecture_id"
  end

  add_index "online_quiz_grades", ["lecture_id"], :name => "index_online_quiz_grades_on_lecture_id"
  add_index "online_quiz_grades", ["online_answer_id"], :name => "index_online_quiz_grades_on_online_answer_id"
  add_index "online_quiz_grades", ["online_quiz_id"], :name => "index_online_quiz_grades_on_online_quiz_id"
  add_index "online_quiz_grades", ["user_id"], :name => "index_online_quiz_grades_on_user_id"

  create_table "online_quizzes", :force => true do |t|
    t.integer   "lecture_id"
    t.text      "question"
    t.float     "time"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "online_quizzes", ["lecture_id"], :name => "index_online_quizzes_on_lecture_id"

  create_table "pauses", :force => true do |t|
    t.integer   "lecture_id"
    t.integer   "course_id"
    t.integer   "user_id"
    t.float     "time"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "pauses", ["course_id"], :name => "index_pauses_on_course_id"
  add_index "pauses", ["lecture_id"], :name => "index_pauses_on_lecture_id"
  add_index "pauses", ["user_id"], :name => "index_pauses_on_user_id"

  create_table "questions", :force => true do |t|
    t.integer   "quiz_id"
    t.text      "content"
    t.timestamp "created_at",    :null => false
    t.timestamp "updated_at",    :null => false
    t.string    "question_type"
  end

  add_index "questions", ["quiz_id"], :name => "index_questions_on_quiz_id"

  create_table "quiz_grades", :force => true do |t|
    t.integer   "user_id"
    t.integer   "quiz_id"
    t.integer   "question_id"
    t.integer   "answer_id"
    t.float     "grade"
    t.timestamp "created_at",  :null => false
    t.timestamp "updated_at",  :null => false
  end

  add_index "quiz_grades", ["answer_id"], :name => "index_quiz_grades_on_answer_id"
  add_index "quiz_grades", ["question_id"], :name => "index_quiz_grades_on_question_id"
  add_index "quiz_grades", ["quiz_id"], :name => "index_quiz_grades_on_quiz_id"
  add_index "quiz_grades", ["user_id"], :name => "index_quiz_grades_on_user_id"

  create_table "quiz_statuses", :force => true do |t|
    t.integer   "user_id"
    t.integer   "quiz_id"
    t.integer   "course_id"
    t.string    "status"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "quiz_statuses", ["course_id"], :name => "index_quiz_statuses_on_course_id"
  add_index "quiz_statuses", ["quiz_id"], :name => "index_quiz_statuses_on_quiz_id"
  add_index "quiz_statuses", ["user_id"], :name => "index_quiz_statuses_on_user_id"

  create_table "quizzes", :force => true do |t|
    t.integer  "course_id"
    t.string   "name"
    t.text     "instructions"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "group_id"
    t.date     "due_date"
    t.date     "appearance_time"
    t.boolean  "appearance_time_module"
    t.boolean  "due_date_module"
    t.integer  "position"
    t.string   "quiz_type"
  end

  add_index "quizzes", ["course_id"], :name => "index_quizzes_on_course_id"
  add_index "quizzes", ["group_id"], :name => "index_quizzes_on_group_id"

  create_table "roles", :force => true do |t|
    t.string    "name"
    t.integer   "resource_id"
    t.string    "resource_type"
    t.timestamp "created_at",    :null => false
    t.timestamp "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "users", :force => true do |t|
    t.string    "email",                  :default => "", :null => false
    t.string    "encrypted_password",     :default => "", :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",          :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at",                             :null => false
    t.timestamp "updated_at",                             :null => false
    t.string    "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
