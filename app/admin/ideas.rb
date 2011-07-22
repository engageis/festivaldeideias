ActiveAdmin.register Idea do

  index do
    column :name do |idea|
      link_to idea.title, admin_idea_path(idea)
    end
    column :headline
    default_actions
  end

end
