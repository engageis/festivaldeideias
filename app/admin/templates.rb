ActiveAdmin.register Template do
  controller.authorize_resource

  menu :if => lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Template)
  }
end