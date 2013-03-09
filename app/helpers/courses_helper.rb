module CoursesHelper
  
def link_to_user(count)
#options[:class] = options.has_key?(:class) ? "#{options[:class]} user-link" : ""
  content_tag :div, :class => "accordian-body collapse", :id => "collapse#{count}" do
    "d"
  end
end 

# def notseen?(lect)
  # puts "over hereeeeeee #{LectureView.where(:lecture_id => lect, :course_id => params[:id], :user_id => current_user.id).inspect}"
  # puts "lecture id : #{lect}, course_id: #{params[:id]} user_id: #{current_user.id}"
  # return LectureView.where(:lecture_id => lect, :course_id => params[:id], :user_id => current_user.id).empty?
# end

def quiznotseen?(quiz)
  #return QuizGrade.where(:user_id => current_user.id, :quiz_id => quiz).empty? #later will check if status is submitted
  if Quiz.find(quiz).quiz_type == 'quiz'
    return QuizStatus.where(:user_id => current_user.id, :quiz_id => quiz, :course_id => params[:id], :status => "Submitted").empty?
  else
    return QuizStatus.where(:user_id => current_user.id, :quiz_id => quiz, :course_id => params[:id], :status => "Saved").empty?
  end
end


def notseen?(lect)
  lecture=Lecture.find(lect)
  return !lecture.done?(current_user.id)
end


end