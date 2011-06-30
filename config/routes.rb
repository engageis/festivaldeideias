Ramify::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  filter :locale
  
  root :to => "ideas#index"

  post "/pre_auth" => "sessions#pre_auth", :as => :pre_auth
  get "/auth" => "sessions#auth", :as => :auth
  get "/post_auth" => "sessions#post_auth", :as => :post_auth
  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/failure" => "sessions#failure"
  match "/logout" => "sessions#destroy", :as => :logout

  resources :ideas
  
end
