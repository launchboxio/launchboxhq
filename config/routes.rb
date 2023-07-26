# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users

  get '/status/ready', to: 'status#ready'
  get '/status/health', to: 'status#health'

  namespace :auth do
    resources :cluster_roles
    resources :roles
    resources :groups
  end

  scope '/admin/', module: :admin, as: :admin do
    root 'clusters#index'
    resources :cluster_addons
    resources :addons
    resources :clusters
  end

  resources :organizations

  resources :projects

  # Profile routes
  get '/profile', to: 'profile#index'

  resources :access_tokens, only: [:create, :update, :delete]

  use_doorkeeper_openid_connect
  use_doorkeeper

  get 'auth/:provider/callback', to: 'sessions#create'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :clusters do
        resources :cluster_addons
        resources :agents
      end
      resources :projects do
        member do
          post 'pause'
          post 'resume'
        end
        resources :addons, controller: 'project_addons'
      end
      resources :addons
    end
  end

  scope module: :tenants, constraints: { subdomain: 'tenants' } do
    resources :tenants
  end

  root 'projects#index'

end
