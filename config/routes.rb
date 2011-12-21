FestivalDeIdeias::Application.routes.draw do


  match '/ideas/mais-colaboradas' => "pages#ideas_more_active", :as => :ideas_more_active

end
