class CreateQuizGrades < ActiveRecord::Migration
  def change
    create_table :quiz_grades do |t|
      t.integer :user_id
      t.integer :quiz_id
      t.integer :question_id
      t.integer :answer_id
      t.float :grade

      t.timestamps
    end
  end
end
