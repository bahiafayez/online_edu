class Document < ActiveRecord::Base
  belongs_to :group
  attr_accessible :course_id, :group_id, :name, :url
end
