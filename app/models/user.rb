class User < ActiveRecord::Base
  
  has_many :subjects, :class_name => "Course"  # to get this call user.subjects
  has_many :quiz_grades#, :conditions => :user kda its like im defining a method called quiz grades, which returns something when user = ... not what i want.
  has_many :online_quiz_grades
  has_many :enrollments, :dependent => :delete_all
  has_many :courses, :through => :enrollments
  has_many :announcements
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
  
  
  def grades(course)
    #calculates for each module where done on time, done not on time, not done # returns an array
    grades=[]
    course.groups.each do |g|
      grades<<self.finished_group?(g)
    end
    return grades
  end
  
  def finished_group?(group)
    lectures= group.lectures
    quizzes= group.quizzes
    
    if self.finished_lectures(lectures) and self.finished_quizzes(quizzes)  #finished all lectures and quizzes
      if self.finished_lectures_on_time(lectures) and self.finished_quizzes_on_time(quizzes)
        return "Finished on Time"
      else
        return "Finished Not on time"
      end
    else
      return "Not Finished" #either lectures or quizzes or both not solved.
    end
  end
  
  def finished_quizzes(quizzes)
    finished=true
    quizzes.each do |q|
      if QuizStatus.where(:user_id => self.id, :quiz_id => q.id, :status => "Submitted").empty?
        return false
      end
    end
    return finished
  end
  
  def finished_quizzes_on_time(quizzes)
    finished=true
    quizzes.each do |q|
      inst=QuizStatus.where(:user_id => self.id, :quiz_id => q.id, :status => "Submitted")[0]
      if inst.updated_at > q.due_date  #solved after lecture due date
        return false
      end
    end
    return finished
  end
  
  def finished_lectures(lectures)
    finished=true
    lectures.each do |l|
      l.online_quizzes.each do |q|
        if self.online_quiz_grades.where(:online_quiz_id => q.id).empty?
          return false  #if for any lecture, any quiz was not solved, then he has not finished the lectures.
        end 
      end
    end
    return finished
  end
  
  def finished_lectures_on_time(lectures)
    finished=true
    lectures.each do |l|
      l.online_quizzes.each do |q|
        g=self.online_quiz_grades.where(:online_quiz_id => q.id)[0]
        if g.created_at > l.due_date  #solved after lecture due date
          return false  #if for any lecture, any quiz was not solved, then he has not finished the lectures.
        end 
      end
    end
    return finished
  end
  
end
