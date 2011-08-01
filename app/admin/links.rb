ActiveAdmin.register Link do
  controller.authorize_resource

  menu :if => lambda{|tabs_renderer|
    controller.current_ability.can?(:read, Link)
  }
  
  index do
    column :name do |link|
      link_to link.name, admin_link_path(link)
    end
    default_actions
  end
  
  form do |f|
    f.inputs do
      f.input :name, :as => :string
      f.input :title, :as => :string
      f.input :href, :as => :string
      f.input :header
    end
    f.buttons do
      f.submit
    end
  end
  
  scope_to :current_site
end