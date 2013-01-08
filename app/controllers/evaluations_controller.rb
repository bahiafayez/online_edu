class EvaluationsController < ApplicationController
   
  def index
    # # existing
    # @announcements=@course.announcements.where(:user_id => current_user.id)
    # # new
    # @announcement=@course.announcements.build()
  end
  
  def create
    #@group = Group.new()
    if(!Evaluation.where(:user_id => current_user.id, :lecture_id => params[:lecture_id]).empty?)
      return #if already there.. won't create a new one.
    end
    Time.zone = Course.find(params[:course_id]).time_zone
    #@eval = @course.announcements.build(params[:announcement])
    @eval=Evaluation.new(:user_id => current_user.id, :course_id => params[:course_id], :lecture_id => params[:lecture_id], :group_id => Lecture.find(params[:lecture_id]).group_id, :evaluation => params[:eval])
    
    respond_to do |format|
      if @eval.save
        @first_evaluation=false
        format.js{render "create",  :locals =>{:status => "success"}}
      else
        format.js{ render "create",  :locals =>{:status => "failed",:errors => @eval.errors.full_messages.to_sentence}}
      end
    end
  end
  
  def update
     
    @eval = Evaluation.find(params[:id])
    
    respond_to do |format|
      if @eval.update_attributes(params[:evaluation])
        format.html { redirect_to @eval, notice: 'Evaluation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @eval.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @eval = Evaluation.find(params[:id])
    @eval.destroy
    @first_evaluation=true
    respond_to do |format|
      format.html { redirect_to evaluations_url }
      format.json { head :no_content }
      format.js { render "delete", :locals => {:rem => params[:id]}}
    end
  end
  
  def get
    @first=Evaluation.where(:course_id => params[:course_id], :lecture_id => params[:lecture_id], :user_id => current_user.id).empty?
    if !@first
      @eval=Evaluation.where(:course_id => params[:course_id], :lecture_id => params[:lecture_id], :user_id => current_user.id).first
    end
    
    render json: {:eval => @eval, :first => @first}
    
  end

  
end
