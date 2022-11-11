Rails.application.routes.draw do
  resources :cluster_addons
  use_doorkeeper_openid_connect
  use_doorkeeper
  resources :addons
  devise_for :admins
  devise_for :users
  get 'auth/:provider/callback', to: 'sessions#create'

  resources :clusters do
    collection do
      get :import
    end
  end

  resources :spaces do
    member do
      get :logs
    end
  end

  resources :agents

  scope module: :api, defaults: { format: :json }, path: 'api' do
    namespace :v1 do
      resources :clusters
      resources :agents, only: [:create, :show, :update, :destroy]
    end
  end

  root "spaces#index"
end
