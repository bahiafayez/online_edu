class AddDiscussionLinkToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :discussion_link, :string, :default => ""
  end
end
