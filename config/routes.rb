Scheduler::Application.routes.draw do
  namespace :api do
    resources :jobs do
      collection do
        get :scheduled
        get :accepted
        get :processing
        get :on_hold
        get :success
        get :failed
      end

      member do
        resources :state_changes
      end
    end
    
    resources :presets
  end
  
  resources :jobs, :presets, :hosts
  
  match '/' => redirect('/jobs')
end
