class OnlineQuizGrade < ActiveRecord::Base
  attr_accessible :grade, :online_answer_id, :online_quiz_id, :user_id, :lecture_id, :created_at
  
  validates :online_answer_id, :online_quiz_id, :user_id, :lecture_id, :presence => true
end

#test
