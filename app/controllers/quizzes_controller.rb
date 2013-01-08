class QuizzesController < ApplicationController
  # GET /quizzes
  # GET /quizzes.json
  before_filter :set_zone
  
  def set_zone
    @course=Course.find(params[:course_id])
    Time.zone= @course.time_zone
  end
  
  def index
    @quizzes = Quiz.where(:course_id => params[:course_id])
    @course = Course.find(params[:course_id])
    #Time.zone=ActiveSupport::TimeZone[@course.time_zone]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quizzes }
    end
  end

  # GET /quizzes/1
  # GET /quizzes/1.json
  def show
    #@quiz = Quiz.find(params[:id])
    @quiz=Quiz.where(:id => params[:id], :course_id => params[:course_id])
    @course = Course.find(params[:course_id])
    #Time.zone=ActiveSupport::TimeZone[@course.time_zone]
    if @quiz.empty?
      redirect_to course_quizzes_path(params[:course_id]), :alert=> "No such quiz"
    else
    
    @quiz=@quiz.first
    @questions= @quiz.questions

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quiz }
    end
    end
  end

  # GET /quizzes/new
  # GET /quizzes/new.json
  def new
    
    @course = Course.find(params[:course_id])
    #Time.zone=ActiveSupport::TimeZone[@course.time_zone]  
    @quiz = Quiz.new
    
  
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quiz }
    end
  end

  # GET /quizzes/1/edit
  def edit
    #@quiz = Quiz.find(params[:id])
    #@course = Course.find(params[:course_id])
    @course = Course.find(params[:course_id])
    #Time.zone=ActiveSupport::TimeZone[@course.time_zone]
    @quiz=Quiz.where(:id => params[:id], :course_id => params[:course_id])
    
    if @quiz.empty?
      redirect_to course_quizzes_path(params[:course_id]), :alert=> "No such quiz"
    else 
      @quiz=@quiz.first
      #@quiz.appearance_time= ActiveSupport::TimeZone[@course.time_zone].utc_to_local(@quiz.appearance_time)
      #@quiz.due_date= ActiveSupport::TimeZone[@course.time_zone].utc_to_local(@quiz.due_date)
    
    end
    
      
  end

  # POST /quizzes
  # POST /quizzes.json
  def create

    @course = Course.find(params[:course_id])
    #Time.zone=ActiveSupport::TimeZone[@course.time_zone]
    @quiz = Quiz.new(params[:quiz])
    #converting from course time zone to UTC
    
    #@quiz.appearance_time = ActiveSupport::TimeZone[@course.time_zone].local_to_utc(@quiz.appearance_time)
    #@quiz.due_date = ActiveSupport::TimeZone[@course.time_zone].local_to_utc(@quiz.due_date)  
    
    @quiz.course_id = params[:course_id]

    respond_to do |format|
      if @quiz.save
        format.html { redirect_to course_quiz_path(params[:course_id], @quiz.id) , notice: 'Quiz was successfully created.' }
        format.json { render json: @quiz, status: :created, location: @quiz }
      else
        format.html { render action: "new" }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quizzes/1
  # PUT /quizzes/1.json
  def update
    @quiz = Quiz.find(params[:id])
    @real_quiz=@quiz
     @course = Course.find(params[:course_id])
    #Time.zone=ActiveSupport::TimeZone[@course.time_zone]
    puts "Due date beforeee issssss #{params[:quiz][:due_date]}" 
    #params[:quiz][:appearance_time] = ActiveSupport::TimeZone[@course.time_zone].local_to_utc(params[:quiz][:appearance_time])
    #params[:quiz][:due_date] = ActiveSupport::TimeZone[@course.time_zone].local_to_utc(params[:quiz][:due_date])  
    puts "Due date issssss #{params[:quiz][:due_date]}"
    @quiz.events.where(:lecture_id => nil, :group_id => @quiz.group.id).destroy_all
    
    respond_to do |format|
      if @quiz.update_attributes(params[:quiz])
        #@quiz.due_date = @quiz.due_date.end_of_day
        #@quiz.save
        
        if @quiz.due_date != @quiz.group.due_date or @quiz.appearance_time != @quiz.group.appearance_time
          @quiz.events << Event.new(:name => "#{@quiz.name} due", :start_at => @quiz.due_date, :end_at => @quiz.due_date, :all_day => false, :color => "red", :course_id => @course.id, :group_id => @quiz.group.id)
        end
        format.html { redirect_to course_quiz_path(params[:course_id], params[:id]), notice: 'Quiz was successfully updated.' }
        format.json { head :no_content }
        format.js {}
      else
        format.html { render action: "edit" }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # DELETE /quizzes/1
  # DELETE /quizzes/1.json
  def destroy
    @quiz = Quiz.find(params[:id])
    @quiz.destroy
    @course = params[:course_id]

    respond_to do |format|
      format.html { redirect_to course_quizzes_url(@course) }
      format.json { head :no_content }
      format.js { render "delete", :locals => {:rem => params[:id]}}
    end
  end
  
  def new_or_edit   #called from course_editor / module editor to add a new quiz
    @course = Course.find(params[:course_id])
    @quiz = @course.quizzes.build(:name => "New Quiz", :instructions => "Please choose the correct answer(s)", :appearance_time => Group.find(params[:group]).appearance_time, :due_date => Group.find(params[:group]).due_date , :group_id => params[:group])
    
    
      if @quiz.save
        @updated = @quiz.appearance_time.strftime('%d %b (%a)')
        logger.debug("appearance time isssss #{@updated}")
        render json: {"quiz" => @quiz, "updated"=>@updated}, status: :created 
      else
       
        render json: @quiz.errors, status: :unprocessable_entity 
      end
      
  end
  
end
