Rails.application.routes.draw do
  resources :addons
  devise_for :admins
  devise_for :users

  resources :clusters
  resources :spaces do
    member do
      get :logs
    end
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#index"
end
