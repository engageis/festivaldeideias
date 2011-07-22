ActiveAdmin.register User do
  controller.authorize_resource

  scope_to :current_site

  index do
    column :name do |configuration|
      link_to configuration.name, admin_configuration_path(configuration)
    end
    column :email
    default_actions
  end

  form :html => {:multipart => true} do |f|
    f.inputs do
      f.input :name, :as => :string
      f.input :email, :as => :string
      f.input :nickname, :as => :string
      f.input :bio, :as => :text
    end
    f.buttons do
      f.submit
    end
  end

end