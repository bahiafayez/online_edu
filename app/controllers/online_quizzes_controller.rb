class OnlineQuizzesController < ApplicationController
  # GET /online_quizzes
  # GET /online_quizzes.json
  def index
    @online_quizzes = OnlineQuiz.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @online_quizzes }
    end
  end

  # GET /online_quizzes/1
  # GET /online_quizzes/1.json
  def show
    @online_quiz = OnlineQuiz.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @online_quiz }
    end
  end

  # GET /online_quizzes/new
  # GET /online_quizzes/new.json
  def new
    @online_quiz = OnlineQuiz.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @online_quiz }
    end
  end

  # GET /online_quizzes/1/edit
  def edit
    @online_quiz = OnlineQuiz.find(params[:id])
  end

  # POST /online_quizzes
  # POST /online_quizzes.json
  def create
    @online_quiz = OnlineQuiz.new(params[:online_quiz])

    respond_to do |format|
      if @online_quiz.save
        format.html { redirect_to @online_quiz, notice: 'Online quiz was successfully created.' }
        format.json { render json: @online_quiz, status: :created, location: @online_quiz }
      else
        format.html { render action: "new" }
        format.json { render json: @online_quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /online_quizzes/1
  # PUT /online_quizzes/1.json
  def update
    @online_quiz = OnlineQuiz.find(params[:id])
    
    if params[:online_quiz][:time]
       params[:online_quiz][:time]=
       params[:online_quiz][:time].split(":")[0].to_i.send("hours").to_i + 
       params[:online_quiz][:time].split(":")[1].to_i.send("minutes").to_i +
       params[:online_quiz][:time].split(":")[2].to_i.send("seconds").to_i
    end
    
    respond_to do |format|
      if @online_quiz.update_attributes(params[:online_quiz])
        format.html { redirect_to @online_quiz, notice: 'Online quiz was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @online_quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /online_quizzes/1
  # DELETE /online_quizzes/1.json
  def destroy
    @online_quiz = OnlineQuiz.find(params[:id])
    @from_lecture=@online_quiz.lecture
    @online_quiz.destroy

    respond_to do |format|
      format.html { redirect_to online_quizzes_url }
      format.json { head :no_content }
      format.js { render "delete", :locals => {:rem => params[:id], :from_lec =>@from_lecture.id }}
    end
  end
end
