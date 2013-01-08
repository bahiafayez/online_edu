class Evaluation < ActiveRecord::Base
  attr_accessible :course_id, :evaluation, :group_id, :lecture_id, :user_id
  
  validates :evaluation, :course_id, :group_id, :lecture_id, :user_id, :presence => true
end
