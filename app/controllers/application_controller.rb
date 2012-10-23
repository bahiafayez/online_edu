class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  
  def after_sign_in_path_for(resource_or_scope) 
    #if current_user.has_role?('user')
    if current_admin_user.nil?
      logger.debug("user iss #{current_user}")
      logger.debug("admin isss #{current_admin_user}")
       courses_path
     else
       admin_dashboard_path
     end
     #else
     #   logger.debug("user issss #{current_user.email}")
     #   teacher_courses_path
     #end
     
     
     
   end


end
