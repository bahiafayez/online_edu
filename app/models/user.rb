class User < ActiveRecord::Base
  
  has_many :subjects, :class_name => "Course"  # to get this call user.subjects
  has_many :quiz_grades, :dependent=> :destroy#, :conditions => :user kda its like im defining a method called quiz grades, which returns something when user = ... not what i want.
  has_many :online_quiz_grades, :dependent => :destroy
  has_many :enrollments, :dependent => :delete_all
  has_many :courses, :through => :enrollments, :uniq => true
  has_many :announcements
  has_many :quiz_statuses, :dependent => :destroy
  has_and_belongs_to_many :roles, :join_table => :users_roles  # i added this
  
  validates_presence_of :role_ids
  
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids #, :as => :admin  # can only update roles if i'm an admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me#, :id
  
  accepts_nested_attributes_for :courses
  
  
  def grades(course)
    #calculates for each module where done on time, done not on time, not done # returns an array
    grades={}
    if course.is_a?(Course)
    course.groups.each do |g|
      grades[g.id]=self.finished_group?(g)
    end
    else  #its a module
      grades={}
      course.lectures.each do |l|
        grades[l.id]=self.finished_lecture_group?(l)
      end
    end
    return grades
  end
  
  def quiz_grades(group)
    #calculates for each module where done on time, done not on time, not done # returns an array
    
      grades={}
      group.quizzes.each do |q|
        grades[q.id]=self.finished_quiz_group?(q)
      end
    
    return grades
  end
  
  def course_late_days(course)
    late_days={}
    late1=0
    late2=0
    course.groups.each do |g|
      if self.finished_quizzes(g.quizzes) and self.finished_lectures(g.lectures)
      
        if !self.finished_lectures_on_time(g.lectures)  #finished all lectures and quizzes
          late1= calculate_lectures_late_days(g.lectures)
        end
        if !self.finished_quizzes_on_time(g.quizzes)
          late2= calculate_quizzes_late_days(g.quizzes) 
        end
        lateMax= if late1>late2 
                late1 
               else 
                 late2
               end
      late_days[g.id]=lateMax if lateMax>0
      end
    end
    return late_days
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
  
  def quiz_late_days(group)
    late_days={}
    group.quizzes.each do |q|
      if self.finished_quiz(q) and !self.finished_quiz_on_time(q) #finished lecture but late
        late_days[q.id]=calculate_quiz_late_days(q)
        #print("late dayssss #{l.name} #{calculate_late_days(l)}") 
      end
    end
    #print late_days
    return late_days
  end
  
  def calculate_lectures_late_days(lectures)
    max=0
    lectures.each do |l|
      val = calculate_late_days(l)
      max = val if val> max
    end
    return max
  end
  
  def calculate_quizzes_late_days(quizzes)
    max=0
    quizzes.each do |q|
      val = calculate_quiz_late_days(q)
      max = val if val> max
    end
    return max
  end
  
  def calculate_late_days(lecture)
    
    max_late=lecture.due_date
      lecture.online_quizzes.each do |q|
        g=self.online_quiz_grades.where(:online_quiz_id => q.id)[0]
        if g.created_at.to_date > lecture.due_date  #solved after lecture due date
           max_late=g.created_at.to_date if g.created_at.to_date>max_late  #if for any lecture, any quiz was not solved, then he has not finished the lectures.
        end 
      end
      viewed=LectureView.where(:user_id => id, :lecture_id => lecture.id)[0]
      if viewed.created_at.to_date > lecture.due_date
        max_late=viewed.created_at.to_date if viewed.created_at.to_date>max_late
      end
    
    #return ((max_late - lecture.due_date)/60/60/24).round(1)  #from seconds to days
    return (max_late - lecture.due_date).to_i
  end
  
  
  def calculate_quiz_late_days(quiz)
    
    max_late=0
      inst=QuizStatus.where(:user_id => self.id, :quiz_id => quiz.id, :status => "Submitted")[0]
      if inst.updated_at.to_date > quiz.due_date  #solved after lecture due date
        max_late= inst.updated_at.to_date - quiz.due_date
      end
    return max_late.to_i
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
  
  def finished_quiz_group?(quiz)
    
    if self.finished_quiz(quiz) 
      if self.finished_quiz_on_time(quiz)
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
  
  def finished_quiz(quiz)
    finished=true
    if QuizStatus.where(:user_id => self.id, :quiz_id => quiz.id, :status => "Submitted").empty?
        return false
      end
    return finished
  end
  
  def finished_quizzes_on_time(quizzes)
    finished=true
    quizzes.each do |q|
      inst=QuizStatus.where(:user_id => self.id, :quiz_id => q.id, :status => "Submitted")[0]
      if inst.updated_at.to_date > q.due_date  #solved after lecture due date
        return false
      end
    end
    return finished
  end
  
  def finished_quiz_on_time(quiz)
    finished=true
    
      inst=QuizStatus.where(:user_id => self.id, :quiz_id => quiz.id, :status => "Submitted")[0]
      if inst.updated_at.to_date > quiz.due_date  #solved after lecture due date
        return false
      end
    
    return finished
  end
  
  def finished_lectures(lectures)  #if finished all online_quizzes AND opened the lecture
    finished=true
    lectures.each do |l|
      l.online_quizzes.each do |q|
        if self.online_quiz_grades.where(:online_quiz_id => q.id).empty?
          return false  #if for any lecture, any quiz was not solved, then he has not finished the lectures.
        end 
      end
      viewed=LectureView.where(:user_id => id, :lecture_id => l.id)
      return false if viewed.empty?
    end
    return finished
  end
  
  def finished_lectures_on_time(lectures)
    finished=true
    lectures.each do |l|
      l.online_quizzes.each do |q|
        g=self.online_quiz_grades.where(:online_quiz_id => q.id)[0]
        if g.created_at.to_date > l.due_date  #solved after lecture due date
          return false  #if for any lecture, any quiz was not solved, then he has not finished the lectures.
        end 
      end
      viewed=LectureView.where(:user_id => id, :lecture_id => l.id)[0]
      return false if viewed.created_at.to_date > l.due_date
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
      viewed=LectureView.where(:user_id => id, :lecture_id => lecture.id)
      return false if viewed.empty?
    
    return finished
  end
  
  def finished_lecture_on_time(lecture)
    finished=true
      lecture.online_quizzes.each do |q|
        g=self.online_quiz_grades.where(:online_quiz_id => q.id)[0]
        if g.created_at.to_date > lecture.due_date  #solved after lecture due date
          return false  #if for any lecture, any quiz was not solved, then he has not finished the lectures.
        end 
      end
      viewed=LectureView.where(:user_id => id, :lecture_id => lecture.id)[0]
      return false if viewed.created_at.to_date > lecture.due_date
    
    return finished
  end
  
  def get_statistics(course)
    return [total_quiz(course), total_online_quiz(course), quizzes_percent(course), online_quizzes_percent(course)]
  end
  
  def quizzes_percent(course)
    solved=QuizStatus.where(:user_id => id, :course_id => course.id, :status => "Submitted").length     #s.quiz_grades.select('distinct quiz_id').select{|v| Course.find(@course.id).quizzes.pluck(:id).include?v.quiz_id}.length
    total= Course.find(course.id).quizzes.count
    return solved/total.to_f * 100
  end
  
  def online_quizzes_percent(course)
    online= online_quiz_grades.select{|v| Course.find(course.id).lectures.pluck(:id).include?v.lecture_id}.length #all onlinequizzes in the course that the student solved
    online_total = OnlineQuiz.all.select{|v| Course.find(course.id).lectures.pluck(:id).include?v.lecture_id}.length #all onlinequizzes in the course
    return online/online_total.to_f * 100
  end
  
  def total_online_quiz(course)
    total=0
    count=0
    course.lectures.each do |lecture|
      count+= lecture.online_quizzes.count
      total+=total_online_quiz_lecture(lecture)
    end
    return total/count.to_f * 100
  end
  
  def total_online_quiz_lecture(lecture)
    total=0
    lecture.online_quizzes.each do |quiz|
      total+=total_online_quiz_quiz(quiz)
    end
    return total
  end
  
  def get_lecture_grade(lecture)
    total=0
    count = lecture.online_quizzes.count
    lecture.online_quizzes.each do |quiz|
      total+=total_online_quiz_quiz(quiz)
    end
    if count!=0
      return total/count * 100
    else 
      return 0
    end
  end
  
  def total_online_quiz_quiz(quiz)
    a=OnlineQuizGrade.where(:user_id => id, :online_quiz_id => quiz.id)[0]
    if a.nil?
      return 0
    else 
      return a.grade
    end
  end
  
  def total_quiz(course)
    count= course.quizzes.where("quiz_type IS NULL or quiz_type != 'survey'").count
    total=0
    course.quizzes.where("quiz_type IS NULL or quiz_type != 'survey'").each do |quiz|
      total+=get_quiz_grade(quiz) #returns %
    end
    if count!=0
      return total/count.to_f 
    else
      return "No Quizzes"
    end
  end
  
  def get_quiz_grade(quiz)
    num=0
    if !QuizStatus.where(:user_id => id, :quiz_id => quiz.id, :status => "Submitted").empty?
        QuizGrade.where(:quiz_id => quiz.id, :user_id => id).select("distinct(question_id), grade").each do |ques|
                if ques.grade==1
                  num+=1.0
                end
         end
         if !quiz.questions.empty?
           return (num/quiz.questions.count.to_f * 100) 
         else
           return 100
         end
    else
      return 0
    end
  end
  
  def get_detailed_quiz_grade(quiz)
    if QuizStatus.where(:user_id => id, :quiz_id => quiz.id, :status => "Submitted").empty?
      return 0
    else
      data=[]
      quiz.questions.each do |question|
        g=QuizGrade.where(:user_id => id, :quiz_id => quiz.id, :question_id => question.id)[0].grade
        answers=[]
        QuizGrade.where(:user_id => id, :quiz_id => quiz.id, :question_id => question.id).each do |ans|
          answers<<Answer.find(ans.answer_id).content if Answer.find_by_id(ans.answer_id)   #because might be deleted
        end
        data<<[question.content,g,answers]
      end
      return data
    end
  end
  
  def get_detailed_lecture_grade(lecture)
    data=[]
    lecture.online_quizzes.each do |quiz|
      a=OnlineQuizGrade.where(:user_id => id, :online_quiz_id => quiz.id)[0]
      if a.nil?
        ans="Not Answered"
      else
        a=a.online_answer_id
        ans=OnlineAnswer.find_by_id(a)
        if ans.nil?
          ans="Answer does not exist any more"
        else
          ans=ans.answer
        end
      end
      
      data<<[quiz.question, total_online_quiz_quiz(quiz), ans]
      
    end
    return data
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
  
  

  def self.search(search)
    if search
      joins(:roles).where(:roles =>{:name => "user"}).where('users.name LIKE ? or users.email LIKE ?', "%#{search}%","%#{search}%")
    else
      #scoped
      #returning all students
      User.joins(:roles).where(:roles =>{:name => "user"})

    end
  end


  
end
