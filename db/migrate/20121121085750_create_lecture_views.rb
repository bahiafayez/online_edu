class CreateLectureViews < ActiveRecord::Migration
  def change
    create_table :lecture_views do |t|
      t.integer :user_id
      t.integer :lecture_id
      t.integer :course_id

      t.timestamps
    end
  end
end
