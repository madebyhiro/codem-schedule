Scheduler::Application.routes.draw do
  namespace :api do
    resources :jobs do
      collection do
        get :scheduled
        get :accepted
        get :processing
        get :on_hold
        get :success
        get :completed
        get :failed
      end

      member do
        resources :state_changes
        resources :notifications
      end
    end

    match '/schedule' => 'scheduler#schedule'
    
    resources :presets
    
    resources :hosts
    
    match '/statistics' => 'statistics#show'
  end

  resources :jobs, :presets, :hosts
  
  match '/' => redirect('/jobs')
end
