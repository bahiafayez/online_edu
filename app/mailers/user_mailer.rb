class UserMailer < ActionMailer::Base
  default from: "info@scalable-learning.com"
  
  def welcome_email(user)
    @from =  "\"Scalable Learning\" <info@scalable-learning.com>"
    @user = user
    @url  = "http://www.scalable-learning.com"
    mail(:to => user.email, :subject => "Welcome to Scalable Learning", :from => @from)
  end
  
  def announcement_email(users, announcement, course)
    @from =  "\"Scalable Learning\" <info@scalable-learning.com>"
    @users = users
    @announcement = announcement
    @url  = "http://www.scalable-learning.com/courses/#{course.id}"
    @course = course
    mail(:bcc => users, :subject => "New Announcement - #{course.name}", :from => @from)
  end
end
