class Lecture < ActiveRecord::Base
  
  validates :name, :url,:appearance_time , :presence => true
  has_many :online_quizzes, :dependent => :destroy
  belongs_to :course
  belongs_to :group
  
  attr_accessible :course_id, :description, :name, :url, :group_id, :appearance_time
  
  accepts_nested_attributes_for :online_quizzes, :allow_destroy => true
end
