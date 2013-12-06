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
        delete :purge
      end

      member do
        post :retry
      end

      member do
        resources :state_changes
        resources :notifications
      end
    end

    match '/schedule' => 'scheduler#schedule'

    resources :presets do
      collection do
        get 'find(/:name)' => 'presets#find'
      end
    end

    resources :hosts

    match '/statistics' => 'statistics#show'
  end

  resources :jobs

  resources :presets, :hosts

  root :to => 'dashboard#show'
end
