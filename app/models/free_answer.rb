class FreeAnswer < ActiveRecord::Base
  attr_accessible :answer, :question_id, :quiz_id, :user_id
end
