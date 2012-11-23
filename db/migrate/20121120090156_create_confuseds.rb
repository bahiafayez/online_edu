class CreateConfuseds < ActiveRecord::Migration
  def change
    create_table :confuseds do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :lecture_id
      t.float :time

      t.timestamps
    end
  end
end
