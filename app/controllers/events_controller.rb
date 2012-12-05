class EventsController < ApplicationController
  
  before_filter :get_course
   before_filter :set_zone
  
  def set_zone
    @course=Course.find(params[:course_id])
    Time.zone= @course.time_zone
  end
  
  def get_course
    @course=Course.find(params[:course_id])  
  end
  
  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)    
  
    #@event_strips = Event.event_strips_for_month(@shown_month, :conditions => "course_id=#{@course.id}")
    
    logger.debug("event strips areeee #{@event_strips}")
    start_d, end_d = Event.get_start_and_end_dates(@shown_month) # optionally pass in @first_day_of_week
    
    @eventsAll= Event.appeared?(@course)
  
    @events = Event.events_for_date_range(start_d, end_d)
    @events = @events & @eventsAll
    logger.debug("events areee #{@events}")
    @event_strips = Event.create_event_strips(start_d, end_d, @events)
    
    @announcements=Announcement.where(:course_id => @course.id).order(:date)
  end
    
  def show
    @event=Event.find(params[:id])
    @course=Course.find(@event.course_id)
    # if module has not appeared yet . or does not exist. or is nil here. or quiz/lecture have not appeared. go back.
    @module= Group.find(@event.group_id) if !@event.group_id.nil?
    @quiz= Quiz.find(@event.quiz_id) if !@event.quiz_id.nil?
    @lecture= Lecture.find(@event.lecture_id) if !@event.lecture_id.nil?
    
    if @event.group_id.nil? or @module.has_not_appeared
      redirect_to :action => :index
    else
      if !@event.quiz_id.nil? and !@quiz.has_not_appeared
        redirect_to courseware_course_path(@course, :q=>@event.quiz_id)
      elsif !@event.lecture_id.nil? and !@lecture.has_not_appeared
        redirect_to courseware_course_path(@course, :l=>@event.lecture_id)
      else
        redirect_to courseware_course_path(@course)
      end
    end
  end
end
