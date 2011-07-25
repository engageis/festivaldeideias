ActiveAdmin.register Link do
  controller.authorize_resource

  menu :if => lambda{|tabs_renderer|
    controller.current_ability.can?(:read, Link)
  }
  
  scope_to :current_site
end