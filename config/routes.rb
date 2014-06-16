Scheduler::Application.routes.draw do
  namespace :api do
    resources :jobs do
      collection do
        get :scheduled
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

    get '/probe'   => 'api#probe'
    get '/schedule' => 'scheduler#schedule'

    resources :presets

    resources :hosts

    get '/statistics' => 'statistics#show'
  end

  resources :jobs

  resources :presets, :hosts

  root :to => 'dashboard#show'
end
