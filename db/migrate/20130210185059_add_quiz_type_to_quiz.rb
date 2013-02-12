class AddQuizTypeToQuiz < ActiveRecord::Migration
  def change
    add_column :quizzes, :quiz_type, :string
  end
end
