class Event < ActiveRecord::Base
  has_event_calendar
  belongs_to :quiz
  belongs_to :course
  belongs_to :group
  belongs_to :lecture
  
  def self.appeared?(course)
    #returns all the events that have appeared.. since these are the ones we'll add to the calendar (the due dates)
    @m=Group.where("course_id = ? and appearance_time <= ?",course.id,Time.zone.now)
    @l=Lecture.where("course_id = ? and appearance_time <= ?",course.id,Time.zone.now)
    @q=Quiz.where("course_id = ? and appearance_time <= ?",course.id,Time.zone.now)
    
    
    return self.where("lecture_id IS NULL and quiz_id IS NULL and group_id IN (?)", @m) +
    Event.where("lecture_id IS NULL and quiz_id IN (?) and group_id IN (?)", @q,@m) +
    Event.where("lecture_id IN (?) and quiz_id IS NULL and group_id IN (?)", @l,@m)
    #logger.debug("Events all are #{@eventsAll}")
  end
    
  
end
