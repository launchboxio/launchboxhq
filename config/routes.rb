# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :admins
  devise_for :users

  namespace :auth do
    resources :cluster_roles
    resources :roles
    resources :groups
  end

  resources :organizations
  resources :cluster_addons
  resources :addons
  resources :projects

  scope constraints: { subdomain: 'auth' } do
    use_doorkeeper_openid_connect
    use_doorkeeper

    get 'auth/:provider/callback', to: 'sessions#create'
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

  root 'projects#index'

end
