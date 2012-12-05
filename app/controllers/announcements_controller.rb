class AnnouncementsController < ApplicationController
  # GET /lectures
  # GET /lectures.json
  before_filter :set_zone
  
  def set_zone
    @course=Course.find(params[:course_id])
    Time.zone= @course.time_zone
  end
  
  def index
    # existing
    @announcements=@course.announcements.where(:user_id => current_user.id)
    # new
    @announcement=@course.announcements.build()
  end
  
  def create
    #@group = Group.new()
    @announcementN = @course.announcements.build(params[:announcement])
    @announcementN.user_id=current_user.id
    @announcementN.date=Time.zone.now
    @announcementN.announcement.gsub!(/\r\n/," ")
    
    respond_to do |format|
      if @announcementN.save
        format.html { redirect_to [@course,@announcementN], notice: 'Announcement was successfully created.' }
        format.json { render json: @announcementN, status: :created, location: @announcementN }
        format.js{render "create",  :locals =>{:status => "success"}}
      else
        format.html { render action: "new" }
        format.json { render json: @announcementN.errors, status: :unprocessable_entity }
        format.js{ render "create",  :locals =>{:status => "failed",:errors => @announcementN.errors.full_messages.to_sentence}}
      end
    end
  end
  
  def update
     
    @announcement = @course.announcements.find(params[:id])
    
    respond_to do |format|
      if @announcement.update_attributes(params[:announcement])
        format.html { redirect_to [@course,@announcement], notice: 'Announcement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @announcement = @course.announcements.find(params[:id])
    @announcement.destroy

    respond_to do |format|
      format.html { redirect_to course_announcements_url(@course) }
      format.json { head :no_content }
      format.js { render "delete", :locals => {:rem => params[:id]}}
    end
  end


end