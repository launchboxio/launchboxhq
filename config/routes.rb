# frozen_string_literal: true

Rails.application.routes.draw do
  root 'projects#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  use_doorkeeper_openid_connect
  use_doorkeeper

  get '/status/ready', to: 'status#ready'
  get '/status/health', to: 'status#health'

  # namespace :auth do
  #   resources :cluster_roles
  #   resources :roles
  #   resources :groups
  # end

  scope '/admin/', module: :admin, as: :admin do
    root 'clusters#index'
    resources :cluster_addons
    resources :addons
    resources :clusters
  end

  resources :organizations

  resources :projects do
    scope module: :projects do
      resources :users, only: [:create, :destroy]
      resources :addons
      resources :deployments
    end
    get :kubeconfig, on: :member
  end

  resources :resources

  # Profile routes
  get '/profile', to: 'profile#index'

  scope module: :settings do
    get '/settings', to: 'settings#index'
    resources :access_tokens, as: 'tokens', only: [:index, :new, :create, :destroy]
    resources :connections, only: [:index, :destroy]
  end


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

end
