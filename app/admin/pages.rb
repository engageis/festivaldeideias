# coding: utf-8

ActiveAdmin.register Page, { :sort_order => 'position, created_ad' } do |a|

  menu :label => "Páginas"

  filter :title
  filter :body
  filter :created_at
  filter :updated_at

  index do
    input :type => 'hidden', :id => 'update-url', :"data-update-url" => sort_pages_url

    column :title, :sortable => false

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
    f.actions
  end
end


