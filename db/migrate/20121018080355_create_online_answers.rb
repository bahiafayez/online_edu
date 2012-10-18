class CreateOnlineAnswers < ActiveRecord::Migration
  def change
    create_table :online_answers do |t|
      t.integer :online_quiz_id
      t.text :answer
      t.float :xcoor
      t.float :ycoor

      t.timestamps
    end
  end
end
