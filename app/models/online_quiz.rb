class OnlineQuiz < ActiveRecord::Base
  
  belongs_to :lecture
  has_many :online_answers
  
  attr_accessible :lecture_id, :question, :time
end
