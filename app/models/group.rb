class Group < ActiveRecord::Base
  attr_accessible :course_id, :description, :name, :lecture_ids, :quiz_ids, :appearance_time, :position, :lectures_attributes, :due_date
  acts_as_list :scope => :course
  
  validates :appearance_time, :course_id, :name, :due_date, :presence => true
  belongs_to :course
  has_many :lectures, :order => :position, :dependent => :destroy  #no dependent destroy since they are independent
  has_many :quizzes,:order => :position, :dependent => :destroy #no dependent destroy since they are independent
  has_many :events
  after_destroy :clean_up
  
  accepts_nested_attributes_for :lectures, :allow_destroy => true
  accepts_nested_attributes_for :quizzes, :allow_destroy => true
  
  def has_not_appeared
    appearance_time >= Time.zone.now
  end
  
  def total_questions
    count=0;
    lectures.each do |l|
      count+= (l.online_quizzes.count)
    end
    return count
  end
  
  def total_time
    count=0;
    lectures.each do |l|
      count+=l.duration if !l.duration.nil?
    end
    return (Time.at(count).utc.strftime("%H:%M:%S"))
  end
  
  private
  def clean_up
    self.events.where(:lecture_id => nil, :quiz_id => nil).destroy_all
  end
  
end
