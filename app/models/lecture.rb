class Lecture < ActiveRecord::Base
  
  validates :name, :url,:appearance_time , :presence => true
  has_many :online_quizzes, :dependent => :destroy
  belongs_to :course
  belongs_to :group
  has_many :events
  after_destroy :clean_up
  
  attr_accessible :course_id, :description, :name, :url, :group_id, :appearance_time, :due_date, :duration, :slides
  
  accepts_nested_attributes_for :online_quizzes, :allow_destroy => true

  def has_not_appeared
    return appearance_time >= Time.zone.now
  end
  
  def done?(user_asking) #marks lecture as done IF all quizzes solved AND passed all 25/50/75 marks.
    lecture_quizzes=online_quizzes.pluck(:id).sort #ids of lecture quizzes
    user_quizzes=OnlineQuizGrade.where(:user_id => user_asking, :lecture_id => id).pluck(:online_quiz_id).sort  
    #will add now the marks.
    viewed=LectureView.where(:user_id => user_asking, :lecture_id => id, :percent => 75)
    
    return (user_quizzes==lecture_quizzes and !viewed.empty?)
    
    
    
  end
  
  private
  def clean_up
    self.events.where(:quiz_id => nil).destroy_all
  end
  

end
