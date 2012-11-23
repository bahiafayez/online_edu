class LectureQuestion < ActiveRecord::Base
  attr_accessible :course_id, :lecture_id, :question, :time, :user_id
end
