class UsersController < ApplicationController
  before_filter :authenticate_user!  #authenticate meaning is he signed in
  before_filter :correct_user, :except => :index

  def correct_user
    # Checking to see if the current user is taking the course OR teaching the course, otherwise he is not authorised.
    @user=User.find(params[:id])
    if @user!=current_user
      redirect_to root_path, :alert => "You are not authorized to see requested page"
    end
  end
  
  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end

  def show
    authorize! :show, @user, :message => 'Not authorized as an administrator.' #I added this
    @user = User.find(params[:id])
  end
  
  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
    
  def destroy
    print "in destroy"
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
  
  def enroll  
  end
  def enroll_to_course
    @course = Course.find_by_unique_identifier(params[:unique_identifier])
    if @course.nil?
      redirect_to enroll_user_path, :alert => "Course does not exit"
    elsif current_user.courses.include?(@course)
      redirect_to enroll_user_path, :alert => "You are already enrolled in this course."
    else
      @course.users<<current_user
      redirect_to "/", :notice => "You are now enrolled in #{@course.name}" 
    end
  end
end