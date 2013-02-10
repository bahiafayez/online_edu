class AddStringIdToCourse < ActiveRecord::Migration
  def self.up
    add_column :courses, :unique_identifier, :string
    add_index :courses, :unique_identifier, :unique => true
  end
  
  def self.down
    remove_index :courses, :column => :unique_identifier
    remove_column :courses, :unique_identifier
  end
end
