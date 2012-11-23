class AddColumnToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :time_zone, :string
  end
end
