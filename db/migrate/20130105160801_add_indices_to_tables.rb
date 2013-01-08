class AddIndicesToTables < ActiveRecord::Migration
  def self.up
    add_index :announcements, :course_id
    add_index :announcements, :user_id
    add_index :answers, :question_id
    add_index :backs, :lecture_id
    add_index :backs, :course_id
    add_index :backs, :user_id
    add_index :confuseds, :lecture_id
    add_index :confuseds, :course_id
    add_index :confuseds, :user_id
    add_index :courses, :user_id
    add_index :enrollments, :user_id
    add_index :enrollments, :course_id
    add_index :evaluations, :user_id
    add_index :evaluations, :group_id
    add_index :evaluations, :course_id
    add_index :evaluations, :lecture_id
    add_index :events, :group_id
    add_index :events, :quiz_id
    add_index :events, :lecture_id
    add_index :events, :course_id
    add_index :groups, :course_id
    add_index :lecture_questions, :course_id
    add_index :lecture_questions, :lecture_id
    add_index :lecture_questions, :user_id
    add_index :lecture_views, :course_id
    add_index :lecture_views, :lecture_id
    add_index :lecture_views, :user_id
    add_index :lectures, :course_id
    add_index :lectures, :group_id
    add_index :online_answers, :online_quiz_id
    add_index :online_quiz_grades, :lecture_id
    add_index :online_quiz_grades, :user_id
    add_index :online_quiz_grades, :online_quiz_id
    add_index :online_quiz_grades, :online_answer_id
    add_index :online_quizzes, :lecture_id
    add_index :pauses, :lecture_id
    add_index :pauses, :course_id
    add_index :pauses, :user_id
    add_index :questions, :quiz_id
    add_index :quiz_grades, :user_id
    add_index :quiz_grades, :quiz_id
    add_index :quiz_grades, :question_id
    add_index :quiz_grades, :answer_id
    add_index :quiz_statuses, :user_id
    add_index :quiz_statuses, :quiz_id
    add_index :quiz_statuses, :course_id
    add_index :quizzes, :course_id
    add_index :quizzes, :group_id
    
  end
  
  def self.down
    remove_index :announcements, :column => :course_id
    remove_index :announcements, :column => :user_id
    remove_index :answers, :column => :question_id
    remove_index :backs, :column => :lecture_id
    remove_index :backs, :column => :course_id
    remove_index :backs, :column => :user_id
    remove_index :confuseds, :column => :lecture_id
    remove_index :confuseds, :column => :course_id
    remove_index :confuseds, :column => :user_id
    remove_index :courses, :column => :user_id
    remove_index :enrollments, :column => :user_id
    remove_index :enrollments, :column => :course_id
    remove_index :evaluations, :column => :user_id
    remove_index :evaluations, :column => :course_id
    remove_index :evaluations, :column => :group_id
    remove_index :evaluations, :column => :lecture_id
    remove_index :events, :column => :group_id
    remove_index :events, :column => :quiz_id
    remove_index :events, :column => :lecture_id
    remove_index :events, :column => :course_id
    remove_index :groups, :column => :course_id
    remove_index :lecture_questions, :column => :course_id
    remove_index :lecture_questions, :column => :lecture_id
    remove_index :lecture_questions, :column => :user_id
    remove_index :lecture_views, :column => :course_id
    remove_index :lecture_views, :column => :lecture_id
    remove_index :lecture_views, :column => :user_id
    remove_index :lectures, :column => :course_id
    remove_index :lectures, :column => :group_id
    remove_index :online_answers, :column => :online_quiz_id
    remove_index :online_quiz_grades, :column => :lecture_id
    remove_index :online_quiz_grades, :column => :user_id
    remove_index :online_quiz_grades, :column => :online_quiz_id
    remove_index :online_quiz_grades, :column => :online_answer_id
    remove_index :online_quizzes, :column => :lecture_id
    remove_index :pauses, :column => :lecture_id
    remove_index :pauses, :column => :course_id
    remove_index :pauses, :column => :user_id
    remove_index :questions, :column => :quiz_id
    remove_index :quiz_grades, :column => :user_id
    remove_index :quiz_grades, :column => :quiz_id
    remove_index :quiz_grades, :column => :question_id
    remove_index :quiz_grades, :column => :answer_id
    remove_index :quiz_statuses, :column => :user_id
    remove_index :quiz_statuses, :column => :quiz_id
    remove_index :quiz_statuses, :column => :course_id
    remove_index :quizzes, :column => :course_id
    remove_index :quizzes, :column => :group_id
  end
end
