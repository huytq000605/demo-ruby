require 'sidekiq/web'

Rails.application.routes.draw do
  get 'grpc/call'
  get 'kafka/produce'
  resources :posts do
    resources :comments, shalow: true
  end
  # resources :comments
  post 'users', to: 'users#create'
  post 'login', to: 'users#login'
  get 'users', to: 'users#index'
  mount Sidekiq::Web => "/sidekiq"
  mount Grape::Base, at: "/"
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
