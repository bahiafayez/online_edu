class AddColumnToQuiz < ActiveRecord::Migration
  def change
    add_column :quizzes, :group_id, :integer
  end
end
