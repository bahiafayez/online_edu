class CreateFreeAnswers < ActiveRecord::Migration
  def change
    create_table :free_answers do |t|
      t.integer :user_id
      t.integer :quiz_id
      t.integer :question_id
      t.text :answer

      t.timestamps
    end
  end
end
