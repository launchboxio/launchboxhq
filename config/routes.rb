# frozen_string_literal: true

Rails.application.routes.draw do
  root 'projects#index'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions'
  }
  use_doorkeeper_openid_connect
  use_doorkeeper

  get '/status/ready', to: 'status#ready'
  get '/status/health', to: 'status#health'

  scope '/admin/', module: :admin, as: :admin do
    root 'clusters#index'
    resources :cluster_addons
    resources :addons do
      resources :addon_versions, only: %i[update]
    end
    resources :clusters
    resources :users, only: %i[index show new create update]
  end

  resources :organizations
  resources :clusters, only: %i[index show]
  resources :addons, only: %i[index show]

  get 'services' => 'services#index'
  resources :repositories do
    resources :services
  end

  resources :projects do
    scope module: :projects do
      resources :users, only: %i[new create destroy]
      resources :addons
      resources :services
    end
    get :kubeconfig, on: :member
  end

  # Profile routes
  get '/profile', to: 'profile#index'

  scope module: :settings do
    get '/settings', to: 'settings#index'
    resources :access_tokens, as: 'tokens', only: %i[index new create destroy]
    resources :connections, only: %i[index destroy]
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :clusters do
        resources :cluster_addons
      end
      resources :projects, param: :project_id do
        member do
          post 'pause'
          post 'resume'
          get 'manifest'
        end
      end
      resources :services, only: %i[index show]

      resources :repositories do
        resources :services
      end
      resources :projects, only: [] do
        resources :addons, controller: 'project_addons'
        resources :services, controller: 'project_services'
      end
      resources :vcs_connections, only: %i[index show]
      resources :addons
    end
  end
end
