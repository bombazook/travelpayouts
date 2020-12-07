Rails.application.routes.draw do
  resources :users, :only => [:create, :show] do
    resources :subscriptions, :only => [:create, :show]
    resources :programs, :only => [:index]
  end
  resources :programs, :only => [:index] do
    resources :subscriptions, :only => [:create, :show]
  end
  resources :subscriptions, :only => [:create], constraints: lambda { |request| request.content_type == 'application/vnd.api+json' }
  resources :subscriptions, :only => [:update]
end
