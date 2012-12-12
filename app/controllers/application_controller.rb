require "event_calendar"
class ApplicationController < ActionController::Base
  protect_from_forgery
  #load_and_authorize_resource
  #before_filter :user_logged_in?
  before_filter :authenticate_user!  #authenticate meaning is he signed in  #asks you to sign in or up before you can continue.

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  
   # def user_logged_in?
     # unless params[:controller] == 'devise/sessions'  #to all except session controller.
        # if current_user.nil?
          # redirect_to new_user_session_path, :alert => "You are not logged in"
        # end
      # end
  # end

  
  # def after_sign_in_path_for(resource_or_scope) 
    # #if current_user.has_role?('user')
    # if current_admin_user.nil?
      # logger.debug("user iss #{current_user}")
      # logger.debug("admin isss #{current_admin_user}")
       # courses_path
     # else
       # admin_dashboard_path
     # end
     # #else
     # #   logger.debug("user issss #{current_user.email}")
     # #   teacher_courses_path
     # #end
#      
#      
#      
   # end


end
