class UserMailer < ActionMailer::Base
  default from: "info@scalable-learning.com"
  
  def welcome_email(user)
    @from =  "\"Scalable Learning\" <info@scalable-learning.com>"
    @user = user
    @url  = "http://scalable-learning.com"
    mail(:to => user.email, :subject => "Welcome to Scalable Learning", :from => @from)
  end
  
  def announcement_email(users, announcement, course)
    @from =  "\"Scalable Learning\" <info@scalable-learning.com>"
    @users = users
    @announcement = announcement
    @url  = "http://scalable-learning.com/courses/#{course.id}"
    @course = course
    @reply_to= course.user.email
    mail(:bcc => users, :subject => "New Announcement - #{course.name}", :from => @from, :reply_to => @reply_to)
  end
  
  def student_email(user, subject, message, teacher_email)
    @from =  "\"Scalable Learning\" <info@scalable-learning.com>"
    @message=message   
    mail(:to => user, :subject => subject, :from => @from, :reply_to => teacher_email)
  end
  
  def student_batch_email(users, subject, message, teacher_email)
    @from =  "\"Scalable Learning\" <info@scalable-learning.com>"
    @message=message   
    @users= users.map{|user| user.email}
    mail(:bcc => @users, :subject => subject, :from => @from, :reply_to => teacher_email)
  end
end
