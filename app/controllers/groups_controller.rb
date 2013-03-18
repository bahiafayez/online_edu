class GroupsController < ApplicationController
  load_and_authorize_resource 
  # GET /online_answers
  # GET /online_answers.json
  
  before_filter :getCourse
  before_filter :correct_user
  before_filter :set_zone
 
  
  def set_zone
    @course=Course.find(params[:course_id])
    Time.zone= @course.time_zone
  end
  
  def getCourse
    @course= Course.find(params[:course_id])  
  end
  
  def correct_user
    # Checking to see if the current user is taking the course OR teaching the course, otherwise he is not authorised.
    @c=Course.find(params[:course_id])
    if !@c.users.include?(current_user) and !(@c.user == current_user)
      redirect_to courses_path, :alert => "You are not authorized to see requested page"
    end
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
    
    # When I update the module, I need to update the event as well. Can destroy it and create it again since I have only one event per module.
    # If the lecture/quiz have different appearance or due dates, then I create a separate event for them as well. (but only one per lecture/quiz as well (for due date only))
    @group.events.where(:quiz_id => nil, :lecture_id => nil).destroy_all #its ok since I only have the due date.
    
    
    respond_to do |format|
      if @group.update_attributes(params[:group])
        #@group.due_date= @group.due_date.next_day #end_of_day #because if 15 sep.. then due date should be beg of 16.
        #@group.save
        print params[:group][:due_date]
        print "due is"
        print @group.due_date
        
        @group.events << Event.new(:name => "#{@group.name} due", :start_at => params[:group][:due_date], :end_at => params[:group][:due_date], :all_day => false, :color => "red", :course_id => @course.id)
        
        # also change due date and appearance date of all lectures/quizzes with boolean checked.
        @group.lectures.each do |l|
          if l.appearance_time_module
            l.appearance_time = @group.appearance_time
          end
          if l.due_date_module
            l.due_date = @group.due_date
          end
          l.save
        end
        
        @group.quizzes.each do |q|
          if q.appearance_time_module
            q.appearance_time = @group.appearance_time
          end
          if q.due_date_module
            q.due_date = @group.due_date
          end
          q.save
        end
        
        @course= @group.course
        @group_new=@group
        
        #@type="group_#{@group.id}"
        if !@group.get_items.empty?
          @type= "#{@group.get_items[0].class.name.downcase}_#{@group.get_items[0].id}"
        end
        
        format.html { redirect_to [@course,@group], notice: 'Group was successfully updated.' }
        format.json { head :no_content }
        format.js{}
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
    group_lectures=@group.lectures.pluck(:id)
    group_quizzes=@group.quizzes.pluck(:id)
    @group.destroy

    
    respond_to do |format|
      format.html { redirect_to course_editor_course_url(@course) }
      format.json { head :no_content }
      format.js { render "delete", :locals => {:rem => params[:id], :group_lectures =>group_lectures, :group_quizzes => group_quizzes }}
    end
  end
  
  def new_or_edit #called from course_editor / module editor to add a new module
    print "here"
    #render json: "a" => "b" 
    @group = @course.groups.build(:name => "New Module", :appearance_time => Time.zone.now.to_date, :due_date => 1.week.from_now.to_date) #added to_date so it won't have time.
    @group.events << Event.new(:name => "#{@group.name} due", :start_at => 1.week.from_now.to_date, :end_at => 1.week.from_now.to_date, :all_day => false, :color => "red", :course_id => @course.id)
    
      if @group.save
        @updated = @group.appearance_time.strftime('%d %b (%a)')
        @updatedDue = @group.due_date.strftime('%d %b (%a)')
        logger.debug("appearance time isssss #{@updated}")
        respond_to do |format|
          format.html {}
          format.json {}
          format.js { render "reload_editor", :locals => {:rem => @course}}
        end
         
      
      else
       logger.debug(@group.errors.full_messages)
        render json: @group.errors, status: :unprocessable_entity 
      end
    
  end
  
  
   def sort #called from course_editor to sort the modules (by dragging)
   @groups = Group.where(:course_id => @course.id)
   @groups.each do |f|
     f.position = params['group'].index(f.id.to_s) + 1
     f.save
   end
   render json: {"done"=>"done"}
   end
   
 
   def group_editor
     #stopped here
     # Getting the lecture/quiz/onlinequiz to render on the right hand side using a javascript partial.
     @group=Group.find(params[:id])
     @lecture= Lecture.find(params[:lec]) if params[:lec]
     @quiz=OnlineQuiz.where(:id => params[:quiz], :lecture_id => params[:lec]) if params[:quiz]
     @real_quiz=Quiz.where(:id => params[:real_quiz], :group_id => params[:id], :course_id => params[:course_id]) if params[:real_quiz]
     #if @quiz
     #  render :partial => "groups/coordinates"
     #end
     
     #getting order
     @all = @group.lectures + @group.quizzes
     @all.sort!{|x,y| ( x.position and y.position ) ? x.position <=> y.position : ( x.position ? -1 : 1 )  }
     @to_return=[]
     @all.each do |s|
       @to_return<< "#{s.class.name.downcase}_#{s.id}"
     end
     
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
   
   def statistics
     @group_new= Group.find(params[:id])
     #render json: {"group"=>@group_new}
     respond_to do |format|
      format.js{}
      end
   end
   
   def details
     @group_new = Group.find(params[:id])
     respond_to do |format|
      format.js{}
      end
   end
   
   def save_review_questions
    to_hide= params[:hide]  
    if !to_hide.nil?
        @hide= to_hide.keys  
    else
        @hide=[]
    end
    
    @hide= @hide.map{|e| e.to_i}
    @group=Group.find(params[:id])
    @lectures= @group.lectures.pluck(:id)
    
    puts "hide is #{@hide.inspect}"
    LectureQuestion.where(:lecture_id => @lectures).each do |l|
      if @hide.include?(l.id)
        #l.update_attributes(:hide => true)
        l.hide = true
        l.save if l.hide_changed?
      else
        l.hide = false
        l.save if l.hide_changed?
      end
    end
     
    
     redirect_to review_questions_course_group_path(@course, @group)
    
    
   end
   def review_questions
     
    @course=Course.find(params[:course_id])
    @students=@course.users
    @quizzes=@course.quizzes.where("quiz_type IS NULL or quiz_type != 'survey'")
    @student_names=[]
    @type = "modules"
    @highlight= "group_#{@group.id}"
    @group=Group.find(params[:id])
     
     @lectures= @group.lectures.pluck(:id)
     @lecture_questions2 = [] #LectureQuestion.where(:lecture_id => @lectures)
     @lectures.each do |l|
       @lecture_questions2<<LectureQuestion.where(:lecture_id => l).order(:time)
     end
     @lecture_questions2.flatten!
     
     render "courses/progress_teacher"
   end
   
   def display_quizzes    
     @group = Group.find(params[:id])
     @num_lectures= @group.lectures.count
     @num_quizzes= @group.total_questions 
     @lecture_list= @group.get_lecture_list
     @display_data=@group.get_display_data
     
     #for charts
     @module_new = @group.get_data_percent
      @module_colors = @group.get_colors
      @module_categories = @group.get_categories
      @module_questions = @group.get_questions
     
     if @num_quizzes == 0
       redirect_to progress_teacher_course_path(@course, :g=>@group.id ,:type=>"modules"), :alert => "There are no quizzes in this module"
     else
      render :layout => "display"
      end
   end
   
   def display_questions    
     @group = Group.find(params[:id])
     @num_lectures= @group.lectures.count
     @num_quizzes= @group.total_student_questions 
     @lecture_list= @group.get_lecture_list
     @display_data=@group.get_display_question_data
     
     if @num_quizzes == 0
       redirect_to progress_teacher_course_path(@course, :g=>@group.id ,:type=>"modules"), :alert => "There are no student questions in this module"
     else
     
      render :layout => "display"
      end
   end
   
   def new_document
    @group= Group.find(params[:id])
    course=Course.find(params[:course_id])
    @document = @group.documents.build(:name => "New Document", :url => "Empty", :course_id => course.id)
    
    
      if @document.save
        #render json: {"quiz" => @quiz}, status: :created 
        respond_to do |format|
          format.js{}
          format.json{}
        end
      else
       
        render json: @document.errors, status: :unprocessable_entity 
      end
  end
  
 
end
