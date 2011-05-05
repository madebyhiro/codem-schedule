Scheduler::Application.routes.draw do
  namespace :api do
    resources :jobs do
      collection do
        get :scheduled
        get :transcoding
        get :on_hold
        get :success
        get :failed
      end
    end
    
    resources :presets
  end
end
