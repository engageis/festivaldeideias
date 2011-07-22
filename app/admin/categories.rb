ActiveAdmin.register Category do
  controller.authorize_resource

  menu :if => lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Category)
  }

  index do
    column :name do |category|
      link_to category.name, admin_category_path(category)
    end
    column :badge
    default_actions
  end

  # def show do
  #   h3 category.name
  # end

  form :html => {:multipart => true} do |f|
    f.inputs do
      f.input :name, :as => :string
      f.input :badge, :as => :file
    end
    f.buttons do
      f.submit
    end
  end

end
