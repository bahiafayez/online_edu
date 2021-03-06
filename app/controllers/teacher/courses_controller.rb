class Teacher::CoursesController < TeacherController
  load_and_authorize_resource   #cancan to check if user is allowed to perform an action. checks from ability.rb
  # GET /courses
  # GET /courses.json
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
      @q= Quiz.find(params[:q]) 
      @type="quiz"
      @answers= QuizGrade.select("question_id, answer_id").where(:user_id=>current_user.id , :quiz_id=> params[:q])
      @out={}
      @answers.each do |a|
        @out[a.question_id]=a.answer_id
      end
      print "out isssss!!!!!!! #{@out}"
    end
    
    if params[:l]   #requesting lecture
      @q= Lecture.find(params[:l])
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
    @quizzes_taken=[]
    @quizzes.each do |q|
      if !QuizGrade.where(:quiz_id => q.id, :user_id => current_user.id).empty?
        @quizzes_taken<<q
      end
    end
    
  end
  
  def progress_teacher
    @course=Course.find(params[:id])
    @students=@course.users
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
    @answers=params[:answer]
    @quiz_id=params[:quiz]
    @user_id=current_user.id
    
    @answers.each do |a|
      QuizGrade.create(:user_id => @user_id, :quiz_id => @quiz_id, :question_id => a[0], :answer_id => a[1], :grade => 0  )
    end
    
    respond_to do |format|
      format.html {redirect_to courseware_course_path(params[:id], :q => @quiz_id), notice: 'Quiz was successfully submitted.'}
    end
    
  end
end
