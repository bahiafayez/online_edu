class OnlineAnswer < ActiveRecord::Base
  
  belongs_to :online_quiz
  validates :xcoor, :ycoor, :presence => true
  #validates :xcoor, :ycoor, :format => {:with => /^[0-9]*$/ , :message => "Invalid Number"}
  
  attr_accessible :answer, :online_quiz_id, :xcoor, :ycoor, :correct, :explanation
  before_destroy :delete_all_data

  private
    def delete_all_data
      #self.class.delete_all "parent_id = #{id}"
      OnlineQuizGrade.destroy_all("online_answer_id = #{id}")
    end
end
