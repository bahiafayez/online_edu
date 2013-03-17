class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name
      t.string :url
      t.integer :group_id
      t.integer :course_id

      t.timestamps
    end
  end
end
