class CreatePauses < ActiveRecord::Migration
  def change
    create_table :pauses do |t|
      t.integer :lecture_id
      t.integer :course_id
      t.integer :user_id
      t.float :time

      t.timestamps
    end
  end
end
