class Announcement < ActiveRecord::Base
  attr_accessible :announcement, :course_id, :date, :user_id
  
  validates :announcement, :presence => true
  
  belongs_to :user
  belongs_to :course
end
