FestivalDeIdeias::Application.routes.draw do
  match '/auth/:provider/callback', :to => 'sessions#create', :as => :session_create
  match '/logout', :to => 'sessions#destroy', :as => :session_destroy
  match '/ideas/mais-colaboradas' => "pages#most_active_ideas", :as => :most_active_ideas


  resources :users
  get "/miv" => "miv#index" if Rails.env.development?
  get "/idea" => "pages#idea"

  root :to => "pages#most_active_ideas"

end
