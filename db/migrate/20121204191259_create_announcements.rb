class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.text :announcement
      t.datetime :date
      t.integer :course_id
      t.integer :user_id

      t.timestamps
    end
  end
end
