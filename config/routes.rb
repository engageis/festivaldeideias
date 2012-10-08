FestivalDeIdeias::Application.routes.draw do

  # First role routes
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  # Authentication
  resources :sessions, :only => [:new]
  match '/auth/:provider/callback', :to => 'sessions#create',                 :as => :session_create
  match '/logout',                  :to => 'sessions#destroy',                :as => :session_destroy
  match '/connect_with_facebook',   :to => 'sessions#connect_with_facebook',  :as => :connect_with_facebook
  match '/notifications',           :to => 'users#notifications',             :as => :notifications

  #Resources 
  resources :users do
    member do
      put 'update_notification', :as => :update_notification
    end
  end
  resources :ideas do
    member do
      put "colaborate",                   :as => :colaborate
      get "accept_collaboration",         :as => :accept_collaboration
      get "refuse_collaboration",         :as => :refuse_collaboration
      get "collaboration",                :as => :collaboration
      get "ramify",                       :as => :ramify
      get "pin_show"
    end
    collection do
      get "map"
    end
    resources :messages, only: [:new, :create, :index]
  end
  resources :non_facebook_users, :only => [:create]

  scope '/navegue-nas-ideias' do
    get '/'         => redirect('/navegue-nas-ideias/popular'), :as => :scope_root
    get 'popular'   => "ideas#popular",                         :as => :scope_popular
    get 'recent'    => "ideas#recent",                          :as => :scope_recent
    get 'latest'    => "ideas#modified",                        :as => :scope_latest
    get 'featured'  => "ideas#featured",                        :as => :scope_featured
    get 'search'    => "ideas#search",                          :as => :scope_search

    # Match relations ideas vs categories
    get ":idea_category_id/ideias",       :to => "ideas#category",  :as => :category_ideas
  end
  get '/ideias', :to => "ideas#index"

  scope '/ideias' do
    get ":idea_category_id/ideia/:id",      :to => "ideas#show",            :as => :category_idea
    get ":idea_category_id/ideia/:id/edit", :to => "ideas#edit",            :as => :edit_category_idea
    get ":idea_category_id/ideia/:id/cocreate", :to => "ideas#cocreate",        :as => :cocreate_idea
  end

  root :to => 'ideas#index',              :defaults => { :recent => true }

  resources :pages, :only => [] do
    collection { post :sort }
  end

  resources :timeline, :only => [:index]

  # Pages (have to be in the EOF)
  get '/:id',                             :to => 'pages#show',      :as => :page


  unless Rails.env.production?
    get "/miv" => "miv#index" 
  end
end
