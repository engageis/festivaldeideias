# coding: utf-8
ActiveAdmin.register Idea do
  menu :label => "Curação de ideias"

  index do
    column "Capa?" do |s|
      span s.featured?
    end
    column "Posição" do |s|
      span s.position
    end
    column :title
    column :headline
    column :created_at
    column :updated_at
    default_actions
  end
end

