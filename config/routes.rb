OnlineEdu::Application.routes.draw do
  #resources :groups

  resources :online_quiz_grades

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  get "home/index"
  #get "courses/new"

  #get "courses/index"

  #get "courses/create"

  #get "courses/update"

  resources :online_answers

  resources :online_quizzes



  resources :quiz_grades

  resources :answers

  resources :questions
  
  resources :evaluations do
    collection do
      get 'get'
    end
  end

 # namespace :teacher do
 #   resources :courses
 # end  

  resources :courses do
  member do
    get 'remove_student'
    get 'add_student'
    get 'student_show'
    get 'courseware'
    get 'courseware_teacher'
    get 'enrolled_students'
    get 'progress_teacher'
    get 'progress_teacher_detailed'
    get 'progress'
    post 'student_quiz'
    get 'student_notifications'
    get 'course_editor'
    get 'student_grade'
    get 'dynamic_quizzes'
    get 'student_quiz_grade'
    get 'student_lecture_grade'
    get 'send_email'
    post 'send_email_through'
    get 'send_batch_email'
    post 'send_batch_email_through'
    
  end
    match '/events(/:year(/:month))' => 'events#index', :as => :event, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
    match "events/:id" => "events#show"
    resources :announcements do
      member do
        get 'reload'
      end
    end
    resources :groups do #at first had it over quizzes and lectures, but then a lecture/quiz might not be part of a module! so shouldn't need module to access lecture.. could create lectures and then put them part of a group.
      member do
        get 'new_or_edit'
        get 'group_editor'
        get 'statistics'
        get 'details'
        get 'display_quizzes'
        get 'display_questions'
      end
      collection do
        post 'sort'
      end
    end
    resources :quizzes do
      member do
        get 'new_or_edit'
        get 'middle'
        get 'details'
        put 'update_questions'
      end
      collection do
        post 'sort'
      end
    end
    resources :lectures do
      member do
        get 'add_quiz'
        get 'remove_quiz'
        get 'coordinates'
        get 'add_answer'
        get 'remove_answer'
        get 'get_answers'
        #get 'save_answers'
        get 'save_answers2'
        get 'save_online'
        get 'answered'
        get 'insert_quiz'
        get 'confused'
        get 'confused_question'
        get 'seen'
        get 'new_or_edit'
        get 'new_quiz'
        get 'save_duration'
        get 'back'
        get 'pause'
        get 'getOldData'
        get 'middle'
        get 'details'
        get 'reload_invideo_quizzes'
      end
      collection do
        post 'sort'
      end
    end    
  end

  authenticated :user do
    #root :to => 'home#index'
    root :to => 'courses#index' #later make this home#index when we have a home#index!!
  end
  
  #authenticated :admin_user do
  #  root :to => 'admin#dashboard'
  #end
  
  root :to => "home#index"
  devise_for :users
  resources :users do
    member do
      get "enroll"
      post "enroll_to_course"
    end
  end
  
end