class Enrollment < ActiveRecord::Base
  
  belongs_to :course
  belongs_to :user, :touch => true #so when enrollments change, it affect the associated user. (updated_at column)
  
  attr_accessible :course_id, :user_id
  
  # user y can be enrolled in course x once only
  validates_uniqueness_of :user_id,  :scope => :course_id #the pair course_id user_id must be unique
  
  before_destroy :delete_student_data
  
  private
  def delete_student_data
    #further more.. want to remove all his data!!!!!
    Back.destroy_all(:user_id => user_id, :course_id => course_id)
    Confused.destroy_all(:user_id => user_id, :course_id => course_id)
    LectureQuestion.destroy_all(:user_id => user_id, :course_id => course_id)
    Pause.destroy_all(:user_id => user_id, :course_id => course_id)
    LectureView.destroy_all(:user_id => user_id, :course_id => course_id)
    QuizStatus.destroy_all(:user_id => user_id, :course_id => course_id)
    course=Course.find(course_id)
    course.quizzes.each do |quiz|
      QuizGrade.destroy_all(:user_id => user_id, :quiz_id => quiz.id)
      FreeAnswer.destroy_all(:user_id => user_id, :quiz_id => quiz.id)
    end
    course.lectures.each do |lecture|
      OnlineQuizGrade.destroy_all(:user_id => user_id, :lecture_id => lecture.id)
    end
  end
end

