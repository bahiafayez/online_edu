class Event < ActiveRecord::Base
  has_event_calendar
  belongs_to :quiz
  belongs_to :course
  belongs_to :group
  belongs_to :lecture
  
  validates :course_id, :name, :presence => true #can't have group_id because it is added after saving the group! so validation fails.
  
  after_validation :message
  
  def message
    print "error #{self.errors.full_messages}"
  end
 
  def self.appeared?(course)
    #returns all the events that have appeared.. since these are the ones we'll add to the calendar (the due dates)
    @m=Group.where("course_id = ? and appearance_time <= ?",course.id,Time.zone.now.to_date)
    @l=Lecture.where("course_id = ? and appearance_time <= ?",course.id,Time.zone.now.to_date)
    @q=Quiz.where("course_id = ? and appearance_time <= ?",course.id,Time.zone.now.to_date)
    
    
    return self.where("lecture_id IS NULL and quiz_id IS NULL and group_id IN (?)", @m) +
    Event.where("lecture_id IS NULL and quiz_id IN (?) and group_id IN (?)", @q,@m) +
    Event.where("lecture_id IN (?) and quiz_id IS NULL and group_id IN (?)", @l,@m)
    #logger.debug("Events all are #{@eventsAll}")
  end
    
   def get_color(user)
     Time.zone = Course.find(course_id).time_zone
     color=""
     if lecture_id.nil? and quiz_id.nil? #module event
       if (user.finished_group_boolean(Group.find(group_id))) 
         color="green"
       elsif (Group.find(group_id).due_date - Time.zone.now.to_date).to_i < 2 #deadline soon
         color="red"
       else
         color="orange"
       end
     elsif !quiz_id.nil? #quiz event
       if (Quiz.find(quiz_id).quiz_type=='quiz' and user.finished_quiz(Quiz.find(quiz_id))) or (Quiz.find(quiz_id).quiz_type=='survey' and user.finished_survey(Quiz.find(quiz_id))) 
         color="green"
       elsif (Quiz.find(quiz_id).due_date - Time.zone.now.to_date).to_i < 2 #deadline soon
         color="red"
       else
         color="orange"
       end
     elsif !lecture_id.nil? #lecture event
       if user.finished_lecture(Lecture.find(lecture_id))
         color="green"
       elsif (Lecture.find(lecture_id).due_date - Time.zone.now.to_date).to_i < 2 #deadline soon
         color="red"
       else
         color="orange"
       end
     end
     return color
   end
  
end
