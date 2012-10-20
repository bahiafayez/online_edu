class LecturesController < ApplicationController
  # GET /lectures
  # GET /lectures.json
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
    @lecture = Lecture.find(params[:id])
    @course = Course.find(params[:course_id])
    @quizzes= OnlineQuiz.where(:lecture_id => params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lecture }
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
    @lecture = Lecture.find(params[:id])
    @course = Course.find(params[:course_id])
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
    
    respond_to do |format|
      if @lecture.update_attributes(params[:lecture])
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
  # DELETE /lectures/1
  # DELETE /lectures/1.json
  def coordinates
    @quiz=OnlineQuiz.find(params[:quiz])
    @course= Course.find(params[:course_id])
    @lecture= Lecture.find(params[:id])
  end
  
  def add_answer
    logger.debug("in add answer!!!#{params[:flag]}")
    if params[:flag]!="false"
      OnlineAnswer.create(:online_quiz_id => params[:quiz], :xcoor => params[:left], :ycoor => params[:top])
    end
    @answers= OnlineAnswer.where(:online_quiz_id => params[:quiz])#.pluck(:time)
    @course= Course.find(params[:course_id])
    @lecture= Lecture.find(params[:id])
    @loc= coordinates_course_lecture_path(@course,@lecture)
    @loc2=remove_answer_course_lecture_path(@course,@lecture)
    #@loc3=coordinates_course_lecture_path(@course,@lecture)
    render json: {:a => @answers, :loc => @loc, :loc2=> @loc2}#, :loc3 => @loc3}
  end
  
  def remove_answer
    logger.debug("in remove answer!!!!!!")
    @a=OnlineAnswer.find(params[:answer])
    @a.destroy
    @course= Course.find(params[:course_id])
    @lecture= Lecture.find(params[:id])
    @answers= OnlineAnswer.where(:online_quiz_id => params[:quiz])#.pluck(:time)
    @loc= coordinates_course_lecture_path(@course,@lecture, :quiz => params[:quiz])
    @loc2=remove_answer_course_lecture_path(@course,@lecture)
    #@loc3=coordinates_course_lecture_path(@course,@lecture)
    render json: {:a => @answers, :loc => @loc, :loc2=> @loc2}#, :loc3 => @loc3} 
    
  end
  
  def get_answers
    @a= OnlineQuiz.find(params[:quiz]).online_answers
    render json: @a
  end
  
  def destroy
    @lecture = Lecture.find(params[:id])
    @course= params[:course_id]
    @lecture.destroy

    respond_to do |format|
      format.html { redirect_to course_lectures_url(@course) }
      format.json { head :no_content }
    end
  end
end
