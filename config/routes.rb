Ramify::Application.routes.draw do

  filter :locale
  
  ActiveAdmin.routes(self)

  root :to => "ideas#index"

  post "/pre_auth" => "sessions#pre_auth", :as => :pre_auth
  get "/auth" => "sessions#auth", :as => :auth
  get "/post_auth" => "sessions#post_auth", :as => :post_auth
  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/failure" => "sessions#failure"
  match "/logout" => "sessions#destroy", :as => :logout
  match "/admin/logout" => "sessions#destroy", :as => :logout

  match "/explore" => "ideas#explore", :as => :explore
  
  if Rails.env == "test"
    match "/fake_login" => "sessions#fake_create", :as => :fake_login
  end

  resources :ideas, :only => [:index, :new, :create, :show] do
    collection do
      get 'explore'
    end
  end
  
end
