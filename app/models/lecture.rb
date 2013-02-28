class Lecture < ActiveRecord::Base
  
  validates :name, :url,:appearance_time, :due_date,:course_id, :group_id, :due_date, :presence => true
  validates_inclusion_of :appearance_time_module, :due_date_module, :in => [true, false] #not in presence because boolean false considered not present.
  has_many :online_quizzes, :dependent => :destroy, :order => "time"
  has_many :backs, :dependent => :destroy
  has_many :confuseds, :dependent => :destroy
  has_many :pauses, :dependent => :destroy
  has_many :evaluations, :dependent => :destroy
  has_many :lecture_questions, :dependent => :destroy
  has_many :lecture_views, :dependent => :destroy
  has_many :online_quiz_grades, :dependent => :destroy
  belongs_to :course, :touch => true
  belongs_to :group
  has_many :events
  after_destroy :clean_up
  
  attr_accessible :course_id, :description, :name, :url, :group_id, :appearance_time, :due_date, :duration, :slides, :appearance_time_module, :due_date_module, :position
  acts_as_list :scope => :group
  
  accepts_nested_attributes_for :online_quizzes, :allow_destroy => true

  def has_not_appeared
    return appearance_time > Time.zone.now.to_date
  end
  
  def done?(user_asking) #marks lecture as done IF all quizzes solved AND passed all 25/50/75 marks.
    lecture_quizzes=online_quizzes.pluck(:id).sort #ids of lecture quizzes
    user_quizzes=OnlineQuizGrade.where(:user_id => user_asking, :lecture_id => id).pluck(:online_quiz_id).sort  
    #will add now the marks.
    viewed=LectureView.where(:user_id => user_asking, :lecture_id => id) #, :percent => 75
    print viewed
    #print "answer iSSSSSSSSSS"
    #print user_quizzes==lecture_quizzes and !viewed.empty?
    #user_quizzes==lecture_quizzes
    # changed it because sometimes user has solved more! when a quiz is deleted..
    return ( user_quizzes&lecture_quizzes == lecture_quizzes and !viewed.empty?)
    
    
    
  end
  
  def edit_url
    return "Edit URL"
  end
  
    def get_data
    data={}
     online_quizzes.each do |quiz|
        data[quiz.id]=[]
        quiz.online_answers.each do |answer|
          data[quiz.id]<< OnlineQuizGrade.where(:online_quiz_id => quiz.id, :online_answer_id => answer.id, :lecture_id => id).count
        end
      end
    return data
  end
  
  def get_colors
    colors={}
      online_quizzes.each do |quiz|
        colors[quiz.id]=[]
        quiz.online_answers.each do |answer|
          color = if answer.correct
                    "green"
                  else
                    "gray"
                  end
          colors[quiz.id]<< color
        end
      end
    return colors
  end
  
  def get_categories
    data={}
      online_quizzes.each do |quiz|
        data[quiz.id] = quiz.online_answers.map{|obj| obj=obj.answer}
      end
    return data
  end
  
  
  def get_questions
    data={}
      online_quizzes.each do |quiz|
        data[quiz.id] = [quiz.question, quiz.time]
      end
    return data
  end
  
  def get_question_ids
    data=[]
      online_quizzes.each do |quiz|
        data << quiz.id
      end
    return data
  end
  
  private
  def clean_up
    self.events.where(:quiz_id => nil).destroy_all
  end
  

end
