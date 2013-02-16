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
    
  
end
