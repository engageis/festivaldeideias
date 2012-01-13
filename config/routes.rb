FestivalDeIdeias::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match '/auth/:provider/callback', :to => 'sessions#create',   :as => :session_create
  match '/logout',                  :to => 'sessions#destroy',  :as => :session_destroy


  resources :users
  resources :ideas, :only => [:create]

  get "sobre-o-festival"    => "pages#about",       :as => :about_page
  get "sobre-os-temas"      => "pages#themes",      :as => :themes_page
  get "regulamento"         => "pages#regulation",  :as => :regulation_page
  get "premiacao"           => "pages#awards",      :as => :awards_page
  get "navegue-nas-ideias"  => "ideas#navigate",    :as => :navigate_page

  match ":idea_category_id/ideia/:id",   :to => "ideas#show",  :as => :category_idea
  match ":idea_category_id/ideias",      :to => "ideas#index", :as => :category_ideas

  get "/miv" => "miv#index" if Rails.env.development?
  root :to => "ideas#index"
end
