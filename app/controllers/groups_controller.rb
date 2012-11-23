class GroupsController < ApplicationController
  # GET /online_answers
  # GET /online_answers.json
  before_filter :getCourse
  before_filter :set_zone
  
  def set_zone
    @course=Course.find(params[:course_id])
    Time.zone= @course.time_zone
  end
  
  def getCourse
    @course= Course.find(params[:course_id])  
  end
  
  def index
    @groups = @course.groups

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /online_answers/1
  # GET /online_answers/1.json
  def show
      @group = @course.groups.find(params[:id])
      logger.debug("group isss #{@group.name}")
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @group }
      end
  rescue #ActiveRecord::RecordInvalid because recordnot found
        flash[:error] = "Group not found"
        redirect_to :action => :index 
  end

  # GET /online_answers/new
  # GET /online_answers/new.json
  def new
    @group=@course.groups.build()
    #@group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /online_answers/1/edit
  def edit
    begin
      @group = @course.groups.find(params[:id])
    rescue
      flash[:error] = "Group not found"
      redirect_to :action => :index
    end
  end

  # POST /online_answers
  # POST /online_answers.json
  def create
    #@group = Group.new()
    @group = @course.groups.build(params[:group])

    respond_to do |format|
      if @group.save
        format.html { redirect_to [@course,@group], notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /online_answers/1
  # PUT /online_answers/1.json
  def update
    @group = @course.groups.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to [@course,@group], notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /online_answers/1
  # DELETE /online_answers/1.json
  def destroy
    @group = @course.groups.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to course_groups_url(@course) }
      format.json { head :no_content }
    end
  end
end
