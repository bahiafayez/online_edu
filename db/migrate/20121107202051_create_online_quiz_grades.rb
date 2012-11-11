class CreateOnlineQuizGrades < ActiveRecord::Migration
  def change
    create_table :online_quiz_grades do |t|
      t.integer :user_id
      t.integer :online_quiz_id
      t.integer :online_answer_id
      t.float :grade

      t.timestamps
    end
  end
end
