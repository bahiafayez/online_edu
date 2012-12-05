class Lecture < ActiveRecord::Base
  
  validates :name, :url,:appearance_time , :presence => true
  has_many :online_quizzes, :dependent => :destroy
  belongs_to :course
  belongs_to :group
  has_many :events
  after_destroy :clean_up
  
  attr_accessible :course_id, :description, :name, :url, :group_id, :appearance_time, :due_date
  
  accepts_nested_attributes_for :online_quizzes, :allow_destroy => true

  def has_not_appeared
    return appearance_time >= Time.zone.now
  end
  
  private
  def clean_up
    self.events.where(:quiz_id => nil).destroy_all
  end

end
