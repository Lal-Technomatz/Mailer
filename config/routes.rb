require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  get 'items_imports/new'
  get 'items_imports/create'
  root "users#index"

  resources :users do
    collection do
      get 'send_multiple_mail'
      post 'send_multiple_mail'
      post 'import'
    end
  end

  resources :templates do
    get 'add_template'
    post 'add_template'
  end

  resources :items_imports, only: [:new, :create]
end
