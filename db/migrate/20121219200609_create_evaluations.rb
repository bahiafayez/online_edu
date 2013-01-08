class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :group_id
      t.integer :lecture_id
      t.text :evaluation

      t.timestamps
    end
  end
end
