class AddColumnToLecture < ActiveRecord::Migration
  def change
    add_column :lectures, :group_id, :integer
  end
end
