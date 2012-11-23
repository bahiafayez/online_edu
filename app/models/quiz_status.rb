class QuizStatus < ActiveRecord::Base
  attr_accessible :course_id, :quiz_id, :status, :user_id
end
