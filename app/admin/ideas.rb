ActiveAdmin.register Idea do

  scope_to :current_site
  
  scope :all
  scope :recommended
  scope :featured
  scope :not_featured
  scope :popular
  scope :recent
  scope :primary
  scope :secondary

  index do
    column :name do |idea|
      link_to idea.title, admin_idea_path(idea)
    end
    column :headline
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :category
      f.input :title, :as => :string
      f.input :headline
      f.input :featured
      f.input :recommended
      f.input :order
    end

    f.buttons do
      f.submit
    end
  end

end
