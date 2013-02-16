class ChangeDateTypeInTables < ActiveRecord::Migration
  def up
    change_column :groups, :appearance_time, :date
    change_column :groups, :due_date, :date
    change_column :lectures, :appearance_time, :date
    change_column :lectures, :due_date, :date
    change_column :quizzes, :appearance_time, :date
    change_column :quizzes, :due_date, :date
  end

  def down
    change_column :groups, :appearance_time, :datetime
    change_column :groups, :due_date, :datetime
    change_column :lectures, :appearance_time, :datetime
    change_column :lectures, :due_date, :datetime
    change_column :quizzes, :appearance_time, :datetime
    change_column :quizzes, :due_date, :datetime
  end
end
