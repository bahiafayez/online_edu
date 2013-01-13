class AddCheckToLecture < ActiveRecord::Migration
  def change
    add_column :lectures, :appearance_time_module, :boolean
    add_column :lectures, :due_date_module, :boolean
  end
end
