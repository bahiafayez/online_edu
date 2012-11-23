class Quiz < ActiveRecord::Base
  
  belongs_to :course
  belongs_to :group
  
  has_many :questions, :dependent => :destroy
  accepts_nested_attributes_for :questions, :allow_destroy => true
  
  attr_accessible :course_id, :instructions, :name, :questions_attributes, :group_id, :due_date, :appearance_time
  validates :name, :appearance_time,:due_date, :presence => true
  #validates_associated :questions
  
end
