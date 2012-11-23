class AddColumnsToQuiz < ActiveRecord::Migration
  def change
    add_column :quizzes, :due_date, :datetime
    add_column :quizzes, :appearance_time, :datetime
  end
end
