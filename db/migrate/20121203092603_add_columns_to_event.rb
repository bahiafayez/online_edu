class AddColumnsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :group_id, :integer
    add_column :events, :quiz_id, :integer
    add_column :events, :lecture_id, :integer
    add_column :events, :course_id, :integer
  end
end
