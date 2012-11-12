class HomeController < ApplicationController
  
  skip_before_filter :user_logged_in?
  #skip_before_filter :authenticate_user!
  
  def index
    @users = User.all
    logger.debug("in hereeeeee!!!")
  end
end
