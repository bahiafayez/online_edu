class CreateOnlineQuizzes < ActiveRecord::Migration
  def change
    create_table :online_quizzes do |t|
      t.integer :lecture_id
      t.text :question
      t.float :time

      t.timestamps
    end
  end
end
