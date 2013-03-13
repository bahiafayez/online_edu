class HomeController < ApplicationController
  
  skip_before_filter :user_logged_in?
  #skip_before_filter :authenticate_user!
  
  #caches_page :index, :layout => false
  caches_action :index, :layout => false #when to expire?
  
  def index
    @users = User.all
    logger.debug("in hereeeeee!!!")
  end
end
