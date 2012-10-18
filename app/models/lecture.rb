class Lecture < ActiveRecord::Base
  
  has_many :online_quizzes
  belongs_to :course
  
  attr_accessible :course_id, :description, :name, :url
end
