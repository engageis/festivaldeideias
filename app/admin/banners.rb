#coding: utf-8

ActiveAdmin.register Banner do
  
  menu :label => "Banners"

  index do
    column :id
    column :title
    column :description
    column :visible
    column "Criado em" do |s|
      s.created_at.strftime('%d/%m/%Y')
    end
    column "Atualizado" do |s|
      s.updated_at.strftime('%d/%m/%Y')
    end
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :link_text
      f.input :link_url
      f.input :image_url
      f.input :visible
    end
    f.buttons
  end
  
end
