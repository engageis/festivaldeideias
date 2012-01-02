FestivalDeIdeias::Application.routes.draw do

   match '/auth/:provider/callback', :to => 'sessions#create', :as => :session_create
  match '/logout', :to => 'sessions#destroy', :as => :session_destroy


  resources :users
  resources :ideas

  get "/index" => "ideas#homepage"
  get "/miv" => "miv#index" if Rails.env.development?
  root :to => "ideas#index"

end
