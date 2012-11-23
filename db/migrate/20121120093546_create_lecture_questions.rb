class CreateLectureQuestions < ActiveRecord::Migration
  def change
    create_table :lecture_questions do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :lecture_id
      t.float :time
      t.text :question

      t.timestamps
    end
  end
end
