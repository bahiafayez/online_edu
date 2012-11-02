class ChangeColumnInQuiz < ActiveRecord::Migration
  def up
    change_column :quizzes, :instructions, :text
  end

  def down
    change_column :quizzes, :instructions, :string
  end
end
