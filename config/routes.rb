FestivalDeIdeias::Application.routes.draw do

  # First role routes
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  # Authentication
  match '/auth/:provider/callback', :to => 'sessions#create',   :as => :session_create
  match '/logout',                  :to => 'sessions#destroy',  :as => :session_destroy

  # Resources
  resources :users
  resources :ideas, :only => [:create]

  # Pages
  get "sobre-o-festival"    => "pages#about",       :as => :about_page
  get "sobre-os-temas"      => "pages#themes",      :as => :themes_page
  get "regulamento"         => "pages#regulation",  :as => :regulation_page
  get "premiacao"           => "pages#awards",      :as => :awards_page
  get "navegue-nas-ideias"  => "ideas#navigate",    :as => :navigate_page

  # Scopes
  get 'popular' => "ideas#index",     :defaults => { :popular  => true },   :as => :scope_popular
  get 'recent'  => "ideas#index",     :defaults => { :recent   => true },   :as => :scope_recent
  get 'latest'  => "ideas#index",     :defaults => { :latest   => true },   :as => :scope_latest
  get 'featured' => "ideas#index",    :defaults => { :featured => true },   :as => :scope_featured

  # Match relations ideas vs categories
  match ":idea_category_id/ideia/:id",   :to => "ideas#show",  :as => :category_idea
  match ":idea_category_id/ideias",      :to => "ideas#index", :as => :category_ideas

  get "/miv" => "miv#index" if Rails.env.development?
  root :to => redirect("/featured")
end
