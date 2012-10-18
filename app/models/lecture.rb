class Lecture < ActiveRecord::Base
  attr_accessible :course_id, :description, :name, :url
end
