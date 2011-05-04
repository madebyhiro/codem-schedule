Scheduler::Application.routes.draw do
  root :to => "jobs#index"
  
  resources :jobs do
    collection do
      get :completed
      get :failed
      get :transcoding
    end  
  end
  
  resources :hosts
  
  resources :presets
  
  namespace :api do
    resources :jobs
  end
end
