ActiveAdmin.register Configuration do
  index do
    column :name do |configuration|
      link_to configuration.name, admin_configuration_path(configuration)
    end
    column :value
  end
end
