module LecturesHelper
  def online_quiz_done(id, user_id)
    return !OnlineQuizGrade.where(:user_id => user_id, :online_quiz_id => id).empty?
  end
end
