class Lecture < ActiveRecord::Base
  
  validates :name, :url, :presence => true
  has_many :online_quizzes, :dependent => :destroy
  belongs_to :course
  belongs_to :group
  
  attr_accessible :course_id, :description, :name, :url, :group_id
end
