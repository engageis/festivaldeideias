ActiveAdmin.register IdeaCategory, :as => "Categorias" do
  menu :label => "Categorias"



  form do |f|
    f.inputs "Details" do
      f.input :name, :as => :string
      f.input :description, :as => :string
    end
    f.inputs "Files" do
      f.input :badge, :as => :file
    end
    f.buttons
  end
end
