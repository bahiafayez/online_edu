class CoursesController < ApplicationController
  load_and_authorize_resource   #cancan to check if user is allowed to perform an action. checks from ability.rb
  before_filter :correct_user, :except => [:index, :new, :create]
  before_filter :set_zone , :except => [:index, :new, :create]
  # GET /courses
  # GET /courses.json
  def correct_user
    # Checking to see if the current user is taking the course OR teaching the course, otherwise he is not authorised.
    @c=Course.find(params[:id])
    if !@c.users.include?(current_user) and !(@c.user == current_user)
      redirect_to courses_path, :alert => "You are not authorized to see requested page"
    end
  end
  
  def set_zone
    #Setting the time zone to the zone of the course, to be used throughout.
    @course=Course.find(params[:id])
    Time.zone= @course.time_zone
  end
  
  def index
    # The course index page, with all the courses the teacher is giving OR the student is taking.
    # If this is an <tt> instructor </tt> I show the courses he's giving, else, the courses he's taking.
    if can? :update, @course    
        @courses = current_user.subjects 
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
    @students= User.students
    
    # enrolled students
    @students2 = @course.enrolled_students  
    @student_ids= @students2.map{|a| a.id}
    
    #students not enrolled
    all_users2= @course.not_enrolled_students
    @student_ids2=all_users2.map{|a| a.id}
    
    #logger.debug("students areeeee #{@students}")

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
    
    # removing all groups that were removed already!
    logger.debug("course paramaeters areee #{params[:course]}")
    #params[:course][:groups_attributes].each do |k,v|
    #  if Group.where(:id => v["id"]).empty?
    #    params[:course][:groups_attributes].delete(k)
    #  end
    #end

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
  
  ##### stopped here .. test ely ta7t and refactor.
  
  def remove_student
    @course = params[:id]
    @student=User.find(params[:student])
    @student.remove_student(@course)
    
    logger.debug @course
    text="Done"
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
  
  # NEED TO DIVIDE THIS!!
  
  def courseware
    if params[:q]   #requesting quiz
      #@q= Quiz.find(params[:q]) 
      @q= Quiz.where(:id => params[:q], :course_id => params[:id]).first
      if @q.nil? || @q.appearance_time >= Time.zone.now || @q.group.nil?
        #params[:q]=nil
        redirect_to courseware_course_path(params[:id]), :alert => "No such quiz"
        puts "here redirecting to #{courseware_course_path(params[:id])}"
      else
      puts "q issssss #{@q.inspect}"
      @type="quiz"
      @typeGroup=@q.group.id
      @answers= QuizGrade.select("question_id, answer_id").where(:user_id=>current_user.id , :quiz_id=> params[:q])
      @correct_answers= QuizGrade.where(:user_id=>current_user.id , :quiz_id=> params[:q]).select("distinct(question_id), grade")
      @out={}
      @correct={}
      
      status = QuizStatus.where(:user_id => current_user.id, :quiz_id => @q.id, :course_id => params[:id])
      if (!status.empty? and status.first.status=="Submitted") #@q.due_date <= Time.zone.now or #won't disable if due date passed, but will know that submitted late.
        @disable=true
      end
      
      @alert_messages=[]
      @alert_messages<< "Due date has passed -  #{@q.due_date}" if @q.due_date <= Time.zone.now
      @alert_messages<<"You've already submitted the quiz" if !status.empty? and status.first.status=="Submitted"
      
      @answers.each do |a|
        if @out[a.question_id].nil?
            @out[a.question_id]=[a.answer_id]
        else
          @out[a.question_id]<<a.answer_id
        end   
      end
      
      #puts "correct_answers #{@correct_answers.length}"
      #puts "quiz count #{@q.questions}"
      
      #if @correct_answers.length == @q.questions.length   #Change this condition later, to display correct/incorrect IF and only IF quiz was submitted.
      if !status.empty? and status.first.status=="Submitted"
            @correct_answers.each do |s|
              @correct[s.question_id]= s.grade
              #puts "correct_answers #{s.question_id}"
            end
            
      end
      
      
      
      print "out isssss!!!!!!! #{@out}"
      end
    end
    
    if params[:l]   #requesting lecture
      #@q= Lecture.find(params[:l])
      @q= Lecture.where(:id => params[:l], :course_id => params[:id]).first
      if @q.nil? || @q.appearance_time >= Time.zone.now || @q.group.nil?
        redirect_to courseware_course_path(params[:id]), :alert => "No such lecture"
      else
      @type="lecture" 
      @typeGroup=@q.group.id
      @url= get_answers_course_lecture_path(params[:id], params[:l])
      @saveOnline= save_online_course_lecture_path(params[:id], params[:l])
      @answered_path= answered_course_lecture_path(params[:id], params[:l])
      @confused_path=confused_course_lecture_path(params[:id], params[:l])
      @back_path=back_course_lecture_path(params[:id], params[:l])
      @pause_path=pause_course_lecture_path(params[:id], params[:l])
      @confused_question_path= confused_question_course_lecture_path(params[:id], params[:l])
      @seen_path=seen_course_lecture_path(params[:id], params[:l])
      @evaluation_path=evaluations_path()
      @get_evaluation_path=get_evaluations_path()
      
      @first_evaluation= Evaluation.where(:course_id => params[:id], :lecture_id => params[:l], :user_id => current_user.id).empty?
      if !@first_evaluation
        @eval= Evaluation.where(:course_id => params[:id], :lecture_id => params[:l], :user_id => current_user.id).first
      end
      
      
      @alert_messages=[]
      @alert_messages<< "Due date has passed -  #{@q.due_date}" if @q.due_date <= Time.zone.now
      
      
      #viewed= LectureView.where(:user_id => current_user.id, :lecture_id => @q.id, :course_id => params[:id])
      #if !viewed.empty?
      #  @seen=viewed[0].percent
      #else
      #  @seen=0
      #end
      #@an= QuizGrade.select("question_id, answer_id").where(:user_id=>current_user.id , :quiz_id=> params[:q])
      #@out={}
      #@answers.each do |a|
      #  @out[a.question_id]=a.answer_id
      #end
      #print "out isssss!!!!!!! #{@out}"
      end
    end
    
  end
  
  def courseware_teacher
    
  end
  def enrolled_students
     @course = Course.find(params[:id])
     
    all_users2= @course.not_enrolled_students #not enrolled
    @students2 = @course.enrolled_students #enrolled
    #@students= User.students
    #ordered by name always
    if params[:type]
      @students =  User.order(:name).search(params[:search]).page(params[:page]).per(10) if params[:type]=="all"
      @students =  @students2.order(:name).search(params[:search]).page(params[:page]).per(10) if params[:type]=="enrolled"
      @students =  all_users2.order(:name).search(params[:search]).page(params[:page]).per(10) if params[:type]=="not"
    else
      @students =  User.order(:name).search(params[:search]).page(params[:page]).per(10)
    end

    
    # enrolled students
    #@students2 = @course.enrolled_students  
    @student_ids= @students2.map{|a| a.id}
    
    #students not enrolled
    #all_users2= @course.not_enrolled_students
    @student_ids2=all_users2.map{|a| a.id}
    
    logger.debug("students areeeee #{@students}")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
      format.js
    end
  end
  def progress
    
    #At the moment there are only quizzes.. later assigments, lectures, lecture quizzes,... graphs for grades..
    @course=Course.find(params[:id])
    @quizzes=[]
    @course.groups.each do |g|
      @quizzes<<g.quizzes if !g.quizzes.empty?
    end
    @quizzes.flatten! #to be in one array (nothing nested)
    @quizNames=[]
    @quizzes_taken=[]
    @quizScores=[]
    @quiztable={}
    puts @quizzes.inspect
    @quizzes.each do |q|
      #if !QuizGrade.where(:quiz_id => q.id, :user_id => current_user.id).empty?
      # all submitted quizzes
      
      if !QuizStatus.where(:quiz_id => q.id, :user_id => current_user.id, :course_id => params[:id], :status => "Submitted").empty?
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
        @quiztable[q.id]= [num,count]
        logger.debug("num isss #{num/count}")
        @quizScores<< num/count * 100
      else
        @quiztable[q.id]= [0,q.questions.count]
        @quizzes_taken<<q
        @quizNames<<q.name
        @quizScores<<0
      end
      
    end
    
    #Now loop on weeks
    @groups=@course.groups.where("appearance_time<= ?", Time.zone.now)
    #@quizGrades={}
    @lectureGrades={}
    current_user.online_quiz_grades.each do |o|
      @lectureGrades[o.online_quiz_id]=o.grade
    end
    
  end
  
  def progress_teacher
    @course=Course.find(params[:id])
    @students=@course.users
    @quizzes=@course.quizzes
    @student_names=[]
    @course.lectures.each do |l|
      puts l.name
      puts l.group
    end
   
   if params[:all_modules]  #when click on the modules - all modules, progress of each student in each module (done/not done/done but not on time)
     @matrix={}
     @type="group"
     @students.each do |s|
       @matrix[s.name]=s.grades(@course)  #returns for each module in the course, whether student finished r not and on time or not.
       puts @matrix
     end
     @mods=@course.groups.map{|m| m.name}
   end
   if params[:g] #shows all lectures in a module, and the quizzes in each lecture # also show a matrix with all the lectures inside the module and how each student performed (on time/late/not done)
      @modulechart=Group.where(:id => params[:g], :course_id => params[:id]).first
      if @modulechart.nil?
        redirect_to progress_teacher_course_path(params[:id]), :alert => "No such Module"
      end
      @type="group"
      
      @chart_data={}   #only count those that submitted their answers
      #exactly like lecture.. but all lectures on one graph... and make it bar i think.
      
      len=0;
      @correct=[]
      @size=[]
      @chart_data={} 
      @answers={}
      @qnames={}
      counter=0
      @modulechart.lectures.each_with_index do |l,index|
        l.online_quizzes.order(:time).each_with_index do |online_q, j|   
          content=online_q.question.gsub("'","")
          content=content.gsub /"/, ''
          @qnames["#{l.name} #{Time.at(online_q.time).gmtime.strftime('%R:%S')}"]="#{l.name}<br><a href='/courses/#{@course.id}/groups/#{@modulechart.id}/group_editor?lec=#{l.id}&quiz=#{online_q.id}' rel='popover' data-content='#{content}' > #{Time.at(online_q.time).gmtime.strftime('%R:%S')} </a>"
          @chart_data["#{l.name} #{Time.at(online_q.time).gmtime.strftime('%R:%S')}"] = []  
          @answers[counter] = []    
          online_q.online_answers.order('ycoor').each_with_index do |ans, i|
            @correct<<i if ans.correct
            # [(j + index*len)]= don;t need counter, just append wara ba3d..
            @chart_data["#{l.name} #{Time.at(online_q.time).gmtime.strftime('%R:%S')}"]<<OnlineQuizGrade.where(:online_quiz_id => online_q.id, :online_answer_id => ans.id).length  
            @answers[counter]<<ans.answer
            #must be ordered like this series=[{name => question1, data => [1,2,3,2,1]},{},{}] so first data is the count of question 1 in all quizzes
          end
          counter+=1
          len=l.online_quizzes.length  
        end
       end
      
      @correct=@correct.to_json
      @answers=@answers.to_json
      
      #also I want to get confused and Questions of that lecture
      @confused= Confused.where(:course_id => params[:id], :lecture_id =>params[:l])
      @confused_questions= LectureQuestion.where(:course_id => params[:id], :lecture_id => params[:l])
      
      
      max=0 
      @chart_data.values.each do |a|
        max=a.length if a.length>max
      end
      
      @chart_data.each do |k,v|
        while v.length < max
          v<<0
        end
      end
      
      
      
      @transposed=@chart_data.values.transpose
      @otherway=[]
      i=0;
      
      logger.debug("transposed isss")
      logger.debug("#{@transposed}")
      
      @transposed.each do |t|
        i+=1;
        @otherway<<{:name => "Answer #{i}", :data => t}
      end
      @otherway = @otherway.to_json
      
      ###### also want to add a matrix ##
      
       @matrixLecture={}
       @late={}
       @students.each do |s|
         @matrixLecture[s]=s.grades(@modulechart)  #returns for each module in the course, whether student finished r not and on time or not.
         @late[s]=s.late_days(@modulechart)
         #puts @late
       end
       print @late.inspect
       
       @mods=@modulechart.lectures.map{|m| m.name}
      
      
   end 
   if params[:all]  #show all the quizzes
     @type="quiz"
     @data=[]
    @quizScores=[]
      @quizzes.each do |q|
        @students.each do |s|
          @student_names<<s.name if !@student_names.include?(s.name)
          num=0
          QuizGrade.where(:quiz_id => q.id, :user_id => s.id).select("distinct(question_id), grade").each do |ques|
            if ques.grade==1
              num+=1.0
            end
          end
          @quizScores<< num/q.questions.count * 100 if !q.questions.empty?
      end
      @data<<{:name => q.name, :data => @quizScores}
      @quizScores=[]
    end
    logger.debug("student namesssss #{@student_names.inspect} size is #{@student_names.length}")
    @data = @data.to_json   #json : javascript object!!
   end
    
    ############ If quiz #################
    if params[:q]  #show a specific quiz
      @quizchart=Quiz.where(:id => params[:q], :course_id => params[:id]).first
      if @quizchart.nil?
        redirect_to progress_teacher_course_path(params[:id]), :alert => "No such quiz"
      end
      @type="quiz"
      
      @chart_data={}   #only count those that submitted their answers
      QuizStatus.where(:quiz_id => @quizchart.id, :course_id => params[:id], :status => "Submitted").pluck(:user_id).each do |student|
        QuizGrade.where(:quiz_id => @quizchart.id, :user_id => student).select("grade, question_id").group(:question_id, :grade).each_with_index do |question, index|
          @chart_data["#{index}"]=[0,0] if @chart_data["#{index}"].nil?
          if question.grade==0
            @chart_data["#{index}"][1] = (@chart_data["#{index}"][1]||0) + 1 #initialize to 0 if nil #incorrect
          else
            @chart_data["#{index}"][0] = (@chart_data["#{index}"][0]||0) + 1 #initialize to 0 if nil #correct
          end
        end
      end
      @chart_data_old= @chart_data
      @chart_data=@chart_data.to_json
      puts "chart data issssss #{@chart_data}"
    end
    ################## if lecture ###########
    if params[:l]   #requesting lecture
      #@q= Lecture.find(params[:l])
      @q= Lecture.where(:id => params[:l], :course_id => params[:id]).first
      if @q.nil?
        redirect_to progress_teacher_course_path(params[:id]), :alert => "No such lecture"
      end
      @type="lecture"
       
      @correct=[] 
      @chart_data={} 
      @q.online_quizzes.order(:time).each_with_index do |online_q, j|   
        @chart_data[Time.at(online_q.time).gmtime.strftime('%R:%S')] = []      
        online_q.online_answers.order('ycoor').each_with_index do |ans, i|
          @correct[j]=i if ans.correct
          @chart_data[Time.at(online_q.time).gmtime.strftime('%R:%S')]<<OnlineQuizGrade.where(:online_quiz_id => online_q.id, :online_answer_id => ans.id).length  
          #must be ordered like this series=[{name => question1, data => [1,2,3,2,1]},{},{}] so first data is the count of question 1 in all quizzes
        end  
      end
      
      @correct=@correct.to_json
      
      
      #also I want to get confused and Questions of that lecture
      @confused= Confused.where(:course_id => params[:id], :lecture_id =>params[:l])
      @confused_questions= LectureQuestion.where(:course_id => params[:id], :lecture_id => params[:l])
      @back = Back.where(:course_id => params[:id], :lecture_id => params[:l])
      @pause = Pause.where(:course_id => params[:id], :lecture_id => params[:l])
     
      @confused_chart= Confused.get_rounded_time(@confused.order(:time)) #right now I round up.
      @confused_chart=@confused_chart.to_json
      print @confused_chart
      
      @questions_chart2= LectureQuestion.get_rounded_time(@confused_questions.order(:time))
      @questions_chart = @questions_chart2.to_a.map{|v| v=[v[0],v[1][0]] } #getting the time [time,count]
      @questions =  @questions_chart2.to_a.map{|v| v=[v[0],v[1][1]] } #getting the questions [time,questions]
      print "questions are #{@questions_chart2}"
      @questions= Hash[@questions].to_json
      @questions_chart=@questions_chart.to_json
      
      @back_chart = Back.get_rounded_time(@back.order(:time))
      @back_chart=@back_chart.to_json
      
      @pause_chart = Pause.get_rounded_time(@pause.order(:time))
      @pause_chart=@pause_chart.to_json
      
      @evaluations=Evaluation.where(:course_id => params[:id], :lecture_id => @q.id)
      
      @min= Time.zone.parse(Time.seconds_to_time(0)).to_i*1000
      @max= Time.zone.parse(Time.seconds_to_time(@q.duration)).floor(15.seconds).to_i*1000
      
      #sort chart_data according to keys.
      
      #@chart_data=Hash[@chart_data.sort] #ordered in query instead
      
      #first need to make all of them the same size so that we can transpose. DONE
      # and we need to order answers by y coordinates.. DONE
      # also order online quizzes by time. DONE
      # need to indicate which is the correct answer.
      
      # there must be a better way than this!! here i make them all the same size by adding 0's to the smaller ones.
      max=0 
      @chart_data.values.each do |a|
        max=a.length if a.length>max
      end
      
      @chart_data.each do |k,v|
        while v.length < max
          v<<0
        end
      end
      
      
      
      @transposed=@chart_data.values.transpose
      @otherway=[]
      i=0;
      @transposed.each do |t|
        i+=1;
        @otherway<<{:name => "Answer #{i}", :data => t}
      end
      @otherway = @otherway.to_json
     end 
     
     #if progress chart
     if params[:p]  #progress chart, shows each students progress in quizzes/lectures and online quizzes
       @type="Progress"
       @p="Progress Chart"
       @student_progress={}
       @students.each do |s|
         #getting number of quizzes student solved in this course (long since course_id not in table.. should consider adding it)
         # now any question solved in the quiz and i consider it, later only consider those with status = submitted
         # % of quizzes solved
         @n_solved=QuizStatus.where(:user_id => s.id, :course_id => @course.id, :status => "Submitted").length     #s.quiz_grades.select('distinct quiz_id').select{|v| Course.find(@course.id).quizzes.pluck(:id).include?v.quiz_id}.length
         @n_total= Course.find(@course.id).quizzes.count
         #number of lectures where i count a lecture if atleast one online quiz is solved.
         #@nl_solved=s.online_quiz_grades.select('distinct lecture_id').select{|v| Course.find(@course.id).lectures.pluck(:id).include?v.lecture_id}.length
         
         # % of online quizzes solved.
         @nonline=s.online_quiz_grades.select{|v| Course.find(@course.id).lectures.pluck(:id).include?v.lecture_id}.length #all onlinequizzes in the course that the student solved
         @nonline_total = OnlineQuiz.all.select{|v| Course.find(@course.id).lectures.pluck(:id).include?v.lecture_id}.length #all onlinequizzes in the course
         
         # % of lectures viewed (75%) solved if finished 75%
         @nl_solved=LectureView.where(:course_id => @course.id, :user_id => s.id, :percent =>75).length
         @nl_total= Course.find(@course.id).lectures.count 
         
         if @n_solved.nil? || @n_total==0
           @result1=0
         else
           @result1=@n_solved.to_f/@n_total.to_f*100
         end
         
         if @nl_solved.nil? || @nl_total==0
           @result2=0
         else
           @result2=@nl_solved.to_f/@nl_total.to_f*100
         end
         
         if @nonline.nil? || @nonline_total==0
           @result3=0
         else
           @result3=@nonline.to_f/@nonline_total.to_f*100
         end
         
         @student_progress[s.id]=[s.name, @result1, @result2, @result3]
       end
       puts "student ength issss #{@student_progress.length}"
       @student_progress_json= @student_progress.to_json
       logger.debug("student progress is #{@student_progress_json}")
     end
     
     
     puts "correct is #{@correct}"
     #finding out which is the correct answer
      
    
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
    
   #saving quiz status
   
    @status=QuizStatus.create(:user_id => current_user.id, :quiz_id => params[:quiz], :course_id => params[:id], :status => "Saved") if QuizStatus.where(:user_id => current_user.id, :quiz_id => params[:quiz], :course_id => params[:id]).empty? 
    @status||= QuizStatus.where(:user_id => current_user.id, :quiz_id => params[:quiz], :course_id => params[:id])[0] 
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
     if params[:commit]=="Submit" and (@answers.empty? or @answers.keys.count < Quiz.find(@quiz_id).questions.count)  #there qere unanswered questions.
      redirect_to courseware_course_path(params[:id], :q=>@quiz_id), :alert => "There are unanswered questions"
    else 
    
    
    if params[:commit]=="Submit"
      @status.update_attributes(:status => "Submitted")
    end
    
    if params[:commit]=="Submit"
      msg="Quiz was successfully submitted"
    else
      msg="Quiz was successfully saved"
    end
    
    respond_to do |format|
      format.html {redirect_to courseware_course_path(params[:id], :q => @quiz_id), notice: msg}
    end
    end
  end
  
  def student_notifications
    #want to show all quiz deadlines
    @deadlines={}
    Quiz.where("course_id = ? and appearance_time < ?", params[:id], Time.zone.now).order("appearance_time desc").each do |q|
      if !q.group.nil? and q.group.appearance_time < Time.zone.now
        if @deadlines[q.appearance_time.to_formatted_s(:long_ordinal)].nil?
          @deadlines[q.appearance_time.to_formatted_s(:long_ordinal)]= [q.id]
        else
          @deadlines[q.appearance_time.to_formatted_s(:long_ordinal)]<< q.id
        end 
      end
    end
  end
  
  
  
  def course_editor
    @course= Course.find(params[:id])
    @to_return={}
    #getting order of lecture and quizzes in each module.
    @course.groups.each_with_index do |g,index|
       all = g.lectures + g.quizzes
       puts g
       puts all
       all.sort!{|x,y| ( x.position and y.position ) ? x.position <=> y.position : ( x.position ? -1 : 1 )  }
       @to_return[index]=[]
       all.each do |s|
         @to_return[index]<< "#{s.class.name.downcase}_#{s.id}"
       end
     end
     
     @to_return = @to_return.to_json 
  end
  
end
