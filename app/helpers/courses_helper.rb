module CoursesHelper
  
def link_to_user(count)
#options[:class] = options.has_key?(:class) ? "#{options[:class]} user-link" : ""
content_tag :div, :class => "accordian-body collapse", :id => "collapse#{count}" do
  "d"
end

  #link_to(text, user, options) +
  #content_tag(:span, :style => "display: none;", :class => "userbox") do
  #  content_tag(:span, :class => "fn") do
  #    content_tag(:span, :class => "given-name") do user.firstname
  #     end +
 #     content_tag(:span, :class => "family-name") do #user.lastname 
 #      end
    #end 
end 

def notseen?(lect)
  puts "over hereeeeeee #{LectureView.where(:lecture_id => lect, :course_id => params[:id], :user_id => current_user.id).inspect}"
  puts "lecture id : #{lect}, course_id: #{params[:id]} user_id: #{current_user.id}"
  return LectureView.where(:lecture_id => lect, :course_id => params[:id], :user_id => current_user.id).empty?
end

def quiznotseen?(quiz)
  #return QuizGrade.where(:user_id => current_user.id, :quiz_id => quiz).empty? #later will check if status is submitted
  return QuizStatus.where(:user_id => current_user.id, :quiz_id => quiz, :course_id => params[:id], :status => "Submitted").empty?
end

end
