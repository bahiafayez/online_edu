class Course < ActiveRecord::Base
  belongs_to :user
  has_many :quizzes
  has_many :enrollments, :dependent => :delete_all
  has_many :users, :through => :enrollments
  has_many :lectures
  
  attr_accessible :description, :duration, :name, :prerequisites, :short_name, :start_date, :user_ids, :user_id
  
  validates :name, :duration, :short_name,:start_date, :user_id, :presence => true
  validates :duration, :numericality => { :only_integer => true }
  validates_date :start_date
  
  accepts_nested_attributes_for :users, :allow_destroy => true
  attr_accessible :users_attributes
  #attr_accessible :enrollment_attributes
  
end
