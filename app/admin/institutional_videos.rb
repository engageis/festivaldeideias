#coding: utf-8

ActiveAdmin.register InstitutionalVideo do
  
  menu :label => "Vídeos institucionais"

  index do
    column :id
    column :video_url
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
      f.input :video_url
      f.input :visible
    end
    f.buttons
  end
  
end
