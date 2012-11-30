class QuizzesController < ApplicationController
  # GET /quizzes
  # GET /quizzes.json
  def index
    @quizzes = Quiz.where(:course_id => params[:course_id])
    @course = Course.find(params[:course_id])
    Time.zone=ActiveSupport::TimeZone[@course.time_zone]
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
    Time.zone=ActiveSupport::TimeZone[@course.time_zone]
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
    Time.zone=ActiveSupport::TimeZone[@course.time_zone]  
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
    Time.zone=ActiveSupport::TimeZone[@course.time_zone]
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
    Time.zone=ActiveSupport::TimeZone[@course.time_zone]
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
     @course = Course.find(params[:course_id])
    Time.zone=ActiveSupport::TimeZone[@course.time_zone]
    puts "Due date beforeee issssss #{params[:quiz][:due_date]}" 
    #params[:quiz][:appearance_time] = ActiveSupport::TimeZone[@course.time_zone].local_to_utc(params[:quiz][:appearance_time])
    #params[:quiz][:due_date] = ActiveSupport::TimeZone[@course.time_zone].local_to_utc(params[:quiz][:due_date])  
    puts "Due date issssss #{params[:quiz][:due_date]}"

    respond_to do |format|
      if @quiz.update_attributes(params[:quiz])
        format.html { redirect_to course_quiz_path(params[:course_id], params[:id]), notice: 'Quiz was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
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
  
  def new_or_edit
    @course = Course.find(params[:course_id])
    @quiz = @course.quizzes.build(:name => "New Quiz", :appearance_time => Time.zone.now, :due_date => 2.days.from_now , :group_id => params[:group])
    
    
      if @quiz.save
        @updated = @quiz.appearance_time.strftime('%d %b (%a)')
        logger.debug("appearance time isssss #{@updated}")
        render json: {"quiz" => @quiz, "updated"=>@updated}, status: :created 
      else
       
        render json: @quiz.errors, status: :unprocessable_entity 
      end
      
  end
  
end
