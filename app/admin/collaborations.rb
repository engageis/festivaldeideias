#coding: utf-8

ActiveAdmin.register Collaboration do
  
  menu :label => "Colaborações"

  index do
    column "Ideia" do |c|
      link_to c.idea.title, c.idea
    end
    column "Usuário" do |c|
      link_to image_tag(c.user.avatar), admin_user_path(c.user)
    end
    column "Resposta a" do |c|
      link_to c.parent_id, admin_collaboration_path(c) if c.parent_id
    end
    column "Texto", :description
    column "Criado em" do |s|
      s.created_at.strftime('%d/%m/%Y')
    end
    default_actions
  end
  
end
