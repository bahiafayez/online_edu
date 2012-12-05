class AddDuedateToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :due_date, :datetime
  end
end
