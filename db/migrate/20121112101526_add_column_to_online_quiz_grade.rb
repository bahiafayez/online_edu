class AddColumnToOnlineQuizGrade < ActiveRecord::Migration
  def change
    add_column :online_quiz_grades, :lecture_id, :integer
  end
end
