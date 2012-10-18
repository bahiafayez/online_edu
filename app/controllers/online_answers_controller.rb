class OnlineAnswersController < ApplicationController
  # GET /online_answers
  # GET /online_answers.json
  def index
    @online_answers = OnlineAnswer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @online_answers }
    end
  end

  # GET /online_answers/1
  # GET /online_answers/1.json
  def show
    @online_answer = OnlineAnswer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @online_answer }
    end
  end

  # GET /online_answers/new
  # GET /online_answers/new.json
  def new
    @online_answer = OnlineAnswer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @online_answer }
    end
  end

  # GET /online_answers/1/edit
  def edit
    @online_answer = OnlineAnswer.find(params[:id])
  end

  # POST /online_answers
  # POST /online_answers.json
  def create
    @online_answer = OnlineAnswer.new(params[:online_answer])

    respond_to do |format|
      if @online_answer.save
        format.html { redirect_to @online_answer, notice: 'Online answer was successfully created.' }
        format.json { render json: @online_answer, status: :created, location: @online_answer }
      else
        format.html { render action: "new" }
        format.json { render json: @online_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /online_answers/1
  # PUT /online_answers/1.json
  def update
    @online_answer = OnlineAnswer.find(params[:id])

    respond_to do |format|
      if @online_answer.update_attributes(params[:online_answer])
        format.html { redirect_to @online_answer, notice: 'Online answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @online_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /online_answers/1
  # DELETE /online_answers/1.json
  def destroy
    @online_answer = OnlineAnswer.find(params[:id])
    @online_answer.destroy

    respond_to do |format|
      format.html { redirect_to online_answers_url }
      format.json { head :no_content }
    end
  end
end
