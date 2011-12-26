FestivalDeIdeias::Application.routes.draw do
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/logout', :to => 'sessions#destroy'
  match '/ideas/mais-colaboradas' => "pages#ideas_more_active", :as => :ideas_more_active
  resources :users
  get "/miv" => "miv#index" if Rails.env.development?

  root :to => "pages#ideas_more_active"

end
