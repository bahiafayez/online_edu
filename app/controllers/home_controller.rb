class HomeController < ApplicationController
  
  skip_before_filter :user_logged_in?
  def index
    @users = User.all
  end
end
