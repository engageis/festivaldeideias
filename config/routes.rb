FestivalDeIdeias::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match '/auth/:provider/callback', :to => 'sessions#create', :as => :session_create
  match '/logout', :to => 'sessions#destroy', :as => :session_destroy


  resources :users
  resources :ideas

  get "/miv" => "miv#index" if Rails.env.development?
  root :to => "ideas#index"

end
