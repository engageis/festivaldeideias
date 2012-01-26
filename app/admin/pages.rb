# coding: utf-8
ActiveAdmin.register Page do
  menu :label => "Páginas"

  filter :title
  filter :body
  filter :created_at
  filter :updated_at

  index do
    column :id
    column :title
    column :created_at do |s|
      s.created_at.strftime('%d/%m/%Y')
    end
    column :updated_at do |s|
      s.updated_at.strftime('%d/%m/%Y')
    end
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :body, :input_html => { :class => 'mceEditor' }
    end
    f.buttons
  end
end


