class AddHideToLectureQuestion < ActiveRecord::Migration
  def change
    add_column :lecture_questions, :hide, :boolean, :default => false
  end
end
