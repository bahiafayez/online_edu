class Group < ActiveRecord::Base
  attr_accessible :course_id, :description, :name, :lecture_ids, :quiz_ids, :appearance_time, :position, :lectures_attributes, :due_date
  acts_as_list :scope => :course
  
  validates :appearance_time, :presence => true
  belongs_to :course
  has_many :lectures  #no dependent destroy since they are independent
  has_many :quizzes #no dependent destroy since they are independent
  has_many :events
  after_destroy :clean_up
  
  accepts_nested_attributes_for :lectures, :allow_destroy => true
  accepts_nested_attributes_for :quizzes, :allow_destroy => true
  
  def has_not_appeared
    appearance_time >= Time.zone.now
  end
  
  private
  def clean_up
    self.events.where(:lecture_id => nil, :quiz_id => nil).destroy_all
  end
  
end
