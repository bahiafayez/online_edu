class OnlineAnswer < ActiveRecord::Base
  
  belongs_to :online_quiz
  
  attr_accessible :answer, :online_quiz_id, :xcoor, :ycoor
end
