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
    #@real_quiz=@quiz
     @course = Course.find(params[:course_id])
    #Time.zone=ActiveSupport::TimeZone[@course.time_zone]
    puts "Due date beforeee issssss #{params[:quiz][:due_date]}" 
    #params[:quiz][:appearance_time] = ActiveSupport::TimeZone[@course.time_zone].local_to_utc(params[:quiz][:appearance_time])
    #params[:quiz][:due_date] = ActiveSupport::TimeZone[@course.time_zone].local_to_utc(params[:quiz][:due_date])  
    puts "Due date issssss #{params[:quiz][:due_date]}"
    @quiz.events.where(:lecture_id => nil, :group_id => @quiz.group.id).destroy_all
    
    @type= "quiz_#{@quiz.id}"
    
    respond_to do |format|
      if @quiz.update_attributes(params[:quiz])
        
        #@quiz.due_date = @quiz.due_date.end_of_day
        #@quiz.save
          #if same as module, then i will change the due date/ appearance date to be like the module.
        if params[:quiz][:due_date_module] == "1"
          @quiz.due_date=@quiz.group.due_date
        end 
        
        if params[:quiz][:appearance_time_module]=="1"
          @quiz.appearance_time=@quiz.group.appearance_time
        end 
        
        @quiz.save
        #comparing without the seconds.
        if @quiz.due_date.to_formatted_s(:long) != @quiz.group.due_date.to_formatted_s(:long) or @quiz.appearance_time.to_formatted_s(:long) != @quiz.group.appearance_time.to_formatted_s(:long)
          @quiz.events << Event.new(:name => "#{@quiz.name} due", :start_at => params[:quiz][:due_date], :end_at => params[:quiz][:due_date], :all_day => false, :color => "red", :course_id => @course.id, :group_id => @quiz.group.id)
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
    if params[:type]=="quiz"
      @quiz = @course.quizzes.build(:name => "New Quiz", :instructions => "Please choose the correct answer(s)", :appearance_time => Group.find(params[:group]).appearance_time, :due_date => Group.find(params[:group]).due_date ,:appearance_time_module => true, :due_date_module => true, :group_id => params[:group], :quiz_type =>"quiz")
    else
      @quiz = @course.quizzes.build(:name => "New Survey", :instructions => "Please fill in the survey.", :appearance_time => Group.find(params[:group]).appearance_time, :due_date => Group.find(params[:group]).due_date ,:appearance_time_module => true, :due_date_module => true, :group_id => params[:group], :quiz_type => "survey")
    end
    
      if @quiz.save
        
        #place in correct position!
        if !@quiz.group.get_items.empty? #not the first element.
            @quiz.position = @quiz.group.get_items.last.position + 1
            @quiz.save
        end
        
        @updated = @quiz.appearance_time.strftime('%d %b (%a)')
        logger.debug("appearance time isssss #{@updated}")
        #render json: {"quiz" => @quiz, "updated"=>@updated}, status: :created
        @type="quiz_#{@quiz.id}"
        respond_to do |format|
          format.html {}
          format.json {}
          format.js { render "courses/reload_editor"}
        end 
      else
       
        render json: @quiz.errors, status: :unprocessable_entity 
      end
      
  end
  
  def sort #called from module_editor to sort the quizzes (by dragging)
    #sorting in lectures controller.. as we sort both together.
  end
  
  def details
     @quiz = Quiz.find(params[:id])
     respond_to do |format|
      format.js{}
      end
   end
   
   def middle
     @quiz = Quiz.find(params[:id])
     respond_to do |format|
     format.js {}
     end
   end

  def update_questions
    @course= Course.find(params[:course_id])
    @quiz = Quiz.find(params[:id])
    respond_to do |format|
      if params[:quiz]
          @quiz.update_attributes(params[:quiz])
          
          #now delete the answers of the free questions
          @quiz.questions.each do |question|
            if question.question_type == "Free Text Question"
              question.answers.destroy_all
            end
          end
          
          format.js{}
      else
          format.js{}
      end
    end
  end
end
