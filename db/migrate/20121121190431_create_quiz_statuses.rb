class CreateQuizStatuses < ActiveRecord::Migration
  def change
    create_table :quiz_statuses do |t|
      t.integer :user_id
      t.integer :quiz_id
      t.integer :course_id
      t.string :status

      t.timestamps
    end
  end
end
