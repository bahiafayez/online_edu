class OnlineQuiz < ActiveRecord::Base
  
  belongs_to :lecture
  has_many :online_answers, :dependent => :destroy
  
  attr_accessible :lecture_id, :question, :time, :created_at
  validates :time, :presence => true
  
  
  def formatted_time
    return Time.at(time).utc.strftime("%H:%M:%S")
  end
end
