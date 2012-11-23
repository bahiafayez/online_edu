class AddAppearanceToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :appearance_time, :datetime
  end
end
