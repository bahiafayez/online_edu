class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :short_name
      t.string :name
      t.date :start_date
      t.integer :duration
      t.text :description
      t.text :prerequisites
      t.integer :user_id

      t.timestamps
    end
  end
end
