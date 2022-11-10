Rails.application.routes.draw do
  use_doorkeeper_openid_connect
  use_doorkeeper
  resources :addons
  devise_for :admins
  devise_for :users

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

  scope module: :api, defaults: { format: :json }, path: 'api' do
    scope module: :v1 do
      resources :clusters
    end
  end

  root "home#index"
end
