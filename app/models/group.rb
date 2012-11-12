class Group < ActiveRecord::Base
  attr_accessible :course_id, :description, :name, :lecture_ids, :quiz_ids
  belongs_to :course
  has_many :lectures  #no dependent destroy since they are independent
  has_many :quizzes #no dependent destroy since they are independent
end
