ActiveAdmin.register Comment, :as => "UserComment" do

  index do
    column :comment do |comment|
      link_to comment.title, admin_comment_path(comment)
    end
    column :user do |user|
      link_to user.name, admin_user_path(user)
    end
    column :created_at
    column :updated_at
  end

end
