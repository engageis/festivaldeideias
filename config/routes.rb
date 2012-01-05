FestivalDeIdeias::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match '/auth/:provider/callback', :to => 'sessions#create', :as => :session_create
  match '/logout', :to => 'sessions#destroy', :as => :session_destroy


  resources :users

  get "sobre-o-festival" => "pages#about"
  get "sobre-os-temas" => "pages#themes"
  get "regulamento" => "pages#regulation"
  get "premiacao" => "pages#awards"
  get "navegue-nas-ideias" => "ideas#navigate"

  match ":idea_category/ideias/:id", :to => "ideas#show", :as => :idea_category_idea
  match ":idea_category/ideias", :to => "ideas#index", :as => :idea_category_ideas

  get "/miv" => "miv#index" if Rails.env.development?
  root :to => "ideas#index"

end
