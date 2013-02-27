class Group < ActiveRecord::Base
  attr_accessible :course_id, :description, :name, :lecture_ids, :quiz_ids, :appearance_time, :position, :lectures_attributes, :due_date
  acts_as_list :scope => :course
  
  validates :appearance_time, :course_id, :name, :due_date, :presence => true
  belongs_to :course, :touch => true
  has_many :lectures, :order => :position, :dependent => :destroy  #no dependent destroy since they are independent
  has_many :quizzes,:order => :position, :dependent => :destroy #no dependent destroy since they are independent
  has_many :events
  after_destroy :clean_up
  
  accepts_nested_attributes_for :lectures, :allow_destroy => true
  accepts_nested_attributes_for :quizzes, :allow_destroy => true
  
  def has_not_appeared
    appearance_time > Time.zone.now.to_date
  end
  
  
  def get_data
    data={}
    lectures.each do |lecture|
      lecture.online_quizzes.each do |quiz|
        data[quiz.id]=[]
        quiz.online_answers.each do |answer|
          data[quiz.id]<< OnlineQuizGrade.where(:online_quiz_id => quiz.id, :online_answer_id => answer.id, :lecture_id => lecture.id).count
        end
      end
    end
    return data
  end
  
  
  def get_data_percent
    data={}
    lectures.each do |lecture|
      lecture.online_quizzes.each do |quiz|
        data[quiz.id]=[]
        total= OnlineQuizGrade.where(:online_quiz_id => quiz.id, :lecture_id => lecture.id).count
          if total>0
            quiz.online_answers.each do |answer|
              data[quiz.id]<< OnlineQuizGrade.where(:online_quiz_id => quiz.id, :online_answer_id => answer.id, :lecture_id => lecture.id).count/(total.to_f)*100.0
            end
          end
      end
    end
    return data
  end
  
  def get_colors
    colors={}
    lectures.each do |lecture|
      lecture.online_quizzes.each do |quiz|
        colors[quiz.id]=[]
        quiz.online_answers.each do |answer|
          color = if answer.correct
                    "green"
                  else
                    "gray"
                  end
          colors[quiz.id]<< color
        end
      end
    end
    return colors
  end
  
  def get_categories
    data={}
    lectures.each do |lecture|
      lecture.online_quizzes.each do |quiz|
        data[quiz.id] = quiz.online_answers.map{|obj| obj=obj.answer}
      end
    end
    return data
  end
  
  def get_lecture_names
    data={}
    lectures.each do |lecture|
      lecture.online_quizzes.each do |quiz|
        data[quiz.id] = [lecture.name, lecture.url]
      end
    end
    return data
  end
  
  def get_questions
    data={}
    lectures.each do |lecture|
      lecture.online_quizzes.each do |quiz|
        data[quiz.id] = [quiz.question, quiz.time]
      end
    end
    return data
  end
  
  def get_question_ids
    data=[]
    lectures.each do |lecture|
      lecture.online_quizzes.each do |quiz|
        data << quiz.id
      end
    end
    return data
  end
  
  
  def total_questions
    count=0;
    lectures.each do |l|
      count+= (l.online_quizzes.count)
    end
    return count
  end
  
  def total_quiz_questions #doesn't count survey questions.
    count=0;
    quizzes.each do |l|
      count+= (l.questions.count) if l.quiz_type!="survey"
    end
    return count
  end
  
  def total_time
    count=0;
    lectures.each do |l|
      count+=l.duration if !l.duration.nil?
    end
    return (Time.at(count).utc.strftime("%H:%M:%S"))
  end
  
  def get_items
    all=(quizzes+lectures).sort{|a,b| a.position <=> b.position}
  end
  
  def get_lecture_list
    data=[]
    lectures.each do |l|
      data<<l.url
    end
    return data
  end
  
  def get_display_data
    num_quizzes=0
    data={}
    lectures.each do |lec|
      data[lec.url]=[]
      lec.online_quizzes.each do |quiz|
        num_quizzes+=1
        data[lec.url]<< [quiz.time, num_quizzes, quiz.question, quiz.id]
      end
    end
    return data
  end
  
  def get_display_question_data
    num_quizzes=0
    data={}
    lectures.each do |lec|
      data[lec.url]=[]
      b=LectureQuestion.get_rounded_display(LectureQuestion.where(:lecture_id => lec.id))
      sorted_b=Hash[b.sort]
      sorted_b.each do |k,v|
        num_quizzes+=1
        data[lec.url]<<[k,num_quizzes,v[1]]
      end
        
      end
    return data
  end
  
  def total_student_questions
    
    count=0
    lectures.each do |l|
       count+=LectureQuestion.get_rounded_time_30(LectureQuestion.where(:lecture_id => l.id)).count
       #count+=LectureQuestion.where(:lecture_id => l.id).count #no we want it interms of 30 seconds.
    end
    return count
    #@questions_chart2= LectureQuestion.get_rounded_time(@confused_questions.order(:time))
  end
  
  private
  def clean_up
    self.events.where(:lecture_id => nil, :quiz_id => nil).destroy_all
  end
  
end
