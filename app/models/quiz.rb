class Quiz < ActiveRecord::Base
  
  belongs_to :course, :touch => true
  belongs_to :group
  has_many :events
  has_many :quiz_grades , :dependent => :destroy
  has_many :quiz_statuses, :dependent => :destroy
  has_many :free_answers, :dependent => :destroy
  
  has_many :questions, :order => :id, :dependent => :destroy
  accepts_nested_attributes_for :questions, :allow_destroy => true
  
  attr_accessible :course_id, :instructions, :name, :questions_attributes, :group_id, :due_date, :appearance_time,:appearance_time_module, :due_date_module, :position, :quiz_type
  
  acts_as_list :scope => :group
  
  validates :name, :appearance_time,:due_date,:course_id, :group_id, :presence => true
  validates_inclusion_of :appearance_time_module, :due_date_module, :in => [true, false]
  #validates_associated :questions
  after_destroy :clean_up
  
  def has_not_appeared
    appearance_time > Time.zone.now.to_date
  end
  
  def present_quiz_type
     return (quiz_type||"quiz").capitalize
  end
  
  def get_survey_data
    @data=[]
    questions.where("question_type != 'Free Text Question'").each do |question|
      answers={}
      answers[question]=[]
      question.answers.each do |answer|
        answers[question]<<{answer.content => QuizGrade.where(:answer_id => answer.id).count}
      end
      @data<<answers
    end
    return @data
  end
  
  def get_survey_categories
    @data=[]
    questions.where("question_type != 'Free Text Question'").each do |question|
      answers=[]
      question.answers.each do |answer|
        answers<< answer.content 
      end
      @data<<answers
    end
    return @data
  end
  
  def get_survey_free_text
    @data={}
    questions.where(:question_type =>"Free Text Question").each do |question|
      @data[question]= FreeAnswer.where(:quiz_id => id, :question_id => question.id)
    end
    return @data
  end
  
  private
  def clean_up
    self.events.where(:lecture_id => nil).destroy_all
  end
  
end
