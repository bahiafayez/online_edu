class AddPercentToLectureView < ActiveRecord::Migration
  def change
    add_column :lecture_views, :percent, :integer
  end
end
