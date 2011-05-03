Scheduler::Application.routes.draw do
  root :to => 'dashboard#index'

  resources :jobs do
    collection do
      get :completed
      get :failed
      get :transcoding
    end
  end
  
  resources :hosts do
    member do 
      get :status
    end
  end
  
  resources :presets

  namespace :api do
    resources :jobs
  end
end
