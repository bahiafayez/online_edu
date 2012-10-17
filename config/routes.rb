OnlineEdu::Application.routes.draw do
  resources :answers

  resources :questions

  

  resources :courses do
  member do
    get 'remove_student'
    get 'add_student'
    get 'student_show'
    get 'courseware'
    get 'progress'
    post 'student_quiz'
  end
    resources :quizzes
end

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end