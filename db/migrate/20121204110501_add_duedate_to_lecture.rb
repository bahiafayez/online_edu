class AddDuedateToLecture < ActiveRecord::Migration
  def change
    add_column :lectures, :due_date, :datetime
  end
end
