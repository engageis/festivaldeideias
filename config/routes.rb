FestivalDeIdeias::Application.routes.draw do


  match '/ideas/mais-colaboradas' => "pages#ideas_more_active", :as => :ideas_more_active
  if Rails.env.development?
    get "/miv", to: "miv#index"
  end

end
