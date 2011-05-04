Scheduler::Application.routes.draw do
  namespace :api do
    resources :jobs
  end
end
