class AddSlidesToLecture < ActiveRecord::Migration
  def change
    add_column :lectures, :slides, :string
  end
end
