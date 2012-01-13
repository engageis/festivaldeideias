ActiveAdmin.register IdeaCategory do
  menu :label => "Categorias"


  index do
    column :badge do |s|
      image_tag s.badge.url, :size => "31x31"
    end
    column :id
    column :name
    column :created_at
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :name, :as => :string
      f.input :description, :as => :string
    end
    f.inputs "Badge" do
      f.input :badge, :as => :file
    end
    f.buttons
  end
end
