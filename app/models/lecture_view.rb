class LectureView < ActiveRecord::Base
  attr_accessible :course_id, :lecture_id, :user_id
end
