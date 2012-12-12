class AddDurationToLecture < ActiveRecord::Migration
  def change
    add_column :lectures, :duration, :float
  end
end
