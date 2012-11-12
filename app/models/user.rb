class User < ActiveRecord::Base
  
  has_many :subjects, :class_name => "Course"  # to get this call user.subjects
  has_many :quiz_grades#, :conditions => :user kda its like im defining a method called quiz grades, which returns something when user = ... not what i want.
  has_many :online_quiz_grades
  has_many :enrollments, :dependent => :delete_all
  has_many :courses, :through => :enrollments
  
  #has_and_belongs_to_many :roles, :join_table => :users_roles  # i added this
  
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin  # can only update roles if i'm an admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me#, :id
  
  accepts_nested_attributes_for :courses
  
end
