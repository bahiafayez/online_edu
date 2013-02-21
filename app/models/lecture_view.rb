class LectureView < ActiveRecord::Base
  attr_accessible :course_id, :lecture_id, :user_id, :percent, :updated_at
  
  validates :course_id, :lecture_id, :user_id, :presence => true  #:percent
end
