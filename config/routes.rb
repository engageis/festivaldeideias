# coding: utf-8

FestivalDeIdeias::Application.routes.draw do

  # First role routes
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  # Authentication
  match '/auth/:provider/callback', :to => 'sessions#create',                :as => :session_create
  match '/logout',                  :to => 'sessions#destroy',               :as => :session_destroy
  match '/connect_with_facebook',   :to => 'sessions#connect_with_facebook', :as => :connect_with_facebook

  # Resources
  resources :users
  resources :ideas
  resources :non_facebook_users, :only => [:create]

  # Scopes
  # NOTE: Mudado a pedidos da Natália
  scope '/navegue-nas-ideias' do
    get '/'        => redirect('/navegue-nas-ideias/popular'), :as => :scope_root
    get 'popular'  => "ideas#index", :defaults => { :popular  => true }, :as => :scope_popular
    get 'recent'   => "ideas#index", :defaults => { :recent   => true }, :as => :scope_recent
    get 'latest'   => "ideas#index", :defaults => { :latest   => true }, :as => :scope_latest
    get 'featured' => "ideas#index", :defaults => { :featured => true }, :as => :scope_featured

    # Match relations ideas vs categories
    match ":idea_category_id/ideias", :to => "ideas#index", :as => :category_ideas
  end

  scope '/ideias' do
    # Coisa da Natália... "É 'semântico!!'"
    match ":idea_category_id/ideia/:id", :to => "ideas#show",  :as => :category_idea
  end


  ## Match relations ideas vs categories
  #match ":idea_category_id/ideia/:id",   :to => "ideas#show",  :as => :category_idea
  #match ":idea_category_id/ideias",      :to => "ideas#index", :as => :category_ideas

  get "/miv" => "miv#index" if Rails.env.development?
  #root :to => redirect("/featured")
  root :to => 'ideas#index', :defaults => { :featured => true }

  # Pages
  # Tem que ficar no final
  match '/:id', :to => 'pages#show', :as => :page

end
