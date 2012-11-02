OnlineEdu::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

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
    resources :quizzes
    resources :lectures do
      member do
        get 'add_quiz'
        get 'remove_quiz'
        get 'coordinates'
        get 'add_answer'
        get 'remove_answer'
        get 'get_answers'
        get 'save_answers'
      end
    end
    
end

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end