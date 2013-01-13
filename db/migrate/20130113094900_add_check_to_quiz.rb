class AddCheckToQuiz < ActiveRecord::Migration
  def change
    add_column :quizzes, :appearance_time_module, :boolean
    add_column :quizzes, :due_date_module, :boolean
  end
end
