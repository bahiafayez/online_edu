class Quiz < ActiveRecord::Base
  
  belongs_to :course
  belongs_to :group
  has_many :events
  has_many :quiz_grades , :dependent => :destroy
  has_many :quiz_statuses, :dependent => :destroy
  
  has_many :questions, :dependent => :destroy
  accepts_nested_attributes_for :questions, :allow_destroy => true
  
  attr_accessible :course_id, :instructions, :name, :questions_attributes, :group_id, :due_date, :appearance_time,:appearance_time_module, :due_date_module
  validates :name, :appearance_time,:due_date,:course_id, :group_id, :presence => true
  validates_inclusion_of :appearance_time_module, :due_date_module, :in => [true, false]
  #validates_associated :questions
  after_destroy :clean_up
  
  def has_not_appeared
    appearance_time >= Time.zone.now
  end
  
  private
  def clean_up
    self.events.where(:lecture_id => nil).destroy_all
  end
  
end
