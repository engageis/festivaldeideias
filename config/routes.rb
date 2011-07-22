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
  
  match "/fake_login" => "sessions#fake_create", :as => :fake_login if Rails.env.test?

  match "/my_profile" => "users#my_profile", :as => :my_profile

  resources :ideas, :only => [:index, :create, :update, :show] do
    collection do
      get 'explore'
    end
    member do
      post 'create_fork'
      put 'merge'
      get 'review_conflicts/:from_id', :as => :review_conflicts, :action => :review_conflicts
    end
  end
  
  resources :users, :only => [:show, :update] do
    collection do
      get 'my_profile'
    end
  end
  
end
