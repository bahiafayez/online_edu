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
  end
    resources :groups #at first had it over quizzes and lectures, but then a lecture/quiz might not be part of a module! so shouldn't need module to access lecture.. could create lectures and then put them part of a group.
    resources :quizzes
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