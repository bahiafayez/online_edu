class Enrollment < ActiveRecord::Base
  
  belongs_to :course
  belongs_to :user
  
  attr_accessible :course_id, :user_id
  
end
