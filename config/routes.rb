FestivalDeIdeias::Application.routes.draw do
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/sign_out', :to => 'sessions#destroy'

  match '/ideas/mais-colaboradas' => "pages#ideas_more_active", :as => :ideas_more_active

  root :to => "pages#ideas_more_active"

end
