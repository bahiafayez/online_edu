class OnlineAnswer < ActiveRecord::Base
  
  belongs_to :online_quiz
  validates :xcoor, :ycoor, :presence => true
  #validates :xcoor, :ycoor, :format => {:with => /^[0-9]*$/ , :message => "Invalid Number"}
  
  attr_accessible :answer, :online_quiz_id, :xcoor, :ycoor, :correct, :explanation
end
