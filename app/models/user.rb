class User < ActiveRecord::Base
  
  has_many :subjects, :class_name => "Course"  # to get this call user.subjects
  has_many :quiz_grades, :dependent=> :destroy#, :conditions => :user kda its like im defining a method called quiz grades, which returns something when user = ... not what i want.
  has_many :online_quiz_grades, :dependent => :destroy
  has_many :enrollments, :dependent => :delete_all
  has_many :courses, :through => :enrollments
  has_many :announcements
  has_many :quiz_statuses, :dependent => :destroy
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
    if course.is_a?(Course)
    course.groups.each do |g|
      grades<<self.finished_group?(g)
    end
    else  #its a module
      grades={}
      course.lectures.each do |l|
        grades[l.id]=self.finished_lecture_group?(l)
      end
    end
    return grades
  end
  
  
  def late_days(group)
    late_days={}
    group.lectures.each do |l|
      if self.finished_lecture(l) and !self.finished_lecture_on_time(l) #finished lecture but late
        late_days[l.id]=calculate_late_days(l)
        #print("late dayssss #{l.name} #{calculate_late_days(l)}") 
      end
    end
    #print late_days
    return late_days
  end
  
  def calculate_late_days(lecture)
    
    max_late=lecture.due_date
      lecture.online_quizzes.each do |q|
        g=self.online_quiz_grades.where(:online_quiz_id => q.id)[0]
        if g.created_at > lecture.due_date  #solved after lecture due date
           max_late=g.created_at if g.created_at>max_late  #if for any lecture, any quiz was not solved, then he has not finished the lectures.
        end 
      end
      viewed=LectureView.where(:user_id => id, :lecture_id => lecture.id, :percent => 75)[0]
      if viewed.updated_at > lecture.due_date
        max_late=viewed.updated_at if viewed.updated_at>max_late
      end
    
    return ((max_late - lecture.due_date)/60/60/24).round(1)  #from seconds to days
  end
  
  def finished_lecture_group?(lecture)
    
    if self.finished_lecture(lecture) 
      if self.finished_lecture_on_time(lecture)
        return "Finished on Time"
      else
        return "Finished Not on time"
      end
    else
      return "Not Finished" 
    end
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
      viewed=LectureView.where(:user_id => id, :lecture_id => l.id, :percent => 75)
      return false if viewed.empty?
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
      viewed=LectureView.where(:user_id => id, :lecture_id => l.id, :percent => 75)[0]
      return false if viewed.updated_at > l.due_date
    end
    return finished
  end
  
  def finished_lecture(lecture)
    finished=true
      lecture.online_quizzes.each do |q|
        if self.online_quiz_grades.where(:online_quiz_id => q.id).empty?
          return false  #if for any lecture, any quiz was not solved, then he has not finished the lectures.
        end 
      end
      viewed=LectureView.where(:user_id => id, :lecture_id => lecture.id, :percent => 75)
      return false if viewed.empty?
    
    return finished
  end
  
  def finished_lecture_on_time(lecture)
    finished=true
      lecture.online_quizzes.each do |q|
        g=self.online_quiz_grades.where(:online_quiz_id => q.id)[0]
        if g.created_at > lecture.due_date  #solved after lecture due date
          return false  #if for any lecture, any quiz was not solved, then he has not finished the lectures.
        end 
      end
      viewed=LectureView.where(:user_id => id, :lecture_id => lecture.id, :percent => 75)[0]
      return false if viewed.updated_at > lecture.due_date
    
    return finished
  end
  
  
  
  def self.dummy_lecture_data
    #will create onlinequizgrades for each of the 20 students AND lecture_views with different answers and dates! and maybe 2 students did not complete the quizzes and 2 didnt do 75%.. 10 did and on time 4 did but not one time.
    OnlineQuiz.all.each do |o|
      answers= o.online_answers
      grade=[1,0]
      dates=[Time.now, 3.weeks.from_now, 1.week.from_now]
      2.upto(21).each do |index|
        User.find(index).online_quiz_grades << OnlineQuizGrade.new(:online_quiz_id => o.id, :lecture_id => o.lecture_id, :online_answer_id => answers.sample.id ,:grade => grade.sample, :created_at => dates.sample)
      end
    end
    
    Lecture.all.each do |lecture|
      percent = [25,50,75]
      dates=[Time.now, 3.weeks.from_now, 1.week.from_now]
      2.upto(21).each do |index|
        LectureView.create(:user_id => index, :lecture_id => lecture.id, :course_id => lecture.course_id, :percent => percent.sample, :updated_at => dates.sample)
      end
    end
  end
  
  def self.dummy_confused_and_questions
    question=["I don't understand this part", "What do you mean by that?", "I'm not sure I follow"]
    Lecture.all.each do |lecture|
      2.upto(21).each do |index|
        LectureQuestion.create(:user_id => index, :lecture_id => lecture.id, :course_id => lecture.course_id, :time => rand(1..300) , :question => question.sample )
        Confused.create(:user_id => index, :lecture_id => lecture.id, :course_id => lecture.course_id, :time => rand(1..300))
      end
    end
  end
  
  
  
  def self.students
    # returns all students registered on site (with role user)
   all_users= User.all
   @students = all_users.find_all{|u| u.has_role?('user')}
  end
  
  def remove_student(course_id)
    enrollments.where(:course_id => course_id).destroy_all
  end
  
end
