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

  # Pages
  get "sobre-o-festival"    => "pages#about",       :as => :about_page
  get "sobre-os-temas"      => "pages#themes",      :as => :themes_page
  get "regulamento"         => "pages#regulation",  :as => :regulation_page
  get "premiacao"           => "pages#awards",      :as => :awards_page
  #get "navegue-nas-ideias"  => "pages#navigate",    :as => :navigate_page

  # Scopes
  # NOTE: Mudado a pedidos da Natália
  scope '/navegue-nas-ideias' do
    get '/'        => redirect('/navegue-nas-ideias/popular')
    get 'popular'  => "ideas#index", :defaults => { :popular  => true }, :as => :scope_popular
    get 'recent'   => "ideas#index", :defaults => { :recent   => true }, :as => :scope_recent
    get 'latest'   => "ideas#index", :defaults => { :latest   => true }, :as => :scope_latest
    get 'featured' => "ideas#index", :defaults => { :featured => true }, :as => :scope_featured

    # Match relations ideas vs categories
    match ":idea_category_id/ideias",      :to => "ideas#index", :as => :category_ideas
  end

  scope '/ideias' do
    match ":idea_category_id/ideia/:id",   :to => "ideas#show",  :as => :category_idea
  end

  ## Match relations ideas vs categories
  #match ":idea_category_id/ideia/:id",   :to => "ideas#show",  :as => :category_idea
  #match ":idea_category_id/ideias",      :to => "ideas#index", :as => :category_ideas

  get "/miv" => "miv#index" if Rails.env.development?
  #root :to => redirect("/featured")
  root :to => 'ideas#index'
end
