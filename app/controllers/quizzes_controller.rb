class QuizzesController < ApplicationController
  # GET /quizzes
  # GET /quizzes.json
  def index
    @quizzes = Quiz.where(:course_id => params[:course_id])
    @course = Course.find(params[:course_id])
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
    @quiz = Quiz.new
    @course = Course.find(params[:course_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quiz }
    end
  end

  # GET /quizzes/1/edit
  def edit
    #@quiz = Quiz.find(params[:id])
    #@course = Course.find(params[:course_id])

    @quiz=Quiz.where(:id => params[:id], :course_id => params[:course_id])
    @course = Course.find(params[:course_id])
    
    if @quiz.empty?
      redirect_to course_quizzes_path(params[:course_id]), :alert=> "No such quiz"
    else 
      @quiz=@quiz.first
    end
    
      
  end

  # POST /quizzes
  # POST /quizzes.json
  def create
    
     
    @quiz = Quiz.new(params[:quiz])
    @course = Course.find(params[:course_id])
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
    end
  end
end
