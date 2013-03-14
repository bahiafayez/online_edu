#require 'EventsHelper'
require "event_calendar"
 
class EventsController < ApplicationController
  load_and_authorize_resource
  
  before_filter :get_course
  before_filter :set_zone
  before_filter :correct_user
 # caches_action :index, :layout => false , :cache_path => proc { |c|
 # { :tag => Event.where(:course_id => c.params[:course_id]).maximum('updated_at').to_i, :num => Event.where(:course_id => c.params[:course_id]).count, :num_ann => Announcement.where(:course_id => c.params[:course_id]).count, :ann => Announcement.where(:course_id => c.params[:course_id]).maximum('updated_at').to_i }
 # }#i need count too, to stale cache IF sthg deleted (won't appear in updated_at)
  caches_action :show,:layout => false, :cache_path => proc { |c|
  # c is the instance of the controller. Since action caching
  # is declared at the class level, we don't have access to instance
  # variables. If cache_path is a proc, it will be evaluated in the
  # the context of the current controller. This is the same idea
  # as validations with the :if and :unless options
  #
  # Remember, what is returned from this block will be passed in as
  # extra parameters to the url_for method.
  event = Event.find c.params[:id]
 {:tag => event.updated_at.to_i }
 }

  
  def correct_user
    # Checking to see if the current user is taking the course OR teaching the course, otherwise he is not authorised.
    @c=Course.find(params[:course_id])
    if !@c.users.include?(current_user) and !(@c.user == current_user)
      redirect_to courses_path, :alert => "You are not authorized to see requested page"
    end
  end
  
  
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
    
    @announcements=Announcement.where(:course_id => @course.id).order("updated_at DESC")
    
    
    #here get information about each event for this user (done or not and deadline soon? to choose color is js)
    @colors={}
    @eventsAll.each do |event|
      @colors["ec-event-#{event.id}"]= event.get_color(current_user)
    end
    @colors= @colors.to_json
    
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
        redirect_to courseware_course_path(@course, :q=>@event.quiz_id)   #This is a specific quiz
      elsif !@event.lecture_id.nil? and !@lecture.has_not_appeared
        redirect_to courseware_course_path(@course, :l=>@event.lecture_id)   #This is a specific lecture
      else                                                                    #This is a module
        first_item=Group.find(@event.group_id).get_items[0]
        if first_item.nil?
          redirect_to courseware_course_path(@course)
        else
          if first_item.class.name=="Lecture"
            redirect_to courseware_course_path(@course, :l => first_item.id)
          else
            redirect_to courseware_course_path(@course, :q => first_item.id)
          end
        end
      end
    end
  end
end
