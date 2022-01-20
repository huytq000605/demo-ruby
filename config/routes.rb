require 'sidekiq/web'

Rails.application.routes.draw do
  get 'test', to: 'gmail#test'
  get 'gmail', to: 'gmail#index'
  get 'get_mail', to: 'gmail#get_email'
  get 'grpc/call'
  get 'kafka/produce'
  resources :posts do
    resources :comments, shalow: true
  end
  get 'api/v1/integrations/microsoft_oauth_callback', to: 'omni#callback'
  # resources :comments
  post 'users', to: 'users#create'
  post 'login', to: 'users#login'
  get 'users', to: 'users#index'
  mount Sidekiq::Web => "/sidekiq"
  mount Grape::Base, at: "/"
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
