class CreateLectures < ActiveRecord::Migration
  def change
    create_table :lectures do |t|
      t.integer :course_id
      t.string :name
      t.text :description
      t.string :url

      t.timestamps
    end
  end
end
