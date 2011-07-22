ActiveAdmin.register Configuration do
  controller.authorize_resource

  menu :if => lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Configuration)
  }

  index do
    column :name do |configuration|
      link_to configuration.name, admin_configuration_path(configuration)
    end
    column :value
    default_actions
  end
end
