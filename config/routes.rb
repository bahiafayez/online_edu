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
  end
    match '/events(/:year(/:month))' => 'events#index', :as => :event, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
    match "events/:id" => "events#show"
    resources :announcements
    resources :groups do #at first had it over quizzes and lectures, but then a lecture/quiz might not be part of a module! so shouldn't need module to access lecture.. could create lectures and then put them part of a group.
      member do
        get 'new_or_edit'
        get 'group_editor'
      end
      collection do
        post 'sort'
      end
    end
    resources :quizzes do
      member do
        get 'new_or_edit'
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
  resources :users
end