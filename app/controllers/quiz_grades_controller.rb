class QuizGradesController < ApplicationController
  # GET /quiz_grades
  # GET /quiz_grades.json
  def index
    @quiz_grades = QuizGrade.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quiz_grades }
    end
  end

  # GET /quiz_grades/1
  # GET /quiz_grades/1.json
  def show
    @quiz_grade = QuizGrade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quiz_grade }
    end
  end

  # GET /quiz_grades/new
  # GET /quiz_grades/new.json
  def new
    @quiz_grade = QuizGrade.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quiz_grade }
    end
  end

  # GET /quiz_grades/1/edit
  def edit
    @quiz_grade = QuizGrade.find(params[:id])
  end

  # POST /quiz_grades
  # POST /quiz_grades.json
  def create
    @quiz_grade = QuizGrade.new(params[:quiz_grade])

    respond_to do |format|
      if @quiz_grade.save
        format.html { redirect_to @quiz_grade, notice: 'Quiz grade was successfully created.' }
        format.json { render json: @quiz_grade, status: :created, location: @quiz_grade }
      else
        format.html { render action: "new" }
        format.json { render json: @quiz_grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quiz_grades/1
  # PUT /quiz_grades/1.json
  def update
    @quiz_grade = QuizGrade.find(params[:id])

    respond_to do |format|
      if @quiz_grade.update_attributes(params[:quiz_grade])
        format.html { redirect_to @quiz_grade, notice: 'Quiz grade was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quiz_grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quiz_grades/1
  # DELETE /quiz_grades/1.json
  def destroy
    @quiz_grade = QuizGrade.find(params[:id])
    @quiz_grade.destroy

    respond_to do |format|
      format.html { redirect_to quiz_grades_url }
      format.json { head :no_content }
    end
  end
end
