class AddAppearanceToLecture < ActiveRecord::Migration
  def change
    add_column :lectures, :appearance_time, :datetime
  end
end
