class Enrollment < ActiveRecord::Base
  
  belongs_to :course
  belongs_to :user, :touch => true #so when enrollments change, it affect the associated user. (updated_at column)
  
  attr_accessible :course_id, :user_id
  
  # user y can be enrolled in course x once only
  validates_uniqueness_of :user_id,  :scope => :course_id #the pair course_id user_id must be unique

end
