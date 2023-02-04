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

  resources :clusters do
    collection do
      get :import
    end
  end

  resources :projects do
    member do
      get :logs
    end
  end

  resources :agents

  scope module: :api, defaults: { format: :json }, path: 'api' do
    namespace :v1 do
      resources :clusters do
        resources :cluster_addons
      end
      resources :agents, only: %i[create show update destroy]
      resources :projects do
        resources :addons
      end
      resources :addons
    end
  end

  scope module: :tenants, constraints: { subdomain: 'tenants' } do
    resources :tenants
  end

  root 'projects#index'

  # Configure tenants section
  #
end
