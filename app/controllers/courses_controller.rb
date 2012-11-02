class CoursesController < ApplicationController
  load_and_authorize_resource   #cancan to check if user is allowed to perform an action. checks from ability.rb
  before_filter :correct_user, :except => [:index]
  # GET /courses
  # GET /courses.json
  def correct_user
    @c=Course.find(params[:id])
    puts "!!!!!!!!!!!!!!!!!!!!! course is #{@c.users.include?(current_user)} and other is #{@c.user == current_user} together #{ (!@c.users.include?(current_user))  and !(@c.user == current_user)}"
    if !@c.users.include?(current_user) and !(@c.user == current_user)
      redirect_to courses_path, :alert => "You are not authorized to see requested page"
    end
  end
  
  def index
  
    if can? :update, @course #instructor   
        @courses = current_user.subjects #Course.where(:user_id => current_user.id)  #courses that person teaches
    else
        @courses = current_user.courses 
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def student_show
    @course = Course.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
    
  end
  def show
    @course = Course.find(params[:id])
    
    all_users= User.all #- User.joins(:courses).where("course_id == 3")
    #User.joins(:courses).where("course_id == ?",params[:id])
    @students = all_users.find_all{|u| u.has_role?('user')}  #returns students only.. later instead of User make Student
    
    
    # enrolled students
    @students2 = @course.users  # students enrolled in the course.
    @student_ids= @students2.map{|a| a.id}
    
    #students not enrolled
    all_users2= User.all - User.joins(:courses).where("course_id = ?", params[:id].to_i)

    @student_ids2=all_users2.find_all{|u| u.has_role?('user')}.map{|a| a.id}
    
    logger.debug("students areeeee #{@students}")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = Course.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
  end

  # POST /courses
  # POST /courses.json
  def create
    params[:course][:user_id]=current_user.id
    
    @course = Course.new(params[:course])

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    
    #don't need to add user_id here.. already exists.
    
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end
  
  def remove_student
    @course = params[:id]
    @student=User.find(params[:student])
    @student.enrollments.where(:course_id => @course).destroy_all
    
    logger.debug @course
    text="hey there"
    
    render json: text


  end
  
  def add_student
    @course = Course.find(params[:id])
    @student=User.find(params[:student])
    @course.users<<@student
    if @course.save
    #@student.enrollments.where(:course_id => @course).destroy_all
    
      logger.debug @course
      text="successful"
    
      render json: text
    else
      render json: "failed"
    end
  end
  
  def courseware
    if params[:q]   #requesting quiz
      #@q= Quiz.find(params[:q]) 
      @q= Quiz.where(:id => params[:q], :course_id => params[:id]).first
      if @q.nil?
        redirect_to courseware_course_path(params[:id]), :alert => "No such quiz"
      end
      @type="quiz"
      @answers= QuizGrade.select("question_id, answer_id").where(:user_id=>current_user.id , :quiz_id=> params[:q])
      @correct_answers= QuizGrade.where(:user_id=>current_user.id , :quiz_id=> params[:q]).select("distinct(question_id), grade")
      @out={}
      @correct={}
      
      
      @answers.each do |a|
        if @out[a.question_id].nil?
            @out[a.question_id]=[a.answer_id]
        else
          @out[a.question_id]<<a.answer_id
        end   
      end
      
      @correct_answers.each do |s|
        @correct[s.question_id]= s.grade
      end
      
      
      
      
      print "out isssss!!!!!!! #{@out}"
    end
    
    if params[:l]   #requesting lecture
      #@q= Lecture.find(params[:l])
      @q= Lecture.where(:id => params[:l], :course_id => params[:id]).first
      if @q.nil?
        redirect_to courseware_course_path(params[:id]), :alert => "No such lecture"
      end
      @type="lecture" 
      @url= get_answers_course_lecture_path(params[:id], params[:l])
      #@an= QuizGrade.select("question_id, answer_id").where(:user_id=>current_user.id , :quiz_id=> params[:q])
      #@out={}
      #@answers.each do |a|
      #  @out[a.question_id]=a.answer_id
      #end
      #print "out isssss!!!!!!! #{@out}"
    end
    
  end
  
  def courseware_teacher
    
  end
  def enrolled_students
     @course = Course.find(params[:id])
    
    all_users= User.all #- User.joins(:courses).where("course_id == 3")
    #User.joins(:courses).where("course_id == ?",params[:id])
    @students = all_users.find_all{|u| u.has_role?('user')}  #returns students only.. later instead of User make Student
    
    
    # enrolled students
    @students2 = @course.users  # students enrolled in the course.
    @student_ids= @students2.map{|a| a.id}
    
    #students not enrolled
    all_users2= User.all - User.joins(:courses).where("course_id = ?", params[:id].to_i)

    @student_ids2=all_users2.find_all{|u| u.has_role?('user')}.map{|a| a.id}
    
    logger.debug("students areeeee #{@students}")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end
  def progress
    
    #At the moment there are only quizzes.. later assigments, lectures, lecture quizzes,... graphs for grades..
    @quizzes=Course.find(params[:id]).quizzes
    @quizNames=[]
    @quizzes_taken=[]
    @quizScores=[]
    @quizzes.each do |q|
      if !QuizGrade.where(:quiz_id => q.id, :user_id => current_user.id).empty?
        @quizzes_taken<<q
        @quizNames<<q.name
        count=q.questions.count
        num=0.0
        QuizGrade.where(:quiz_id => q.id, :user_id => current_user.id).select("distinct(question_id), grade").each do |ques|
        #q.questions.each do |ques|
          if ques.grade==1
            num+=1.0
          end
        end
        logger.debug("num isss #{num/count}")
        @quizScores<< num/count * 100
      end
      
    end
    
  end
  
  def progress_teacher
    @course=Course.find(params[:id])
    @students=@course.users
    @quizzes=@course.quizzes
    @student_names=[]
    @data=[]
    @quizScores=[]
    
      
      @quizzes.each do |q|
        @students.each do |s|
          @student_names<<s.name
          num=0
          QuizGrade.where(:quiz_id => q.id, :user_id => s.id).select("distinct(question_id), grade").each do |ques|
            if ques.grade==1
              num+=1.0
            end
          end
          @quizScores<< num/q.questions.count * 100
      end
      @data<<{:name => q.name, :data => @quizScores}
      @quizScores=[]
    end
    
    @data = @data.to_json   #json : javascript object!!
    
  end
  
  def progress_teacher_detailed
    @course=Course.find(params[:id])
    @student=params[:q]
    
    
    #Quizzes student has taken:
    @quizzes=Course.find(params[:id]).quizzes
    @quizzes_taken=[]
    @quizzes.each do |q|
      if !QuizGrade.where(:quiz_id => q.id, :user_id => @student).empty?
        @quizzes_taken<<q
      end
    end
    
  end
  
  
  def student_quiz
    #could move to quiz_grades_controller later.
    @answers=params[:answer] || []
    @quiz_id=params[:quiz]
    @user_id=current_user.id
    
    if @answers.empty? or @answers.keys.count < Quiz.find(@quiz_id).questions.count  #there qere unanswered questions.
      redirect_to courseware_course_path(params[:id], :q=>@quiz_id), :alert => "There are unanswered questions"
    else 
    
    
    #delete old ones
    a=QuizGrade.where(:user_id => @user_id, :quiz_id => @quiz_id)
    a.destroy_all


    #@answers.each do |a|
      #print "answers are #{@answers}"
      #print "keys #{@answers.keys}"
      @answers.each do |k,v|
        print "question: #{k}"
        print "answers: #{v}"
        if Answer.where(:question_id => k, :correct => true).pluck(:id).sort == v.keys.map{|f| f.to_i}.sort
              g=1 #?? HOW!!
         else
              g=0
         end
         
         print "g isssss #{Answer.where(:question_id => k, :correct => true).pluck(:id).sort} and #{v.keys.map{|f| f.to_i}.sort}"
         #should find better way to record results, now put same number in all answers
         
        #@answers[b].keys.each do |k|
          v.keys.each do |p|
            #delete old ones first!!
            #plus need to handle radio or checkbox!!
            
            QuizGrade.create(:user_id => @user_id, :quiz_id => @quiz_id, :question_id => k, :answer_id => p, :grade => g  )
          end
        #end
      end
      #QuizGrade.create(:user_id => @user_id, :quiz_id => @quiz_id, :question_id => a[0], :answer_id => a[1], :grade => 0  )
    #end
    
    respond_to do |format|
      format.html {redirect_to courseware_course_path(params[:id], :q => @quiz_id), notice: 'Quiz was successfully submitted.'}
    end
    end
  end
end
