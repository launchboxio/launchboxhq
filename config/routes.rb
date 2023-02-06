# frozen_string_literal: true

Rails.application.routes.draw do

  namespace :auth do
    resources :cluster_roles
    resources :roles
    resources :groups
  end

  resources :organizations
  resources :cluster_addons
  resources :addons

  scope constraints: { subdomain: 'auth' } do
    use_doorkeeper_openid_connect
    use_doorkeeper

    devise_for :admins
    devise_for :users

    get 'auth/:provider/callback', to: 'sessions#create'
  end

  scope module: :api, defaults: { format: :json }, constraints: { subdomain: 'api' } do
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
        resources :addons
      end
      resources :addons
    end
  end

  scope module: :tenants, constraints: { subdomain: 'tenants' } do
    resources :tenants
  end

  root 'components#index'

end
