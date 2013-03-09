class Question < ActiveRecord::Base
  
  belongs_to :quiz
  has_many :answers#, :dependent => :destroy
  accepts_nested_attributes_for :answers, :allow_destroy => true
  
  attr_accessible :content, :quiz_id, :answers_attributes, :question_type
  validates :content,:quiz_id, :presence => true
  
  before_destroy :delete_user_data
  
  private
  def delete_user_data
    FreeAnswer.destroy_all(:question_id => id)
    answers.destroy_all()
  end
  
end
