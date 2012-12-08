class LecturesController < ApplicationController
  # GET /lectures
  # GET /lectures.json
  before_filter :set_zone
  
  def set_zone
    @course=Course.find(params[:course_id])
    Time.zone= @course.time_zone
  end
    
  def index
    @lectures = Lecture.where(:course_id => params[:course_id])
    @course= Course.find(params[:course_id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lectures }
    end
  end

  # GET /lectures/1
  # GET /lectures/1.json
  def show
    #@lecture = Lecture.find(params[:id])
    #@course = Course.find(params[:course_id])
    
    @lecture=Lecture.where(:id => params[:id], :course_id => params[:course_id])
    @course = Course.find(params[:course_id])
    
    if @lecture.empty?
      redirect_to course_lectures_path(params[:course_id]), :alert=> "No such lecture"
    else
    
    @lecture=@lecture.first
    
   
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lecture }
    end
    end
  end

  # GET /lectures/new
  # GET /lectures/new.json
  def new
    @lecture = Lecture.new
    @course = Course.find(params[:course_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lecture }
    end
  end

  # GET /lectures/1/edit
  def edit
    #@lecture = Lecture.find(params[:id])
    #@course = Course.find(params[:course_id])
    
    @lecture=Lecture.where(:id => params[:id], :course_id => params[:course_id])
    @course = Course.find(params[:course_id])
    
    if @lecture.empty?
      redirect_to course_lectures_path(params[:course_id]), :alert=> "No such lecture"
    else
      @lecture=@lecture.first
    end
  end

  # POST /lectures
  # POST /lectures.json
  def create
    @lecture = Lecture.new(params[:lecture])
    @lecture.course_id = params[:course_id]
    @course= Course.find(params[:course_id])
    
    respond_to do |format|
      if @lecture.save
        format.html { redirect_to [@course,@lecture], notice: 'Lecture was successfully created.' }
        format.json { render json: @lecture, status: :created, location: @lecture }
      else
        format.html { render action: "new" }
        format.json { render json: @lecture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lectures/1
  # PUT /lectures/1.json
  def update
    @lecture = Lecture.find(params[:id])
    @course= Course.find(params[:course_id])
    
    @lecture.events.where(:quiz_id => nil, :group_id => @lecture.group.id).destroy_all
    
    respond_to do |format|
      if @lecture.update_attributes(params[:lecture])
        if @lecture.due_date != @lecture.group.due_date or @lecture.appearance_time != @lecture.group.appearance_time
          @lecture.events << Event.new(:name => "#{@lecture.name} due", :start_at => @lecture.due_date, :end_at => @lecture.due_date, :all_day => false, :color => "red", :course_id => @course.id, :group_id => @lecture.group.id)
        end
        format.html { redirect_to [@course, @lecture], notice: 'Lecture was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lecture.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_quiz
    logger.debug("in add quiz!!!!!!")
    OnlineQuiz.create(:lecture_id => params[:id], :time => params[:time])
    @quizzes= OnlineQuiz.where(:lecture_id => params[:id])#.pluck(:time)
    @course= Course.find(params[:course_id])
    @lecture= Lecture.find(params[:id])
    @loc= course_lecture_path(@course,@lecture)
    @loc2=remove_quiz_course_lecture_path(@course,@lecture)
    @loc3=coordinates_course_lecture_path(@course,@lecture)
    render json: {:q => @quizzes, :loc => @loc, :loc2=> @loc2, :loc3 => @loc3} 
  end
  
  def remove_quiz
    logger.debug("in remove quiz!!!!!!")
    @a=OnlineQuiz.find(params[:quiz])
    @a.destroy
    @course= Course.find(params[:course_id])
    @lecture= Lecture.find(params[:id])
    @quizzes= OnlineQuiz.where(:lecture_id => params[:id])#.pluck(:time)
    @loc= course_lecture_path(@course,@lecture)
    @loc2=remove_quiz_course_lecture_path(@course,@lecture)
    @loc3=coordinates_course_lecture_path(@course,@lecture)
    render json: {:q => @quizzes, :loc => @loc, :loc2=> @loc2, :loc3 => @loc3} 
    
   # render json: {:q => @quizzes} 
  end
  
  def insert_quiz
    @lecture=Lecture.where(:id => params[:id], :course_id => params[:course_id])
    @course = Course.find(params[:course_id])
    
    if @lecture.empty?
      redirect_to course_lectures_path(params[:course_id]), :alert=> "No such lecture"
    else
    
    @lecture=@lecture.first
    
    
    @quizzes= OnlineQuiz.where(:lecture_id => params[:id])
    @url= get_answers_course_lecture_path(params[:course_id], params[:id])
    @s=params[:s] if params[:s]
    logger.debug("s issssss #{@s}")
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lecture }
    end
    end
  end
  # DELETE /lectures/1
  # DELETE /lectures/1.json
  def coordinates
    #@quiz=OnlineQuiz.find(params[:quiz])
    @quiz=OnlineQuiz.where(:id => params[:quiz], :lecture_id => params[:id])
    @course= Course.find(params[:course_id])
    @lecture= Lecture.find(params[:id])
    
    if @quiz.empty?
      redirect_to course_lecture_path(@course, @lecture), :alert => "Requested quiz does not exist"
    else
      @quiz=@quiz.first
      @old= OnlineAnswer.where(:online_quiz_id => params[:quiz]).to_json
    end
    
  end
  
  def add_answer
    logger.debug("in add answer!!!#{params[:flag]}")
    if params[:flag]!="false"
      @current=OnlineAnswer.create(:online_quiz_id => params[:quiz], :xcoor => params[:left], :ycoor => params[:top])
    end
    @answers= OnlineAnswer.where(:online_quiz_id => params[:quiz])#.pluck(:time)
    @course= Course.find(params[:course_id])
    @lecture= Lecture.find(params[:id])
    @loc= coordinates_course_lecture_path(@course,@lecture, :quiz => params[:quiz])
    @loc2=remove_answer_course_lecture_path(@course,@lecture)
    #@save= save_answers_course_lecture_path(@course,@lecture)
    #@loc3=coordinates_course_lecture_path(@course,@lecture)
    render json: {:a => @answers, :loc => @loc, :loc2=> @loc2, :save => @save, :current => @current}#, :loc3 => @loc3}
  end
  
  def save_answers2
    @data=params[:stored]
    puts @data
    @course= Course.find(params[:course_id])
    @lecture= Lecture.find(params[:id])
    @data||=[]
    @data.each do |k,v|
      OnlineAnswer.find(k.to_i).update_attributes(:explanation => v[2],:answer => v[1], :correct => v[0] , :ycoor => v[3], :xcoor => v[4])
    end
    
    #redirect_to course_lecture_path(@course,@lecture)
    render json: {:done => "done"}
  end
  
  # def save_answers
    # @course= Course.find(params[:course_id])
    # @lecture= Lecture.find(params[:id])
    # #Just need to save now.
    # @reasons=params[:reason] || []
    # @xcoor=params[:xcoor] || []
    # @ycoor=params[:ycoor] || []
#     
    # @reasons.each do |k,v|
      # OnlineAnswer.find(k.to_i).update_attributes(:answer => v)
    # end
#     
    # @xcoor.each do |k,v|
      # OnlineAnswer.find(k.to_i).update_attributes(:xcoor => v)
    # end
#     
    # @ycoor.each do |k,v|
      # OnlineAnswer.find(k.to_i).update_attributes(:ycoor => v)
    # end
# 
#     
    # #update correct and all others not correct.
#     
    # if params[:quiz]
      # OnlineQuiz.find(params[:quiz].keys[0].to_i).online_answers.each do |a|
        # a.update_attributes(:correct => false)
      # end
      # OnlineAnswer.find(params[:quiz].values[0].to_i).update_attributes(:correct => true)
    # end
#     
    # redirect_to course_lecture_path(@course,@lecture)
  # end
  
  def remove_answer
    logger.debug("in remove answer!!!!!!")
    @a=OnlineAnswer.find(params[:answer])
    @a.destroy
    @course= Course.find(params[:course_id])
    @lecture= Lecture.find(params[:id])
    @answers= OnlineAnswer.where(:online_quiz_id => params[:quiz])#.pluck(:time)
    @loc= coordinates_course_lecture_path(@course,@lecture, :quiz => params[:quiz])
    @loc2=remove_answer_course_lecture_path(@course,@lecture)
    #@save= save_answers_course_lecture_path(@course,@lecture)
    #@loc3=coordinates_course_lecture_path(@course,@lecture)
    render json: {:a => @answers, :loc => @loc, :loc2=> @loc2}#, :save => @save}#, :loc3 => @loc3} 
    
  end
  
  def get_answers
    @a= OnlineQuiz.find(params[:quiz]).online_answers
    @answered= !OnlineQuizGrade.where(:user_id => current_user.id, :online_quiz_id => params[:quiz]).empty? ? "Answered" : "Not Answered"
    render json: {:answers => @a, :ans => @answered}
  end
  
  def save_online
    @answer= params[:answer]
    @quiz= params[:quiz]
    @lecture= Lecture.find(params[:id])
    #@grade = params[:correct]=="Correct" ? 1 : 0
   
   @grade= OnlineAnswer.find(@answer).correct ? 1:0
   
   
    logger.debug("grade is #{@grade}")
    a= OnlineQuizGrade.where(:user_id => current_user.id, :online_quiz_id => @quiz)
    if a.empty?
      OnlineQuizGrade.create(:lecture_id => params[:id], :user_id => current_user.id, :online_quiz_id => @quiz, :online_answer_id => @answer, :grade => @grade)
      render json: {:msg => "Successfully Submitted"}
    else
      render json: {:msg =>"Sorry, you already answered this question", :ans => a.first.online_answer_id }
    end
  end
  
  def seen #lecture was viewed.. will be marked as viewed.
   LectureView.create(:user_id => current_user.id, :course_id => params[:course_id], :lecture_id => params[:id]) if LectureView.where(:user_id => current_user.id, :course_id => params[:course_id], :lecture_id => params[:id]).empty?
   render json:"done"
  end
  
  def answered
    #@quiz= params[:quiz]
    @lecture = Lecture.find(params[:id])
    @qs=@lecture.online_quizzes.find(:all, :order => 'time')
    @answered=[]
    @qs.each do |q|
      @answered<< !OnlineQuizGrade.where(:user_id => current_user.id, :online_quiz_id => q.id).empty?  
    end
    
    render json: {:answered => @answered, :qs => @qs}
  end
  
  def confused
    Confused.create(:lecture_id => params[:id], :course_id => params[:course_id], :user_id => current_user.id, :time => params[:time])
    #should probably rescue if an exception occurs.
    render json: {:msg => "Saved"}  
  end
  
  def confused_question
    LectureQuestion.create(:lecture_id => params[:id], :course_id => params[:course_id], :user_id => current_user.id, :time => params[:time], :question => params[:ques])
    #should probably rescue if an exception occurs.
    render json: {:msg => "Saved"}  
  end
  
  def destroy
    @lecture = Lecture.find(params[:id])
    @course= params[:course_id]
    @lecture.destroy

    respond_to do |format|
      format.html { redirect_to course_editor_course_url(@course) }
      format.json { head :no_content }
      format.js { render "delete", :locals => {:rem => params[:id]}}
    end
  end
  
  def new_or_edit
    @lecture = @course.lectures.build(:name => "New Lecture", :appearance_time => Group.find(params[:group]).appearance_time, :due_date => Group.find(params[:group]).due_date, :url => "none", :group_id => params[:group])
    
    
      if @lecture.save
        @updated = @lecture.appearance_time.strftime('%d %b (%a)')
        logger.debug("appearance time isssss #{@updated}")
        render json: {"lecture" => @lecture, "updated"=>@updated}, status: :created 
      else
       
        render json: @lecture.errors, status: :unprocessable_entity 
      end
      
  end
  
  def new_quiz
    @lecture= Lecture.find(params[:id])
    @quiz = @lecture.online_quizzes.build(:question => "New Quiz", :time => params[:time])
    
    
      if @quiz.save
        render json: {"quiz" => @quiz}, status: :created 
      else
       
        render json: @quiz.errors, status: :unprocessable_entity 
      end
  end
  
end
