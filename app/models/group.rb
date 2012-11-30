class Group < ActiveRecord::Base
  attr_accessible :course_id, :description, :name, :lecture_ids, :quiz_ids, :appearance_time, :position, :lectures_attributes
  acts_as_list :scope => :course
  
  validates :appearance_time, :presence => true
  belongs_to :course
  has_many :lectures  #no dependent destroy since they are independent
  has_many :quizzes #no dependent destroy since they are independent
  
  accepts_nested_attributes_for :lectures, :allow_destroy => true
end
