class Answer < ActiveRecord::Base
  
  belongs_to :question
  
  attr_accessible :content, :correct, :question_id
  
  validates :content, :presence => true
  before_destroy :delete_quiz_grades

  private
    def delete_quiz_grades
      #self.class.delete_all "parent_id = #{id}"
      QuizGrade.destroy_all("answer_id = #{id}")
    end
    
end
