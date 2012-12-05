class GroupsController < ApplicationController
  # GET /online_answers
  # GET /online_answers.json
  before_filter :getCourse
  before_filter :set_zone
  
  def set_zone
    @course=Course.find(params[:course_id])
    Time.zone= @course.time_zone
  end
  
  def getCourse
    @course= Course.find(params[:course_id])  
  end
  
  def index
    @groups = @course.groups

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /online_answers/1
  # GET /online_answers/1.json
  def show
      @group = @course.groups.find(params[:id])
      logger.debug("group isss #{@group.name}")
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @group }
      end
  rescue #ActiveRecord::RecordInvalid because recordnot found
        flash[:error] = "Group not found"
        redirect_to :action => :index 
  end

  # GET /online_answers/new
  # GET /online_answers/new.json
  def new
    @group=@course.groups.build()
    #@group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /online_answers/1/edit
  def edit
    begin
      @group = @course.groups.find(params[:id])
    rescue
      flash[:error] = "Group not found"
      redirect_to :action => :index
    end
  end

  # POST /online_answers
  # POST /online_answers.json
  def create
    #@group = Group.new()
    @group = @course.groups.build(params[:group])

    respond_to do |format|
      if @group.save
        format.html { redirect_to [@course,@group], notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /online_answers/1
  # PUT /online_answers/1.json
  def update
     if params[:id].nil?
        redirect_to :action => :create
     end
    @group = @course.groups.find(params[:id])
    
    @group.events.where(:quiz_id => nil, :lecture_id => nil).destroy_all #its ok since I only have the due date.
    
    
    respond_to do |format|
      if @group.update_attributes(params[:group])
        @group.events << Event.new(:name => "#{@group.name} due", :start_at => @group.due_date, :end_at => @group.due_date, :all_day => false, :color => "red", :course_id => @course.id)
        format.html { redirect_to [@course,@group], notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /online_answers/1
  # DELETE /online_answers/1.json
  def destroy
    @group = @course.groups.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to course_editor_course_url(@course) }
      format.json { head :no_content }
      format.js { render "delete", :locals => {:rem => params[:id]}}
    end
  end
  
  def new_or_edit
    print "here"
    #render json: "a" => "b" 
    @group = @course.groups.build(:name => "New Module", :appearance_time => Time.zone.now, :due_date => 1.week.from_now)
    @group.events << Event.new(:name => "#{@group.name} due", :start_at => @group.due_date, :end_at => @group.due_date, :all_day => false, :color => "red", :course_id => @course.id)
    
      if @group.save
        @updated = @group.appearance_time.strftime('%d %b (%a)')
        @updatedDue = @group.due_date.strftime('%d %b (%a)')
        logger.debug("appearance time isssss #{@updated}")
        render json: {"group" => @group, "updated"=>@updated, "updatedDue"=>@updatedDue}, status: :created 
      else
       
        render json: @group.errors, status: :unprocessable_entity 
      end
    
  end
  
  
   def sort
   @groups = Group.where(:course_id => @course.id)
   @groups.each do |f|
     f.position = params['group'].index(f.id.to_s) + 1
     f.save
   end
   render json: {"done"=>"done"}
   end
 
   def group_editor
     @group=Group.find(params[:id])
     @lecture= Lecture.find(params[:lec]) if params[:lec]
     #@quiz= OnlineQuiz.find(params[:quiz]) 
     @quiz=OnlineQuiz.where(:id => params[:quiz], :lecture_id => params[:lec]) if params[:quiz]
     @real_quiz=Quiz.where(:id => params[:real_quiz], :group_id => params[:id], :course_id => params[:course_id]) if params[:real_quiz]
     #if @quiz
     #  render :partial => "groups/coordinates"
     #end
     
     logger.debug("in here in coord yayyyy quiz issss #{params[:quiz]}")
     
    if params[:quiz]
    if @quiz.empty?
      redirect_to group_editor_course_group_path(@course, @group), :alert => "Requested quiz does not exist"
    else
      @quiz=@quiz.first
      @old= OnlineAnswer.where(:online_quiz_id => params[:quiz]).to_json
    end
    end
     
    if params[:real_quiz]
    if @real_quiz.empty?
      redirect_to group_editor_course_group_path(@course, @group), :alert => "Requested quiz does not exist"
    else
      @real_quiz=@real_quiz.first
    end
    end
    
     respond_to do |format|
      format.html {}
      format.js { 
        if params[:quiz]
          render "videocoordinates", :locals => {:lec => @lecture}
        elsif params[:lec]
          render "videoquiz", :locals => {:lec => @lecture}
        elsif params[:real_quiz]
          render "quiz", :locals => {:q => @real_quiz}
        end
         
        
        }
      
      end
   end
 
end
